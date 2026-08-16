//
//  Generated code. Do not modify.
//  source: downloader/v1/downloader.proto
//

import "package:connectrpc/connect.dart" as connect;
import "downloader.pb.dart" as downloaderv1downloader;
import "downloader.connect.spec.dart" as specs;

extension type DownloaderServiceClient (connect.Transport _transport) {
  Future<downloaderv1downloader.RetryResponse> retry(
    downloaderv1downloader.RetryRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.DownloaderService.retry,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<downloaderv1downloader.DownloadResponse> download(
    downloaderv1downloader.DownloadRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.DownloaderService.download,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<downloaderv1downloader.ListResponse> list(
    downloaderv1downloader.ListRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.DownloaderService.list,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<downloaderv1downloader.EditResponse> edit(
    downloaderv1downloader.EditRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.DownloaderService.edit,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
