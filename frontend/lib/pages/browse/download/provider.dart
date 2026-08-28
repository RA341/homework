import 'dart:async';

import 'package:homework/common/services/download/download.provider.list.dart';
import 'package:homework/common/services/download/download.provider.stats.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final downloadSearchProvider =
    NotifierProvider<DownloadSearchNotifier, String?>(
      DownloadSearchNotifier.new,
    );

class DownloadSearchNotifier extends Notifier<String?> {
  @override
  String? build() {
    return null;
  }

  void search(String? query) {
    final trimmed = query?.trim();
    final normalized = (trimmed == null || trimmed.isEmpty) ? null : trimmed;
    state = normalized;
    ref.read(downloadListProvider.notifier).search(normalized);
  }

  void clear() {
    state = null;
    ref.read(downloadListProvider.notifier).search(null);
  }
}

final downloadAutoRefreshProvider = Provider.autoDispose<void>((ref) {
  const refreshInterval = Duration(seconds: 2);

  final timer = Timer.periodic(refreshInterval, (_) {
    ref.read(downloadListProvider.notifier).silentRefresh();
    ref.read(downloadStatsProvider.notifier).silentRefresh();
  });

  ref.onDispose(timer.cancel);
});
