//
//  Generated code. Do not modify.
//  source: content/v1/content.proto
//

import "package:connectrpc/connect.dart" as connect;
import "content.pb.dart" as contentv1content;

abstract final class ContentService {
  /// Fully-qualified name of the ContentService service.
  static const name = 'content.v1.ContentService';

  static const list = connect.Spec(
    '/$name/List',
    connect.StreamType.unary,
    contentv1content.ListRequest.new,
    contentv1content.ListResponse.new,
  );
}
