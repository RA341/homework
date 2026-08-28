part of 'package:homework/+route.dart';

class BrowseRoute extends GoRouteData with $BrowseRoute {
  const BrowseRoute();

  @override
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) {
    final path = state.uri.path;
    if (path == AppRoutes.browse.path || path == '${AppRoutes.browse.path}/') {
      return AppRoutes.download.path;
    }
    return null;
  }

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SizedBox.shrink();
}

class DownloadRoute extends GoRouteData with $DownloadRoute {
  const DownloadRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const DownloadPage();
}

class UploadRoute extends GoRouteData with $UploadRoute {
  const UploadRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const UploadPage();
}
