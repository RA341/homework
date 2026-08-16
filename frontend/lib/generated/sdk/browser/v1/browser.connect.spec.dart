//
//  Generated code. Do not modify.
//  source: browser/v1/browser.proto
//

import "package:connectrpc/connect.dart" as connect;
import "browser.pb.dart" as browserv1browser;

abstract final class BrowserService {
  /// Fully-qualified name of the BrowserService service.
  static const name = 'browser.v1.BrowserService';

  static const start = connect.Spec(
    '/$name/Start',
    connect.StreamType.unary,
    browserv1browser.StartRequest.new,
    browserv1browser.StartResponse.new,
  );

  static const stop = connect.Spec(
    '/$name/Stop',
    connect.StreamType.unary,
    browserv1browser.StopRequest.new,
    browserv1browser.StopResponse.new,
  );

  static const status = connect.Spec(
    '/$name/Status',
    connect.StreamType.unary,
    browserv1browser.StatusRequest.new,
    browserv1browser.StatusResponse.new,
  );
}
