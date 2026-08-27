import 'package:flutter/material.dart';
import 'package:homework/common/services/download/download.provider.dart';
import 'package:homework/generated/sdk/downloader/v1/downloader.pb.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CancelDownloadDialog extends ConsumerWidget {
  const CancelDownloadDialog({super.key, required this.download});

  final Download download;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          spacing: 10,
          mainAxisSize: .min,
          children: [
            Text("Cancel download", style: TextStyle(fontSize: 20)),
            Text("This will stop the download", style: TextStyle(fontSize: 20)),
            Text("Cancel download"),
            Row(
              spacing: 10,
              mainAxisSize: .min,
              mainAxisAlignment: .end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    ref
                        .read(downloaderApiProvider)
                        .cancel(CancelRequest(id: download.id));
                  },
                  child: Text("Confirm"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Close"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
