//
//  Generated code. Do not modify.
//  source: download/v1/download.proto
//

import "package:connectrpc/connect.dart" as connect;
import "download.pb.dart" as downloadv1download;

abstract final class DownloadService {
  /// Fully-qualified name of the DownloadService service.
  static const name = 'download.v1.DownloadService';

  static const download = connect.Spec(
    '/$name/Download',
    connect.StreamType.unary,
    downloadv1download.DownloadRequest.new,
    downloadv1download.DownloadResponse.new,
  );
}
