import 'package:flutter/material.dart';
import 'package:homework/pages/browse/download/provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EmptyDownloadList extends ConsumerWidget {
  const EmptyDownloadList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(downloadSearchProvider);

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
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
          ),
          if (searchQuery != null) ...[
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                ref.read(downloadSearchProvider.notifier).clear();
              },
              child: const Text('Clear Search'),
            ),
          ],
        ],
      ),
    );
  }
}
