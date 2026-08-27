import 'package:flutter/material.dart';
import 'package:homework/common/services/download/download.provider.list.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Paginator extends ConsumerWidget {
  const Paginator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final downloadListNotifier = ref.read(downloadListProvider.notifier);
    final currentParams = downloadListNotifier.params;

    final downloadProvider = ref.watch(downloadListProvider);

    if (!downloadProvider.hasValue) {
      return const SizedBox.shrink();
    }

    final result = downloadProvider.requireValue.result;
    final hasPrev = result.hasBefore() && result.before != 0;
    final hasNext = result.hasAfter() && result.after != 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(top: BorderSide(color: Colors.grey.withAlpha(51))),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Limit Selector
            Row(
              children: [
                Text('Show: ', style: Theme.of(context).textTheme.bodySmall),
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
                      ? () =>
                            ref.read(downloadListProvider.notifier).fetchNext()
                      : null,
                  tooltip: 'Next Page',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
