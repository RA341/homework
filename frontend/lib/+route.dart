import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:homework/common/api/basepath_provider.dart';
import 'package:homework/common/navigation/+layout.dart';
import 'package:homework/pages/browse/search/+page.dart';
import 'package:homework/pages/browse/upload/+page.dart';
import 'package:homework/pages/home/+page.dart';
import 'package:homework/pages/login/url/+page.dart';
import 'package:homework/pages/settings/+page.dart';

part '+route.g.dart';
part 'pages/browse/+route.dart';
part 'pages/home/+route.dart';
part 'pages/login/url/+route.dart';
part 'pages/settings/+route.dart';

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

  return GoRouter(
    initialLocation: '/home',
    redirect: (context, state) {
      final isGoingToLogin = state.uri.path == '/login/url';

      if (!isVerified) {
        if (!isGoingToLogin) {
          return '/login/url';
        }
      } else {
        if (isGoingToLogin) {
          return '/home';
        }
      }

      if (state.uri.path == '/') {
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
    path: '/settings',
  ),
];

// Typed shell route for go_router_builder
@TypedShellRoute<AppShellRouteData>(
  routes: <TypedRoute<RouteData>>[
    TypedGoRoute<HomeRoute>(path: '/home'),
    TypedGoRoute<BrowseRoute>(
      path: '/browse',
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<SearchRoute>(path: 'search'),
        TypedGoRoute<UploadRoute>(path: 'upload'),
      ],
    ),
    TypedGoRoute<SettingsRoute>(path: '/settings'),
  ],
)
class AppShellRouteData extends ShellRouteData {
  const AppShellRouteData();

  @override
  Widget builder(BuildContext context, GoRouterState state, Widget navigator) {
    return RootLayout(child: navigator);
  }
}
