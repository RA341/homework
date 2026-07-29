part of 'package:homework/+route.dart';

class BrowseRoute extends GoRouteData with $BrowseRoute {
  const BrowseRoute();

  @override
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) {
    final path = state.uri.path;
    if (path == '/browse' || path == '/browse/') {
      return '/browse/search';
    }
    return null;
  }

  @override
  Widget build(BuildContext context, GoRouterState state) => const SizedBox.shrink();
}

class SearchRoute extends GoRouteData with $SearchRoute {
  const SearchRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const SearchPage();
}

class UploadRoute extends GoRouteData with $UploadRoute {
  const UploadRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const UploadPage();
}
