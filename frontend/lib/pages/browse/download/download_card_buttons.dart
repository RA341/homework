import 'package:flutter/material.dart';
import 'package:homework/common/api/endpoints/browser_provider.dart';
import 'package:homework/common/api/endpoints/download_provider.dart';
import 'package:homework/common/api/runner.dart';
import 'package:homework/common/result/result.dart';
import 'package:homework/components/copy_text.dart';
import 'package:homework/generated/sdk/browser/v1/browser.pb.dart';
import 'package:homework/generated/sdk/downloader/v1/downloader.pb.dart';
import 'package:homework/pages/browse/download/download_card_status.dart';
import 'package:homework/pages/browse/download/download_dialog_edit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

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
          icon: Icon(Icons.open_in_browser),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) =>
                  OpenBrowserDialog(downloadLink: download.downloadLink),
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

class OpenBrowserDialog extends ConsumerWidget {
  const OpenBrowserDialog({super.key, required this.downloadLink});

  final String downloadLink;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final browser = ref.watch(browserApiProvider);
    final browserVncLink = ref.watch(browserVncLinkProvider);

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: .min,
          spacing: 20,
          children: [
            Text("1. Start the browser"),
            ElevatedButton(
              onPressed: () async {
                final resp = await runReq(() => browser.start(StartRequest()));
              },
              child: Text("Start browser"),
            ),
            Text("2. Copy the url"),
            CopyableText(text: downloadLink),
            Text("3. Go to the browser and paste the link in"),
            Text("Optionally solve any captachas if needed"),
            ElevatedButton(
              onPressed: () async {
                if (!await launchUrl(browserVncLink)) {
                  // todo handle errors
                }
              },
              child: Text("Launch Browser Window"),
            ),
          ],
        ),
      ),
    );
  }
}
