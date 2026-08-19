part of 'package:homework/+route.dart';

class SettingsGeneralBranch extends StatefulShellBranchData {
  const SettingsGeneralBranch();
}

class SettingsGeneralRoute extends GoRouteData with $SettingsGeneralRoute {
  const SettingsGeneralRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SettingsGeneralPage();
}
