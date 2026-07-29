part of 'package:homework/+route.dart';

@TypedGoRoute<LoginUrlRoute>(path: '/login/url')
class LoginUrlRoute extends GoRouteData with $LoginUrlRoute {
  const LoginUrlRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const LoginUrlPage();
}
