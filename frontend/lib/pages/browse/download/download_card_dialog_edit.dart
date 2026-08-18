import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:homework/common/api/download/download.provider.dart';
import 'package:homework/common/api/runner.dart';
import 'package:homework/generated/sdk/downloader/v1/downloader.pb.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DownloadEditLinkDialog extends HookConsumerWidget {
  const DownloadEditLinkDialog({super.key, required this.download});

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
