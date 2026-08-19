# Implementation Plan - Combine URL and Login Pages into Unified Auth Container

This plan outlines how to combine the backend URL verification and sign-in steps into a unified authentication container structure under `lib/pages/auth`.

## Goal Description
Currently, `LoginUrlPage` (under `lib/pages/login/url`) and `AuthLoginPage` (under `lib/pages/auth/login`) are separated into two unrelated routing branches: `/login/url` and `/auth/login`. They duplicate Scaffold, centering, and inner card styling structures.
We will refactor this so that:
1. They share a single outer container shell: `AuthLayout` (defined in `lib/pages/auth/+layout.dart`).
2. They are subroutes nested under `/auth`:
   - `/auth/url` (URL verification step)
   - `/auth/login` (Credentials sign-in step)
3. The directory `lib/pages/login` is deleted.
4. Redirect logic automatically routes the user to the URL configuration first, and then to the credentials page.

## User Review Required
No high-risk operations. The routes change from `/login/url` to `/auth/url`.

## Proposed Changes

### Core Route Configurations

#### [MODIFY] `lib/+route.dart`
- Update part files imports list (remove `lib/pages/login/url/+route.dart`, add `lib/pages/auth/url/+route.dart`).
- Import `package:homework/pages/auth/+layout.dart`.
- Define `AuthShellRouteData` shell route.
- Update `AppRoutes` container list.

```dart
// Part imports list updates:
// [DELETE] part 'pages/login/url/+route.dart';
// [NEW] part 'pages/auth/url/+route.dart';

import 'package:homework/pages/auth/+layout.dart';

// Definition of Shell Route in lib/+route.dart
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
```

```dart
// Update in AppRoutes:
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
  static const loginUrl = LoginUrlRoute(); // Automatically maps to the new location (/auth/url)
}
```

#### [DELETE] `lib/pages/login/url/+route.dart`
- Remove the legacy standalone route definition file.

#### [NEW] `lib/pages/auth/url/+route.dart`
- Create the nested route definition for the URL page.
```dart
part of 'package:homework/+route.dart';

class LoginUrlRoute extends GoRouteData with $LoginUrlRoute {
  const LoginUrlRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const LoginUrlPage();
}
```

#### [MODIFY] `lib/pages/auth/login/+route.dart`
- Remove the legacy `@TypedGoRoute` annotation from `AuthLoginRoute` since it is now nested inside the `AuthShellRouteData` annotation.
```dart
part of 'package:homework/+route.dart';

class AuthLoginRoute extends GoRouteData with $AuthLoginRoute {
  const AuthLoginRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const AuthLoginPage();
}
```

---

### Authentication Layout & Subpages

#### [NEW] `lib/pages/auth/+layout.dart`
- Create the shared `AuthLayout` widget wrapping the common Scaffold background, centering container, card styling, and Logo header.

#### [DELETE] `lib/pages/login/url/+page.dart`
- Remove the legacy URL page.

#### [NEW] `lib/pages/auth/url/+page.dart`
- Create the updated `LoginUrlPage` widget containing only the URL verification form.

#### [MODIFY] `lib/pages/auth/login/+page.dart`
- Update the `AuthLoginPage` widget to only render the login credential inputs and sign in button, delegating background, card styling, and logo to the parent `AuthLayout`.

---

## Verification Plan

### Automated Tests
1. `dart run build_runner build --delete-conflicting-outputs` to run code generation and verify that the routing tree resolves without errors.
2. `flutter analyze` to ensure there are no compilation errors or analysis issues.

### Manual Verification
1. Run the app on an empty state (or clear the connection URL storage).
2. Verify you are redirected to `/auth/url`. Check the visual card with the centered icon.
3. Enter `http://localhost:9911` (or your backend URL) and click "Connect to Server".
4. Once connected, verify the app transitions smoothly to `/auth/login` (Sign In credentials form).
5. Enter credentials, click "SIGN IN", and verify you are taken to `/home`.
