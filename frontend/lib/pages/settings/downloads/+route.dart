part of 'package:homework/+route.dart';

class SettingsDownloadsBranch extends StatefulShellBranchData {
  const SettingsDownloadsBranch();
}

class SettingsDownloadsRoute extends GoRouteData with $SettingsDownloadsRoute {
  const SettingsDownloadsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SettingsDownloadsPage();
}
