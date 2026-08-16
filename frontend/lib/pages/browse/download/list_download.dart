import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:homework/common/api/endpoints/download_provider.dart';
import 'package:homework/common/api/runner.dart';
import 'package:homework/common/result/result.dart';
import 'package:homework/generated/sdk/downloader/v1/downloader.pb.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ListDownload extends HookConsumerWidget {
  const ListDownload({super.key});

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
                  return _DownloadCard(download: download);
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

class _DownloadCard extends ConsumerWidget {
  final Download download;

  const _DownloadCard({required this.download});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final downloader = ref.watch(downloaderApiProvider);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.withAlpha(25)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    download.name.isNotEmpty
                        ? download.name
                        : 'Unnamed Download',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => EditLinkDialog(download: download),
                    );
                  },
                ),
                IconButton(
                  onPressed: () async {
                    final resp = await runReq(
                      () => downloader.retry(RetryRequest(id: download.id)),
                    );
                    if (!context.mounted) return;

                    switch (resp) {
                      case Ok():
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Added to download queue")),
                        );
                      case Error(:final error):
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Error retrying: $error")),
                        );
                    }
                  },
                  icon: Icon(Icons.refresh),
                ),
                _StatusChip(state: download.status),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              download.downloadLink,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (download.downloadPath.isNotEmpty) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.folder_open, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      download.downloadPath,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
            if (download.status ==
                DownloadState.DOWNLOAD_STATE_DOWNLOADING) ...[
              ProgressDisplay(progress: download.progress),
            ],
            if (download.status == DownloadState.DOWNLOAD_STATE_ERROR &&
                download.progress.error.isNotEmpty)
              ...displayError(context),
          ],
        ),
      ),
    );
  }

  List<Widget> displayError(BuildContext context) {
    return [
      const SizedBox(height: 12),
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.red.withAlpha(51)),
        ),
        child: Text(
          download.progress.error,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.red[900]),
        ),
      ),
    ];
  }
}

String formatDuration(Duration d) {
  final h = d.inHours;
  final m = d.inMinutes.remainder(60);
  final s = d.inSeconds.remainder(60);

  final secs = '${s}s';
  if (m == 0) {
    return secs;
  }

  final minSecs = '${m}m $secs';
  if (h == 0) {
    return minSecs;
  }

  return '${h}h $minSecs';
}

String formatBytes(int bytes, [int decimals = 1]) {
  if (bytes <= 0) return '0 B';
  const units = ['B', 'KB', 'MB', 'GB', 'TB'];
  final i = (log(bytes) / log(1024)).floor();
  final size = bytes / pow(1024, i);
  return '${size.toStringAsFixed(i == 0 ? 0 : decimals)} ${units[i]}';
}

class ProgressDisplay extends StatelessWidget {
  const ProgressDisplay({super.key, required this.progress});

  final DownloadProgress progress;

  @override
  Widget build(BuildContext context) {
    final total = progress.complete.toInt() + progress.left.toInt();
    final progressState = total > 0 ? progress.complete.toDouble() / total : 0.0;

    final time = Duration(seconds: progress.timeLeftSecs.toInt());

    return Column(
      children: [
        const SizedBox(height: 12),
        Row(
          spacing: 10,
          mainAxisAlignment: .spaceBetween,
          children: [
            Text("Time: ${formatDuration(time)}"),
            Text("Total: ${formatBytes(total)}"),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(value: progressState),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${formatBytes(progress.complete.toInt())} complete'),
                Text('${formatBytes(progress.left.toInt())} left'),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class EditLinkDialog extends HookConsumerWidget {
  const EditLinkDialog({super.key, required this.download});

  final Download download;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final downloadLinkController = useTextEditingController(
      text: download.downloadLink,
    );
    final downloader = ref.watch(downloaderApiProvider);

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          spacing: 20,
          mainAxisSize: .min,
          children: [
            Text("Edit link ${download.id}"),
            TextField(controller: downloadLinkController),
            Row(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  label: Text("Cancel"),
                  icon: Icon(Icons.cancel),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    await runReq(
                      () => downloader.edit(
                        EditRequest(
                          downloadId: download.id,
                          downloadLink: downloadLinkController.text,
                        ),
                      ),
                    );
                    if (!context.mounted) return;

                    Navigator.of(context).pop();
                  },
                  label: Text("Save"),
                  icon: Icon(Icons.save),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final DownloadState state;

  const _StatusChip({required this.state});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    String label;
    IconData icon;

    switch (state) {
      case DownloadState.DOWNLOAD_STATE_QUEUED:
        backgroundColor = Colors.grey.shade100;
        textColor = Colors.grey.shade800;
        label = 'Queued';
        icon = Icons.hourglass_empty;
      case DownloadState.DOWNLOAD_STATE_DOWNLOADING:
        backgroundColor = Colors.blue.shade50;
        textColor = Colors.blue.shade700;
        label = 'Downloading';
        icon = Icons.downloading;
      case DownloadState.DOWNLOAD_STATE_SUCCESS:
        backgroundColor = Colors.green.shade50;
        textColor = Colors.green.shade700;
        label = 'Success';
        icon = Icons.check_circle_outline;
      case DownloadState.DOWNLOAD_STATE_ERROR:
        backgroundColor = Colors.red.shade50;
        textColor = Colors.red.shade700;
        label = 'Error';
        icon = Icons.error_outline;
      default:
        backgroundColor = Colors.grey.shade100;
        textColor = Colors.grey.shade800;
        label = 'Unknown';
        icon = Icons.help_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: textColor.withAlpha(51)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
