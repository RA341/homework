import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homework/common/services/download/download.provider.list.dart';
import 'package:homework/common/services/download/download.provider.stats.dart';

class RefreshListButton extends ConsumerWidget {
  const RefreshListButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: const Icon(Icons.recycling),
      onPressed: () {
        ref.read(downloadListProvider.notifier).refresh();
        ref.read(downloadStatsProvider.notifier).refresh();
      },
      tooltip: 'Refresh',
    );
  }
}
