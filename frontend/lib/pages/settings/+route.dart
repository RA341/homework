part of 'package:homework/+route.dart';

class SettingsRoute extends StatefulShellRouteData {
  const SettingsRoute();

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) {
    return SettingsLayout(navigationShell: navigationShell);
  }
}
