import 'package:connectrpc/connect.dart' as connect;
import 'package:connectrpc/http2.dart';
import 'package:connectrpc/protobuf.dart';
import 'package:connectrpc/protocol/grpc.dart' as protocol;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homework/common/api/authtoken.provider.dart';
import 'package:homework/common/api/basepath_provider.dart';

final protectedTransportProvider = Provider<protocol.Transport>((ref) {
  var basePath = ref.watch(basePathProvider);
  basePath = "$basePath/protected";

  final authState = ref.watch(authTokenProvider);
  final session = authState.value?.session;
  final refresh = authState.value?.refresh;

  return protocol.Transport(
    baseUrl: basePath,
    codec: const JsonCodec(),
    httpClient: createHttpClient(),
    statusParser: const StatusParser(),
    interceptors: [
      <I extends Object, O extends Object>(next) {
        return (req) {
          if (session != null && session.isNotEmpty) {
            req.headers[sessionHeader] = session;
          }
          if (refresh != null && refresh.isNotEmpty) {
            req.headers[refreshHeader] = refresh;
          }
          return next(req);
        };
      }
    ],
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
