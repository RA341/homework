//
//  Generated code. Do not modify.
//  source: media/v1/media.proto
//

import "package:connectrpc/connect.dart" as connect;
import "media.pb.dart" as mediav1media;

abstract final class MediaService {
  /// Fully-qualified name of the MediaService service.
  static const name = 'media.v1.MediaService';

  static const addAndDownload = connect.Spec(
    '/$name/AddAndDownload',
    connect.StreamType.unary,
    mediav1media.AddAndDownloadRequest.new,
    mediav1media.AddAndDownloadResponse.new,
  );
}
