import 'package:flutter/material.dart';
import 'package:homework/common/api/endpoints/download_provider.dart';
import 'package:homework/common/api/runner.dart';
import 'package:homework/common/result/result.dart';
import 'package:homework/generated/sdk/downloader/v1/downloader.pb.dart';
import 'package:homework/pages/browse/download/download_card_dialog_edit.dart';
import 'package:homework/pages/browse/download/download_card_status.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DownloadActionButtons extends ConsumerWidget {
  const DownloadActionButtons({super.key, required this.download});

  final Download download;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final downloader = ref.watch(downloaderApiProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            download.name.isNotEmpty ? download.name : 'Unnamed Download',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => DownloadEditLinkDialog(download: download),
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
        StatusChip(state: download.status),
      ],
    );
  }
}

