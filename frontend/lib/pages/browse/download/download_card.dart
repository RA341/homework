import 'package:flutter/material.dart';
import 'package:homework/generated/sdk/downloader/v1/downloader.pb.dart';
import 'package:homework/pages/browse/download/download_card_buttons.dart';
import 'package:homework/pages/browse/download/download_card_progress.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


class DownloadCard extends ConsumerWidget {
  final Download download;

  const DownloadCard({super.key, required this.download});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            DownloadActionButtons(download: download),
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
              DownloadProgressDisplay(progress: download.progress),
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
