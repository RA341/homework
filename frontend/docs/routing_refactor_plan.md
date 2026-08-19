# Implementation Plan - Refactor Manual String Routes to Single Source of Truth

This plan details how to remove manual path string routes and refactor the routing structure to use a single source of truth based on the generated typed routes from `go_router_builder`.

Furthermore, we will split the routing codebase by keeping route annotations and class definitions in `lib/+route.dart` and moving the router provider to `lib/route.provider.dart`.

## Goal Description
Currently, the codebase uses hardcoded route strings (e.g. `/home`, `/browse`, `/settings/general`) for navigating, checking the active route in navigation layouts, and performing redirects. This is error-prone and hard to maintain if route structures change.
We will:
1. Introduce a central class `AppRoutes` that acts as the single source of truth containing all the routes.
2. Extend `GoRouteData` with a `.path` extension getter that maps to its `.location`.
3. Separate route definition (`lib/+route.dart`) and the router provider (`lib/route.provider.dart`).
4. Update navigation widgets, layout files, and page redirects to use these typed routes.

## User Review Required
No breaking changes or high-risk modifications. This is a pure codebase refactoring to improve type safety and maintainability.

## Proposed Changes

### Core Route Configurations

#### [NEW] `lib/route.provider.dart`
- Holds `routerProvider` for the application, importing the routes from `lib/+route.dart`.
- Uses `AppRoutes` constants and properties for path routing and redirects.

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:homework/+route.dart';
import 'package:homework/common/api/basepath.provider.dart';
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
        if (isGoingToAuthLogin || isGoingToLoginUrl || isGoingToLoading) {
          return AppRoutes.home.path;
        }
      } else {
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
```

#### [MODIFY] `lib/+route.dart`
- Remove `routerProvider`.
- Remove imports of `package:flutter_riverpod/flutter_riverpod.dart`, `package:homework/common/api/basepath.provider.dart`, and `package:homework/common/services/users/users.provider.dart` since they are no longer needed in this file.
- Create the `AppRoutes` class containing all `GoRouteData` routes as `static const` fields.
- Add an extension on `GoRouteData` to define `path` (returning `location`).
- Update `NavItem` to store `GoRouteData route` instead of `String path`.
- Update `navItems` to use `AppRoutes` constants.

```dart
// Proposed changes in lib/+route.dart:

// 1. Add GoRouteData path extension & AppRoutes single source of truth
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

// 2. Modify NavItem to hold GoRouteData
class NavItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final GoRouteData route;

  const NavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.route,
  });
}

// 3. Update navItems
final navItems = <NavItem>[
  const NavItem(
    label: 'Home',
    icon: Icons.dashboard_outlined,
    activeIcon: Icons.dashboard_rounded,
    route: AppRoutes.home,
  ),
  const NavItem(
    label: 'Browse',
    icon: Icons.add_circle_outline_rounded,
    activeIcon: Icons.add_circle_rounded,
    route: AppRoutes.browse,
  ),
  const NavItem(
    label: 'Settings',
    icon: Icons.settings_outlined,
    activeIcon: Icons.settings_rounded,
    route: AppRoutes.settingsGeneral,
  ),
];
```

#### [MODIFY] `lib/main.dart`
- Replace `import 'package:homework/+route.dart';` with `import 'package:homework/route.provider.dart';` (or import both if needed, but it only needs `routerProvider`).

---

### Layout & Navigation Components

#### [MODIFY] `lib/components/navigation/+layout.dart`
- Update the active index logic to check `item.route.location`.
```dart
    final activeIndex = navItems.indexWhere((item) =>
        location == item.route.location ||
        (item.route.location != '/' && location.startsWith(item.route.location)));
```

#### [MODIFY] `lib/components/navigation/nav_mobile.dart`
- Update the active index calculation and `onDestinationSelected` navigation.
```dart
    final activeIndex = navItems.indexWhere((item) =>
        location == item.route.location ||
        (item.route.location != '/' && location.startsWith(item.route.location)));
    ...
      onDestinationSelected: (index) {
        navItems[index].route.go(context);
      },
```

#### [MODIFY] `lib/components/navigation/nav_desktop.dart`
- Update navigation execution to use the `go` method on `GoRouteData`.
```dart
                    onTap: () {
                      item.route.go(context);
                    },
```

#### [MODIFY] `lib/pages/browse/+layout.dart`
- Refactor the tab bar logic to accept a `GoRouteData` route object instead of a string path.
```dart
              _buildTab(
                context,
                title: 'Download',
                icon: Icons.search_rounded,
                index: 0,
                route: AppRoutes.download,
              ),
              const SizedBox(width: AppSpacing.base * 4),
              _buildTab(
                context,
                title: 'Upload',
                icon: Icons.cloud_upload_outlined,
                index: 1,
                route: AppRoutes.upload,
              ),
```

#### [MODIFY] `lib/pages/browse/+route.dart`
- Update redirect paths to use typed route locations.
```dart
  @override
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) {
    final path = state.uri.path;
    if (path == AppRoutes.browse.path || path == '${AppRoutes.browse.path}/') {
      return AppRoutes.download.path;
    }
    return null;
  }
```

---

### Individual Page Controllers

#### [MODIFY] `lib/pages/home/widgets/home_header.dart`
- Import `package:homework/+route.dart`.
- Replace `context.go('/browse')` with `AppRoutes.browse.go(context)`.

#### [MODIFY] `lib/pages/auth/login/+page.dart`
- Import `package:homework/+route.dart`.
- Replace `context.go('/home')` with `AppRoutes.home.go(context)`.

---

## Verification Plan

### Automated Tests
We will verify that the codebase compiles successfully and runs code generation correctly:
1. `flutter analyze` to ensure there are no static analysis warnings or errors.
2. `dart run build_runner build --delete-conflicting-outputs` to make sure code generation is not broken.

### Manual Verification
1. Open the app and connect to the backend (login / verification).
2. Click on the Navigation Rail/Bar items: Home, Browse, Settings. Verify that routing works exactly as before.
3. On the Home page, click "Add Asset". Verify it redirects to Browse/Download.
4. On the Browse page, toggle between Download and Upload tabs. Verify navigation behaves correctly.
