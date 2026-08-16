//
//  Generated code. Do not modify.
//  source: browser/v1/browser.proto
//

import "package:connectrpc/connect.dart" as connect;
import "browser.pb.dart" as browserv1browser;
import "browser.connect.spec.dart" as specs;

extension type BrowserServiceClient (connect.Transport _transport) {
  Future<browserv1browser.StartResponse> start(
    browserv1browser.StartRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.BrowserService.start,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<browserv1browser.StopResponse> stop(
    browserv1browser.StopRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.BrowserService.stop,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<browserv1browser.StatusResponse> status(
    browserv1browser.StatusRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.BrowserService.status,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
