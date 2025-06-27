import 'package:frontend/core/constants/route_names.dart';
import 'package:frontend/presentation/home/views/home_screen.dart';
import 'package:frontend/presentation/login/views/login_screen.dart';
import 'package:go_router/go_router.dart';

class Routing {
  static final router = GoRouter(
    initialLocation: RouteNames.login,
    routes: [
      GoRoute(
        path: RouteNames.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
    ],
  );
}
