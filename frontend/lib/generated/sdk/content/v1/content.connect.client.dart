//
//  Generated code. Do not modify.
//  source: content/v1/content.proto
//

import "package:connectrpc/connect.dart" as connect;
import "content.pb.dart" as contentv1content;
import "content.connect.spec.dart" as specs;

extension type ContentServiceClient (connect.Transport _transport) {
  Future<contentv1content.ListResponse> list(
    contentv1content.ListRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ContentService.list,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
