import 'package:flutter/material.dart';
import 'package:homework/common/theme/design_system.dart';
import 'package:homework/pages/browse/+layout.dart';
import 'package:homework/pages/browse/download/dialog_add_download.dart';
import 'package:homework/pages/browse/download/download.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DownloadPage extends ConsumerWidget {
  const DownloadPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BrowseLayout(
      activeTab: 0,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.gutter),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Placeholder Search Bar to show how it will look
            ElevatedButton(
              child: Text("Download"),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AddDownloadDialog(),
                );
              },
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                child: const ListDownload(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
