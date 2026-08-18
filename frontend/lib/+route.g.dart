// GENERATED CODE - DO NOT MODIFY BY HAND

part of '+route.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
  $appShellRouteData,
  $authLoadingRoute,
  $authLoginRoute,
  $loginUrlRoute,
];

RouteBase get $appShellRouteData => ShellRouteData.$route(
  factory: $AppShellRouteDataExtension._fromState,
  routes: [
    GoRouteData.$route(
      path: '/home',
      hasOverriddenOnExit: false,
      factory: $HomeRoute._fromState,
    ),
    GoRouteData.$route(
      path: '/browse',
      hasOverriddenOnExit: false,
      factory: $BrowseRoute._fromState,
      routes: [
        GoRouteData.$route(
          path: 'download',
          hasOverriddenOnExit: false,
          factory: $DownloadRoute._fromState,
        ),
        GoRouteData.$route(
          path: 'upload',
          hasOverriddenOnExit: false,
          factory: $UploadRoute._fromState,
        ),
      ],
    ),
    GoRouteData.$route(
      path: '/settings',
      hasOverriddenOnExit: false,
      factory: $SettingsRoute._fromState,
    ),
  ],
);

extension $AppShellRouteDataExtension on AppShellRouteData {
  static AppShellRouteData _fromState(GoRouterState state) =>
      const AppShellRouteData();
}

mixin $HomeRoute on GoRouteData {
  static HomeRoute _fromState(GoRouterState state) => const HomeRoute();

  @override
  String get location => GoRouteData.$location('/home');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $BrowseRoute on GoRouteData {
  static BrowseRoute _fromState(GoRouterState state) => const BrowseRoute();

  @override
  String get location => GoRouteData.$location('/browse');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $DownloadRoute on GoRouteData {
  static DownloadRoute _fromState(GoRouterState state) => const DownloadRoute();

  @override
  String get location => GoRouteData.$location('/browse/download');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $UploadRoute on GoRouteData {
  static UploadRoute _fromState(GoRouterState state) => const UploadRoute();

  @override
  String get location => GoRouteData.$location('/browse/upload');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $SettingsRoute on GoRouteData {
  static SettingsRoute _fromState(GoRouterState state) => const SettingsRoute();

  @override
  String get location => GoRouteData.$location('/settings');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $authLoadingRoute => GoRouteData.$route(
  path: '/auth/loading',
  hasOverriddenOnExit: false,
  factory: $AuthLoadingRoute._fromState,
);

mixin $AuthLoadingRoute on GoRouteData {
  static AuthLoadingRoute _fromState(GoRouterState state) =>
      const AuthLoadingRoute();

  @override
  String get location => GoRouteData.$location('/auth/loading');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $authLoginRoute => GoRouteData.$route(
  path: '/auth/login',
  hasOverriddenOnExit: false,
  factory: $AuthLoginRoute._fromState,
);

mixin $AuthLoginRoute on GoRouteData {
  static AuthLoginRoute _fromState(GoRouterState state) =>
      const AuthLoginRoute();

  @override
  String get location => GoRouteData.$location('/auth/login');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $loginUrlRoute => GoRouteData.$route(
  path: '/login/url',
  hasOverriddenOnExit: false,
  factory: $LoginUrlRoute._fromState,
);

mixin $LoginUrlRoute on GoRouteData {
  static LoginUrlRoute _fromState(GoRouterState state) => const LoginUrlRoute();

  @override
  String get location => GoRouteData.$location('/login/url');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}
