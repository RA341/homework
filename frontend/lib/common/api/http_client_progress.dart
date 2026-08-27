import 'dart:async';

import 'package:http/http.dart' as http;

class MultipartRequestWithProgress extends http.MultipartRequest {
  final void Function(int bytesSent, int totalBytes) onProgress;

  MultipartRequestWithProgress(
    super.method,
    super.url, {
    required this.onProgress,
  });

  @override
  http.ByteStream finalize() {
    final byteStream = super.finalize();
    final total = contentLength;
    int bytesSent = 0;

    final transformer = StreamTransformer<List<int>, List<int>>.fromHandlers(
      handleData: (data, sink) {
        bytesSent += data.length;
        onProgress(bytesSent, total);
        sink.add(data);
      },
      handleError: (error, stackTrace, sink) {
        sink.addError(error, stackTrace);
      },
      handleDone: (sink) {
        sink.close();
      },
    );

    return http.ByteStream(byteStream.transform(transformer));
  }
}
