import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:homework/common/api/download/download.provider.dart';
import 'package:homework/pages/browse/download/download_card.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DownloadsList extends HookConsumerWidget {
  const DownloadsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    final downloadList = ref.watch(downloadListProvider);
    final notifier = ref.read(downloadListProvider.notifier);
    final currentParams = notifier.params;

    // Synchronize search text input if search query is updated elsewhere
    useEffect(() {
      searchController.text = currentParams.params ?? '';
      return null;
    }, [currentParams.params]);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 1,
              child: IconButton(
                icon: const Icon(Icons.recycling),
                onPressed: () =>
                    ref.read(downloadListProvider.notifier).refresh(),
                tooltip: 'Refresh',
              ),
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search downloads...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              searchController.clear();
                              ref
                                  .read(downloadListProvider.notifier)
                                  .search(null);
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  onSubmitted: (val) => ref
                      .read(downloadListProvider.notifier)
                      .search(val.isEmpty ? null : val),
                ),
              ),
            ),
          ],
        ),
        // Download List
        Expanded(
          child: downloadList.when(
            data: (data) {
              final result = data.result;
              final downloads = result.results;

              if (downloads.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cloud_download_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No downloads found',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(color: Colors.grey[600]),
                      ),
                      if (currentParams.params != null) ...[
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () {
                            searchController.clear();
                            ref
                                .read(downloadListProvider.notifier)
                                .search(null);
                          },
                          child: const Text('Clear Search'),
                        ),
                      ],
                    ],
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: downloads.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final download = downloads[index];
                  return DownloadCard(download: download);
                },
              );
            },
            error: (error, stackTrace) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load downloads',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    error.toString(),
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        ref.read(downloadListProvider.notifier).refresh(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
        ),

        // Pagination Controls
        if (downloadList.hasValue)
          downloadList.whenData((data) {
                final result = data.result;
                final hasPrev = result.hasBefore() && result.before != 0;
                final hasNext = result.hasAfter() && result.after != 0;

                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    border: Border(
                      top: BorderSide(color: Colors.grey.withAlpha(51)),
                    ),
                  ),
                  child: SafeArea(
                    top: false,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Limit Selector
                        Row(
                          children: [
                            Text(
                              'Show: ',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            DropdownButton<int>(
                              value: currentParams.limit ?? 20,
                              items: [10, 20, 50, 100].map((int value) {
                                return DropdownMenuItem<int>(
                                  value: value,
                                  child: Text('$value'),
                                );
                              }).toList(),
                              onChanged: (newLimit) {
                                if (newLimit != null) {
                                  ref
                                      .read(downloadListProvider.notifier)
                                      .updateLimit(newLimit);
                                }
                              },
                            ),
                          ],
                        ),

                        // Navigation Buttons
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.chevron_left),
                              onPressed: hasPrev
                                  ? () => ref
                                        .read(downloadListProvider.notifier)
                                        .fetchPrevious()
                                  : null,
                              tooltip: 'Previous Page',
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.chevron_right),
                              onPressed: hasNext
                                  ? () => ref
                                        .read(downloadListProvider.notifier)
                                        .fetchNext()
                                  : null,
                              tooltip: 'Next Page',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).value ??
              const SizedBox.shrink(),
      ],
    );
  }
}
