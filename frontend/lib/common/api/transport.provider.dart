import 'package:connectrpc/http2.dart';
import 'package:connectrpc/protobuf.dart';
import 'package:connectrpc/protocol/grpc.dart' as protocol;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homework/common/api/basepath.provider.dart';
import 'package:homework/common/api/transport.interceptors.dart';

final protectedTransportProvider = Provider<protocol.Transport>((ref) {
  var basePath = ref.watch(protectedPathProvider);

  return protocol.Transport(
    baseUrl: basePath,
    codec: const JsonCodec(),
    httpClient: createHttpClient(),
    statusParser: const StatusParser(),
    interceptors: [
      timeoutInterceptor(requestTimeout),
      retryInterceptor(maxAttempts: 2),
      requestHeaderInterceptor(ref),
      refreshInterceptor(ref),
      unauthorizedInterceptor(),
    ],
  );
});

final publicTransportProvider = Provider<protocol.Transport>((ref) {
  var basePath = ref.watch(publicPathProvider);

  return protocol.Transport(
    baseUrl: basePath,
    codec: const JsonCodec(),
    httpClient: createHttpClient(),
    statusParser: const StatusParser(),
    interceptors: [timeoutInterceptor(requestTimeout)],
  );
});
