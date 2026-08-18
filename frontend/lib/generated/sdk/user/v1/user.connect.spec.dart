//
//  Generated code. Do not modify.
//  source: user/v1/user.proto
//

import "package:connectrpc/connect.dart" as connect;
import "user.pb.dart" as userv1user;

abstract final class UserService {
  /// Fully-qualified name of the UserService service.
  static const name = 'user.v1.UserService';

  static const self = connect.Spec(
    '/$name/Self',
    connect.StreamType.unary,
    userv1user.SelfRequest.new,
    userv1user.SelfResponse.new,
  );
}
