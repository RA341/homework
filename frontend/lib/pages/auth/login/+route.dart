part of 'package:homework/+route.dart';

@TypedGoRoute<AuthLoginRoute>(path: '/auth/login')
class AuthLoginRoute extends GoRouteData with $AuthLoginRoute {
  const AuthLoginRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const AuthLoginPage();
}
