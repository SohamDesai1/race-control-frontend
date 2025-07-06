import 'package:frontend/presentation/auth/register/views/set_password_screen.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/auth/login/views/login_screen.dart';
import '../../presentation/auth/register/views/register_screen.dart';
import '../../presentation/home/views/home_screen.dart';
import '../constants/route_names.dart';

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
      GoRoute(
        path: RouteNames.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: RouteNames.setPassword,
        builder: (context, state) => const SetPasswordScreen(),
      ),
    ],
  );
}
