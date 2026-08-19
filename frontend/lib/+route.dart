import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:homework/components/navigation/+layout.dart';
import 'package:homework/components/theme/design_system.dart';
import 'package:homework/pages/auth/+layout.dart';
import 'package:homework/pages/auth/login/+page.dart';
import 'package:homework/pages/auth/url/+page.dart';
import 'package:homework/pages/browse/download/+page.dart';
import 'package:homework/pages/browse/upload/+page.dart';
import 'package:homework/pages/home/+page.dart';
import 'package:homework/pages/settings/+layout.dart';
import 'package:homework/pages/settings/browser/+page.dart';
import 'package:homework/pages/settings/downloads/+page.dart';
import 'package:homework/pages/settings/general/+page.dart';

part '+route.g.dart';
part 'pages/auth/login/+route.dart';
part 'pages/auth/url/+route.dart';
part 'pages/browse/+route.dart';
part 'pages/home/+route.dart';
part 'pages/settings/+route.dart';
part 'pages/settings/browser/+route.dart';
part 'pages/settings/downloads/+route.dart';
part 'pages/settings/general/+route.dart';

abstract class AppRoutes {
  static const home = HomeRoute();
  static const browse = BrowseRoute();
  static const download = DownloadRoute();
  static const upload = UploadRoute();
  static const settingsGeneral = SettingsGeneralRoute();
  static const settingsDownloads = SettingsDownloadsRoute();
  static const settingsBrowser = SettingsBrowserRoute();
  static const authLoading = AuthLoadingRoute();
  static const authLogin = AuthLoginRoute();
  static const loginUrl = LoginUrlRoute();
}

extension GoRouteDataPathExtension on GoRouteData {
  String get path => location;
}

// Typed shell route for auth screens (URL verification and Credentials Login)
@TypedShellRoute<AuthShellRouteData>(
  routes: <TypedRoute<RouteData>>[
    TypedGoRoute<LoginUrlRoute>(path: '/auth/url'),
    TypedGoRoute<AuthLoginRoute>(path: '/auth/login'),
  ],
)
class AuthShellRouteData extends ShellRouteData {
  const AuthShellRouteData();

  @override
  Widget builder(BuildContext context, GoRouterState state, Widget navigator) {
    return AuthLayout(child: navigator);
  }
}

// Typed shell route for main app navigation
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
