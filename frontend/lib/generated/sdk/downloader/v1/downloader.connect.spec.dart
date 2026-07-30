//
//  Generated code. Do not modify.
//  source: downloader/v1/downloader.proto
//

import "package:connectrpc/connect.dart" as connect;
import "downloader.pb.dart" as downloaderv1downloader;

abstract final class DownloaderService {
  /// Fully-qualified name of the DownloaderService service.
  static const name = 'downloader.v1.DownloaderService';

  static const download = connect.Spec(
    '/$name/Download',
    connect.StreamType.unary,
    downloaderv1downloader.DownloadRequest.new,
    downloaderv1downloader.DownloadResponse.new,
  );
}
