import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homework/common/api/runner.dart';
import 'package:homework/common/api/transport_provider.dart';
import 'package:homework/common/result/result.dart';
import 'package:homework/generated/sdk/downloader/v1/downloader.connect.client.dart';
import 'package:homework/generated/sdk/downloader/v1/downloader.pb.dart';

final downloaderApiProvider = Provider<DownloaderServiceClient>((ref) {
  final transport = ref.watch(protectedTransportProvider);
  return DownloaderServiceClient(transport);
});

typedef ListParams = ({String? params, int? after, int? before, int? limit});

final downloadListProvider =
    AsyncNotifierProvider<DownloadListProvider, ListResponse>(
      DownloadListProvider.new,
    );

class DownloadListProvider extends AsyncNotifier<ListResponse> {
  DownloadListProvider();

  late final downloader = ref.watch(downloaderApiProvider);

  ListParams _params = (params: null, after: null, before: null, limit: null);

  ListParams get params => _params;

  @override
  FutureOr<ListResponse> build() async {
    return await loadDownloads();
  }

  Future<ListResponse> loadDownloads({ListParams? params}) async {
    if (params != null) {
      _params = params;
    }

    final val = ListRequest(
      query: _params.params,
      after: _params.after.toString(),
      before: _params.before.toString(),
      limit: Int64(_params.limit ?? 10),
    );

    return downloader.list(val);
  }

  Future<void> fetchNext({bool append = false}) async {
    final currentData = state.value;
    if (currentData == null) return;

    final resultDownload = currentData.result;
    if (!resultDownload.hasAfter() || resultDownload.after == 0) {
      return; // No more pages
    }

    final ListParams nextParams = (
      params: _params.params,
      after: resultDownload.after,
      before: null,
      limit: _params.limit,
    );

    state = const AsyncValue.loading();

    final da = await runReq(() => loadDownloads(params: nextParams));
    switch (da) {
      case Ok(:final value):
        if (append) {
          final combinedResults = [
            ...currentData.result.results,
            ...value.result.results,
          ];
          final combined = value.copyWith((r) {
            r.ensureResult().results.clear();
            r.ensureResult().results.addAll(combinedResults);
          });
          state = AsyncValue.data(combined);
        } else {
          state = AsyncValue.data(value);
        }
      case Error(:final error):
        state = AsyncValue.error(error, StackTrace.fromString(""));
    }
  }

  Future<void> fetchPrevious() async {
    final currentData = state.value;
    if (currentData == null) return;

    final resultDownload = currentData.result;
    if (!resultDownload.hasBefore() || resultDownload.before == 0) {
      return; // No previous page
    }

    final ListParams prevParams = (
      params: _params.params,
      after: null,
      before: resultDownload.before,
      limit: _params.limit,
    );

    state = const AsyncValue.loading();

    final da = await runReq(() => loadDownloads(params: prevParams));
    switch (da) {
      case Ok(:final value):
        state = AsyncValue.data(value);
      case Error(:final error):
        state = AsyncValue.error(error, StackTrace.fromString(""));
    }
  }

  Future<void> refresh() async {
    final ListParams resetParams = (
      params: _params.params,
      after: null,
      before: null,
      limit: _params.limit,
    );

    state = const AsyncValue.loading();

    final da = await runReq(() => loadDownloads(params: resetParams));
    switch (da) {
      case Ok(:final value):
        state = AsyncValue.data(value);
      case Error(:final error):
        state = AsyncValue.error(error, StackTrace.fromString(""));
    }
  }

  Future<void> search(String? query) async {
    final ListParams searchParams = (
      params: query,
      after: null,
      before: null,
      limit: _params.limit,
    );

    state = const AsyncValue.loading();

    final da = await runReq(() => loadDownloads(params: searchParams));
    switch (da) {
      case Ok(:final value):
        state = AsyncValue.data(value);
      case Error(:final error):
        state = AsyncValue.error(error, StackTrace.fromString(""));
    }
  }

  Future<void> updateLimit(int? newLimit) async {
    final ListParams newParams = (
      params: _params.params,
      after: null,
      before: null,
      limit: newLimit,
    );

    state = const AsyncValue.loading();

    final da = await runReq(() => loadDownloads(params: newParams));
    switch (da) {
      case Ok(:final value):
        state = AsyncValue.data(value);
      case Error(:final error):
        state = AsyncValue.error(error, StackTrace.fromString(""));
    }
  }
}
