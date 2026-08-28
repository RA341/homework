import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homework/common/api/runner.dart';
import 'package:homework/common/services/download/download.provider.dart';
import 'package:homework/common/utils/result.dart';
import 'package:homework/generated/sdk/downloader/v1/downloader.pb.dart';

final downloadStatsProvider =
    AsyncNotifierProvider<DownloadStatsProvider, StatsResponse>(
      DownloadStatsProvider.new,
    );

class DownloadStatsProvider extends AsyncNotifier<StatsResponse> {
  DownloadStatsProvider();

  late final downloader = ref.watch(downloaderApiProvider);

  @override
  FutureOr<StatsResponse> build() async {
    return await loadStats();
  }

  Future<StatsResponse> loadStats() async {
    return downloader.stats(StatsRequest());
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();

    final da = await runReq(() => loadStats());
    switch (da) {
      case Ok(:final value):
        state = AsyncValue.data(value);
      case Error(:final error):
        state = AsyncValue.error(error, StackTrace.fromString(""));
    }
  }

  Future<void> silentRefresh() async {
    if (state.isLoading) return;

    final da = await runReq(() => loadStats());
    switch (da) {
      case Ok(:final value):
        state = AsyncValue.data(value);
      case Error(:final error):
        if (!state.hasValue) {
          state = AsyncValue.error(error, StackTrace.fromString(""));
        }
    }
  }
}
