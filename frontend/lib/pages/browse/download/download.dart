import 'package:flutter/material.dart';
import 'package:homework/common/services/download/download.provider.list.dart';
import 'package:homework/pages/browse/download/components/card.dart';
import 'package:homework/pages/browse/download/components/empty.dart';
import 'package:homework/pages/browse/download/components/error.dart';
import 'package:homework/pages/browse/download/components/paginator.dart';
import 'package:homework/pages/browse/download/provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DownloadsList extends ConsumerWidget {
  const DownloadsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(downloadAutoRefreshProvider);
    final downloadList = ref.watch(downloadListProvider);

    return Column(
      children: [
        Expanded(
          child: downloadList.when(
            data: (data) {
              final downloads = data.result.results;

              if (downloads.isEmpty) {
                return EmptyDownloadList();
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
            error: (error, stackTrace) =>
                DownloadsError(error: error, stackTrace: stackTrace),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
        ),
        Paginator(),
      ],
    );
  }
}
