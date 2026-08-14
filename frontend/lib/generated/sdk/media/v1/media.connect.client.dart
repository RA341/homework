//
//  Generated code. Do not modify.
//  source: media/v1/media.proto
//

import "package:connectrpc/connect.dart" as connect;
import "media.pb.dart" as mediav1media;
import "media.connect.spec.dart" as specs;

extension type MediaServiceClient (connect.Transport _transport) {
  Future<mediav1media.AddAndDownloadResponse> addAndDownload(
    mediav1media.AddAndDownloadRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.MediaService.addAndDownload,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
