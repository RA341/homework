import 'dart:async';

import 'package:connectrpc/connect.dart' as connect;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homework/common/api/token.provider.dart';
import 'package:homework/common/services/auth/auth.provider.dart';
import 'package:homework/common/utils/logger.dart';
import 'package:homework/common/utils/strings.dart';
import 'package:homework/generated/sdk/auth/v1/auth.pb.dart';

const requestTimeout = Duration(seconds: 30);

connect.Interceptor timeoutInterceptor(Duration timeout) {
  return <I extends Object, O extends Object>(next) {
    return (req) async {
      try {
        return await next(req).timeout(timeout);
      } on TimeoutException {
        throw connect.ConnectException(
          connect.Code.deadlineExceeded,
          "Request timed out after ${timeout.inSeconds} seconds",
        );
      }
    };
  };
}

connect.Interceptor retryInterceptor({int maxAttempts = 2}) {
  return <I extends Object, O extends Object>(next) {
    return (req) async {
      int attempts = 0;
      while (true) {
        try {
          return await next(req);
        } catch (e) {
          attempts++;

          final isPermanentFailure = e is AuthRefreshException && e.isPermanent;
          if (attempts > maxAttempts || isPermanentFailure) {
            rethrow;
          }

          logger.w(
            "Request to ${req.spec.procedure} failed. Retrying (attempt $attempts of $maxAttempts)... Error: $e",
          );
          // await Future.delayed(Duration(milliseconds: attempts));
        }
      }
    };
  };
}

connect.Interceptor requestHeaderInterceptor(Ref ref) {
  return <I extends Object, O extends Object>(next) {
    return (req) {
      final authState = ref.read(authTokenProvider).value;
      final session = authState?.session;

      if (isNotNullOrEmpty(session)) {
        req.headers[sessionHeader] = session!;
      } else {
        req.headers.remove(sessionHeader);
      }

      // logger.d("with headers ${req.headers.entries.join(", ")}");
      return next(req);
    };
  };
}

connect.Interceptor unauthorizedInterceptor() {
  return <I extends Object, O extends Object>(next) {
    return (req) async {
      try {
        return await next(req);
      } on connect.ConnectException catch (e) {
        if (isAuthErr(e.code)) {
          throw AuthRefreshException("Unauthorized request (${e.code.name})");
        }
        rethrow;
      }
    };
  };
}

connect.Interceptor refreshInterceptor(Ref ref) {
  return <I extends Object, O extends Object>(next) {
    return (req) async {
      try {
        return await next(req);
      } on AuthRefreshException catch (e) {
        if (e.isPermanent) {
          rethrow;
        }

        final refresh = ref.read(authTokenProvider).value?.refresh;
        if (isNotNullOrEmpty(refresh)) {
          await refreshTokens(ref, refresh);
        }

        logger.w("No refresh token available. Clearing tokens.");
        await ref.read(authTokenProvider.notifier).clear();
        throw AuthRefreshException("No refresh token found", isPermanent: true);
      }
    };
  };
}

Future<void> refreshTokens(Ref ref, String? refresh) async {
  logger.w("Caught AuthRefreshException. Attempting to refresh tokens...");

  try {
    final authClient = ref.read(authApiProvider);
    final resp = await authClient.refresh(
      RefreshRequest(refreshToken: refresh!),
    );

    final newSession = resp.hasSession() ? resp.session.value : '';
    final newRefresh = resp.hasRefresh() ? resp.refresh.value : '';

    if (isNotNullOrEmpty(newSession) && isNotNullOrEmpty(newRefresh)) {
      await ref
          .read(authTokenProvider.notifier)
          .updateTokens(session: newSession, refresh: newRefresh);

      logger.i(
        "Tokens refreshed successfully. Propagating to retryInterceptor for rerun.",
      );
      throw AuthRefreshException(
        "Tokens refreshed, retry request",
        isPermanent: false,
      );
    }
  } on connect.ConnectException catch (refreshError) {
    if (isAuthErr(refreshError.code)) {
      logger.e(
        "Token refresh failed with auth error: $refreshError. Clearing tokens.",
      );
      await ref.read(authTokenProvider.notifier).clear();
      throw AuthRefreshException(
        "Refresh token expired or invalid",
        isPermanent: true,
      );
    } else {
      logger.w(
        "Token refresh failed with transient error: $refreshError. Rethrowing to retry.",
      );
      rethrow;
    }
  } catch (refreshError) {
    logger.e("Token refresh failed with unexpected error: $refreshError.");
    rethrow;
  }
}

bool isAuthErr(connect.Code code) {
  return code == connect.Code.unauthenticated ||
      code == connect.Code.permissionDenied;
}

class AuthRefreshException implements Exception {
  final String message;
  final bool isPermanent;

  AuthRefreshException(this.message, {this.isPermanent = false});

  @override
  String toString() =>
      "AuthRefreshException: $message (permanent: $isPermanent)";
}
