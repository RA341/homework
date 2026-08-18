import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homework/common/api/basepath_provider.dart';

class AuthTokens {
  final String? session;
  final String? refresh;

  const AuthTokens({this.session, this.refresh});

  AuthTokens copyWith({
    String? session,
    String? refresh,
  }) {
    return AuthTokens(
      session: session ?? this.session,
      refresh: refresh ?? this.refresh,
    );
  }

  bool get isAuthenticated => session != null && session!.isNotEmpty;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthTokens &&
          runtimeType == other.runtimeType &&
          session == other.session &&
          refresh == other.refresh;

  @override
  int get hashCode => session.hashCode ^ refresh.hashCode;
}

final authTokenProvider =
    AsyncNotifierProvider<AuthTokenNotifier, AuthTokens>(
  AuthTokenNotifier.new,
);

const sessionHeader = 'session';
const refreshHeader = 'refresh';

class AuthTokenNotifier extends AsyncNotifier<AuthTokens> {
  static const _sessionKey = 'auth_session';
  static const _refreshKey = 'auth_refresh';


  @override
  FutureOr<AuthTokens> build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final session = prefs.getString(_sessionKey);
    final refresh = prefs.getString(_refreshKey);
    return AuthTokens(session: session, refresh: refresh);
  }

  Future<void> updateTokens({String? session, String? refresh}) async {
    final prefs = ref.read(sharedPreferencesProvider);
    final current = state.value ?? const AuthTokens();
    final updated = current.copyWith(session: session, refresh: refresh);

    if (session != null) {
      await prefs.setString(_sessionKey, session);
    }
    if (refresh != null) {
      await prefs.setString(_refreshKey, refresh);
    }

    state = AsyncValue.data(updated);
  }

  Future<void> clearTokens() async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.remove(_sessionKey);
    await prefs.remove(_refreshKey);
    state = const AsyncValue.data(AuthTokens());
  }
}
