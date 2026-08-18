import 'package:connectrpc/http2.dart';
import 'package:connectrpc/protobuf.dart';
import 'package:connectrpc/protocol/grpc.dart' as protocol;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homework/common/api/basepath_provider.dart';

final protectedTransportProvider = Provider<protocol.Transport>((ref) {
  var basePath = ref.watch(basePathProvider);
  basePath = "$basePath/protected";

  return protocol.Transport(
    baseUrl: basePath,
    codec: const JsonCodec(),
    httpClient: createHttpClient(),
    statusParser: const StatusParser(),
  );
});

final publicTransportProvider = Provider<protocol.Transport>((ref) {
  var basePath = ref.watch(basePathProvider);
  basePath = "$basePath/public";

  return protocol.Transport(
    baseUrl: basePath,
    codec: const JsonCodec(),
    httpClient: createHttpClient(),
    statusParser: const StatusParser(),
  );
});
