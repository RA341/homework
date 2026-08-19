import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homework/common/api/runner.dart';
import 'package:homework/common/api/transport.provider.dart';
import 'package:homework/common/utils/result.dart';
import 'package:homework/common/services/users/user.state.dart';
import 'package:homework/generated/sdk/user/v1/user.connect.client.dart';
import 'package:homework/generated/sdk/user/v1/user.pb.dart';

final userApiProvider = Provider<UserServiceClient>((ref) {
  final transport = ref.watch(protectedTransportProvider);
  return UserServiceClient(transport);
});

final userStoreProvider = AsyncNotifierProvider<UserStore, UserState>(
  UserStore.new,
);

class UserStore extends AsyncNotifier<UserState> {
  @override
  FutureOr<UserState> build() async {
    return _fetchUser();
  }

  Future<UserState> _fetchUser() async {
    final client = ref.read(userApiProvider);
    final res = await runReq(() => client.self(SelfRequest()));
    switch (res) {
      case Ok(:final value):
        return UserState(
          user: value.hasUser() ? value.user : null,
          isAuthed: value.hasUser(),
        );
      case Error():
        return const UserState(user: null, isAuthed: false);
    }
  }

  Future<void> refreshUser() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchUser());
  }
}
