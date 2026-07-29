import 'package:connectrpc/http2.dart';
import 'package:connectrpc/protobuf.dart';
import 'package:connectrpc/protocol/grpc.dart' as protocol;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homework/common/api/basepath_provider.dart';


final transportProvider = Provider<protocol.Transport>((ref) {
  var basePath = ref.watch(basePathProvider);

  return protocol.Transport(
      baseUrl: basePath,
      codec: const JsonCodec(),
      httpClient: createHttpClient(),
      statusParser: const StatusParser()
  );
});
