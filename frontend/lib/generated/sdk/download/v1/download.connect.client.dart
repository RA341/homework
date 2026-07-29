//
//  Generated code. Do not modify.
//  source: download/v1/download.proto
//

import "package:connectrpc/connect.dart" as connect;
import "download.pb.dart" as downloadv1download;
import "download.connect.spec.dart" as specs;

extension type DownloadServiceClient (connect.Transport _transport) {
  Future<downloadv1download.DownloadResponse> download(
    downloadv1download.DownloadRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.DownloadService.download,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
