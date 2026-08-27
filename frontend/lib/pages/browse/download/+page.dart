import 'package:flutter/material.dart';
import 'package:homework/components/theme/design_system.dart';
import 'package:homework/pages/browse/+layout.dart';
import 'package:homework/pages/browse/download/components/button_refresh.dart';
import 'package:homework/pages/browse/download/components/dialog_add.dart';
import 'package:homework/pages/browse/download/components/stats_bar.dart';
import 'package:homework/pages/browse/download/download.dart';

class DownloadPage extends StatelessWidget {
  const DownloadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BrowseLayout(
      activeTab: 0,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.gutter),
        child: Column(
          spacing: 2,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const DownloadStatsBar(),
            Padding(
              padding: EdgeInsetsGeometry.symmetric(
                horizontal: AppSpacing.gutter,
              ),
              child: Row(
                children: [
                  const Expanded(flex: 4, child: SearchBar()),
                  const Expanded(flex: 1, child: RefreshListButton()),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      child: const Text("Download"),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => const AddDownloadDialog(),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                child: const DownloadsList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
