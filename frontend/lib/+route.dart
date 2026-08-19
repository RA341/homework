import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:homework/common/api/basepath.provider.dart';
import 'package:homework/common/services/users/users.provider.dart';
import 'package:homework/components/navigation/+layout.dart';
import 'package:homework/components/theme/design_system.dart';
import 'package:homework/pages/auth/login/+page.dart';
import 'package:homework/pages/browse/download/+page.dart';
import 'package:homework/pages/browse/upload/+page.dart';
import 'package:homework/pages/home/+page.dart';
import 'package:homework/pages/login/url/+page.dart';
import 'package:homework/pages/settings/+layout.dart';
import 'package:homework/pages/settings/general/+page.dart';
import 'package:homework/pages/settings/downloads/+page.dart';
import 'package:homework/pages/settings/browser/+page.dart';

part '+route.g.dart';
part 'pages/auth/login/+route.dart';
part 'pages/browse/+route.dart';
part 'pages/home/+route.dart';
part 'pages/login/url/+route.dart';
part 'pages/settings/+route.dart';
part 'pages/settings/general/+route.dart';
part 'pages/settings/downloads/+route.dart';
part 'pages/settings/browser/+route.dart';

class NavItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final String path;

  const NavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.path,
  });
}

final routerProvider = Provider<GoRouter>((ref) {
  final isVerified = ref.watch(isUrlVerifiedProvider);
  final userState = ref.watch(userStoreProvider);

  return GoRouter(
    initialLocation: '/home',
    redirect: (context, state) {
      final path = state.uri.path;
      final isGoingToLoginUrl = path == '/login/url';
      final isGoingToAuthLogin = path == '/auth/login';
      final isGoingToLoading = path == '/auth/loading';

      // 1. Connection URL verification check
      if (!isVerified) {
        if (!isGoingToLoginUrl) {
          return '/login/url';
        }
        return null;
      }

      // 2. Authentication Loading / Checking check
      if (userState.isLoading) {
        if (!isGoingToLoading && !isGoingToLoginUrl) {
          return '/auth/loading';
        }
        return null;
      }

      // 3. User Authentication check
      final isAuthed = userState.value?.isAuthed ?? false;
      if (isAuthed) {
        // Authenticated users should not go to login or loading pages
        if (isGoingToAuthLogin || isGoingToLoginUrl || isGoingToLoading) {
          return '/home';
        }
      } else {
        // Unauthenticated users must be sent to login page
        if (!isGoingToAuthLogin && !isGoingToLoginUrl && !isGoingToLoading) {
          return '/auth/login';
        }
      }

      if (path == '/') {
        return '/home';
      }
      return null;
    },
    routes: $appRoutes,
  );
});

final navItems = <NavItem>[
  const NavItem(
    label: 'Home',
    icon: Icons.dashboard_outlined,
    activeIcon: Icons.dashboard_rounded,
    path: '/home',
  ),
  const NavItem(
    label: 'Browse',
    icon: Icons.add_circle_outline_rounded,
    activeIcon: Icons.add_circle_rounded,
    path: '/browse',
  ),
  const NavItem(
    label: 'Settings',
    icon: Icons.settings_outlined,
    activeIcon: Icons.settings_rounded,
    path: '/settings/general',
  ),
];

// Typed shell route for go_router_builder
@TypedShellRoute<AppShellRouteData>(
  routes: <TypedRoute<RouteData>>[
    TypedGoRoute<HomeRoute>(path: '/home'),
    TypedGoRoute<BrowseRoute>(
      path: '/browse',
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<DownloadRoute>(path: 'download'),
        TypedGoRoute<UploadRoute>(path: 'upload'),
      ],
    ),
    TypedStatefulShellRoute<SettingsRoute>(
      branches: <TypedStatefulShellBranch<StatefulShellBranchData>>[
        TypedStatefulShellBranch<SettingsGeneralBranch>(
          routes: <TypedRoute<RouteData>>[
            TypedGoRoute<SettingsGeneralRoute>(path: '/settings/general'),
          ],
        ),
        TypedStatefulShellBranch<SettingsDownloadsBranch>(
          routes: <TypedRoute<RouteData>>[
            TypedGoRoute<SettingsDownloadsRoute>(path: '/settings/downloads'),
          ],
        ),
        TypedStatefulShellBranch<SettingsBrowserBranch>(
          routes: <TypedRoute<RouteData>>[
            TypedGoRoute<SettingsBrowserRoute>(path: '/settings/browser'),
          ],
        ),
      ],
    ),
  ],
)

class AppShellRouteData extends ShellRouteData {
  const AppShellRouteData();

  @override
  Widget builder(BuildContext context, GoRouterState state, Widget navigator) {
    return RootLayout(child: navigator);
  }
}

@TypedGoRoute<AuthLoadingRoute>(path: '/auth/loading')
class AuthLoadingRoute extends GoRouteData with $AuthLoadingRoute {
  const AuthLoadingRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const Scaffold(
      backgroundColor: AppColors.level0,
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
