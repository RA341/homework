# Implementation Plan: Split Unauthorized Check, Token Refresh, and Retry Interceptors (Dynamic Headers)

## Goal Description
We want to restructure the error retry and token refresh handling in our Connect RPC client into three cleanly separated interceptors:
1. **`retryInterceptor`**: A general-purpose retry interceptor that catches failures and retries them up to 2 times (total 3 attempts).
2. **`requestHeaderInterceptor`**: A middle-level interceptor that dynamically reads the latest authentication tokens from `authTokenProvider` and assigns them to the request headers.
3. **`unauthorizedInterceptor`**: A low-level interceptor that detects `unauthenticated` (HTTP 401) and `permissionDenied` (HTTP 403) status codes and translates them to `AuthRefreshException`.
4. **`refreshInterceptor`**: A middle-level interceptor that:
   * Catches `AuthRefreshException` and attempts to refresh the token using `authApiProvider.refresh(...)`.
   * Updates the `authTokenProvider` on success, and throws a transient `AuthRefreshException` so that the `retryInterceptor` above it catches it and triggers a rerun of the request (which will automatically get the new headers from `requestHeaderInterceptor`).
   * If the refresh fails, it throws a transient or permanent error depending on the failure type.

We will completely remove the old `tokenRefreshInterceptor` from `protectedTransportProvider`.

---

## User Review Required
> [!NOTE]
> The `requestHeaderInterceptor` now accepts `Ref ref` to read tokens dynamically from Riverpod. This ensures that when `retryInterceptor` triggers a retry, the request is run with the newly refreshed tokens.
> The old `tokenRefreshInterceptor` is removed.

---

## Open Questions
None.

---

## Proposed Changes

### Interceptors Layer
#### [MODIFY] [lib/common/api/transport.interceptors.dart](file:///home/ra341/Dev/go/homework/frontend/lib/common/api/transport.interceptors.dart)

We will define `AuthRefreshException` and update the interceptors:

```dart
// Define the custom exception
class AuthRefreshException implements Exception {
  final String message;
  final bool isPermanent;

  AuthRefreshException(this.message, {this.isPermanent = false});

  @override
  String toString() => "AuthRefreshException: $message (permanent: $isPermanent)";
}

// 1. Retry Interceptor
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
          
          logger.w("Request to ${req.spec.procedure} failed. Retrying (attempt $attempts of $maxAttempts)... Error: $e");
          await Future.delayed(Duration(seconds: attempts));
        }
      }
    };
  };
}

// 2. Request Header Interceptor (Reads from Ref dynamically on each execution)
connect.Interceptor requestHeaderInterceptor(Ref ref) {
  return <I extends Object, O extends Object>(next) {
    return (req) {
      final authState = ref.read(authTokenProvider).value;
      final session = authState?.session;
      final refresh = authState?.refresh;

      if (isNotNullOrEmpty(session)) {
        req.headers[sessionHeader] = session!;
      } else {
        req.headers.remove(sessionHeader);
      }
      if (isNotNullOrEmpty(refresh)) {
        req.headers[refreshHeader] = refresh!;
      } else {
        req.headers.remove(refreshHeader);
      }

      logger.d("with headers ${req.headers.entries.join(", ")}");

      return next(req);
    };
  };
}

// 3. Unauthorized Interceptor (Throws AuthRefreshException on 401/403)
connect.Interceptor unauthorizedInterceptor() {
  return <I extends Object, O extends Object>(next) {
    return (req) async {
      try {
        return await next(req);
      } on connect.ConnectException catch (e) {
        if (e.code == connect.Code.unauthenticated || e.code == connect.Code.permissionDenied) {
          throw AuthRefreshException("Unauthorized request (${e.code.name})");
        }
        rethrow;
      }
    };
  };
}

// 4. Refresh Interceptor (Catches AuthRefreshException, refreshes tokens, throws transient exception to trigger retry)
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
          logger.w("Caught AuthRefreshException. Attempting to refresh tokens...");
          try {
            final authClient = ref.read(authApiProvider);
            final resp = await authClient.refresh(RefreshRequest(refreshToken: refresh!));

            final newSession = resp.hasSession() ? resp.session.value : '';
            final newRefresh = resp.hasRefresh() ? resp.refresh.value : '';

            if (isNotNullOrEmpty(newSession) && isNotNullOrEmpty(newRefresh)) {
              await ref.read(authTokenProvider.notifier).updateTokens(
                session: newSession,
                refresh: newRefresh,
              );

              logger.i("Tokens refreshed successfully. Propagating to retryInterceptor for rerun.");
              throw AuthRefreshException("Tokens refreshed, retry request", isPermanent: false);
            }
          } on connect.ConnectException catch (refreshError) {
            final isAuthError = refreshError.code == connect.Code.unauthenticated ||
                                refreshError.code == connect.Code.permissionDenied;
            if (isAuthError) {
              logger.e("Token refresh failed with auth error: $refreshError. Clearing tokens.");
              await ref.read(authTokenProvider.notifier).clear();
              throw AuthRefreshException("Refresh token expired or invalid", isPermanent: true);
            } else {
              logger.w("Token refresh failed with transient error: $refreshError. Rethrowing to retry.");
              rethrow;
            }
          } catch (refreshError) {
            logger.e("Token refresh failed with unexpected error: $refreshError.");
            rethrow;
          }
        }

        logger.w("No refresh token available. Clearing tokens.");
        await ref.read(authTokenProvider.notifier).clear();
        throw AuthRefreshException("No refresh token found", isPermanent: true);
      }
    };
  };
}
```

---

### Transport Provider Layer
#### [MODIFY] [lib/common/api/transport.provider.dart](file:///home/ra341/Dev/go/homework/frontend/lib/common/api/transport.provider.dart)

We will update `protectedTransportProvider` to use the new interceptors setup:

```dart
final protectedTransportProvider = Provider<protocol.Transport>((ref) {
  var basePath = ref.watch(protectedPathProvider);

  return protocol.Transport(
    baseUrl: basePath,
    codec: const JsonCodec(),
    httpClient: createHttpClient(),
    statusParser: const StatusParser(),
    interceptors: [
      timeoutInterceptor(requestTimeout),
      retryInterceptor(maxAttempts: 2),
      requestHeaderInterceptor(ref),
      refreshInterceptor(ref),
      unauthorizedInterceptor(),
    ],
  );
});
```

---

## Verification Plan

### Automated Tests
Run the Dart/Flutter static analyzer:
```bash
flutter analyze
```

### Manual Verification
1. Run the application.
2. Login to generate initial tokens.
3. Verify that requests include authentication headers correctly.
4. Simulate an unauthorized request and verify the refresh and retry chain executes successfully.
