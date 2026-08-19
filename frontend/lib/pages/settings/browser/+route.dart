part of 'package:homework/+route.dart';

class SettingsBrowserBranch extends StatefulShellBranchData {
  const SettingsBrowserBranch();
}

class SettingsBrowserRoute extends GoRouteData with $SettingsBrowserRoute {
  const SettingsBrowserRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SettingsBrowserPage();
}
