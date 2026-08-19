import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:homework/+route.dart';
import 'package:homework/common/api/basepath.provider.verfied.dart';
import 'package:homework/common/services/users/users.provider.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final isVerified = ref.watch(isUrlVerifiedProvider);
  final userState = ref.watch(userStoreProvider);

  return GoRouter(
    initialLocation: AppRoutes.home.path,
    redirect: (context, state) {
      final path = state.uri.path;
      final isGoingToLoginUrl = path == AppRoutes.loginUrl.path;
      final isGoingToAuthLogin = path == AppRoutes.authLogin.path;
      final isGoingToLoading = path == AppRoutes.authLoading.path;

      // 1. Connection URL verification check
      if (!isVerified) {
        if (!isGoingToLoginUrl) {
          return AppRoutes.loginUrl.path;
        }
        return null;
      }

      // 2. Authentication Loading / Checking check
      if (userState.isLoading) {
        if (!isGoingToLoading && !isGoingToLoginUrl) {
          return AppRoutes.authLoading.path;
        }
        return null;
      }

      // 3. User Authentication check
      final isAuthed = userState.value?.isAuthed ?? false;
      if (isAuthed) {
        // Authenticated users should not go to login or loading pages
        if (isGoingToAuthLogin || isGoingToLoginUrl || isGoingToLoading) {
          return AppRoutes.home.path;
        }
      } else {
        // Unauthenticated users must be sent to login page
        if (!isGoingToAuthLogin && !isGoingToLoginUrl && !isGoingToLoading) {
          return AppRoutes.authLogin.path;
        }
      }

      if (path == '/') {
        return AppRoutes.home.path;
      }
      return null;
    },
    routes: $appRoutes,
  );
});
