import 'dart:async';

import 'package:connectrpc/connect.dart' as connect;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homework/common/api/token.provider.dart';
import 'package:homework/common/utils/logger.dart';
import 'package:homework/common/utils/strings.dart';

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


connect.Interceptor requestHeaderInterceptor(
    String? session,
    String? refresh,
    ) {
  return <I extends Object, O extends Object>(next) {
    return (req) {
      if (isNotNullOrEmpty(session)) {
        req.headers[sessionHeader] = session!;
      }
      if (isNotNullOrEmpty(refresh)) {
        req.headers[refreshHeader] = refresh!;
      }

      // logger.d("with headers ${req.headers.entries.join(", ")}");

      return next(req);
    };
  };
}

connect.Interceptor tokenRefreshInterceptor(Ref ref) {
  return <I extends Object, O extends Object>(next) {
    return (req) async {
      final response = await next(req);

      final newSession = response.headers[sessionHeader];
      final newRefresh = response.headers[refreshHeader];
      if (isNotNullOrEmpty(newSession) && isNotNullOrEmpty(newRefresh)) {
        logger.d("refreshing tokens ${response.headers}");
        await ref
            .read(authTokenProvider.notifier)
            .updateTokens(refresh: newRefresh, session: newSession);
      }

      return response;
    };
  };
}
