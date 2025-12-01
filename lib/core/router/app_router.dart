import 'package:go_router/go_router.dart';
import '../services/api_service.dart';
import '../../presentation/auth/login/views/login_screen.dart';
import '../../presentation/auth/register/views/register_screen.dart';
import '../../presentation/auth/register/views/set_password_screen.dart';
import '../../presentation/home/views/home_screen.dart';
import '../../presentation/home/views/race_results_screen.dart';
import '../constants/route_names.dart';

class Routing {
  static final router = GoRouter(
    initialLocation: RouteNames.login,

    redirect: (context, state) async {
      final String loggedIn = await ApiService.getToken();

      final loggingIn =
          state.matchedLocation == RouteNames.login ||
          state.matchedLocation == RouteNames.register;

      if (loggedIn.isEmpty) {
        return loggingIn ? null : RouteNames.login;
      } else {
        if (loggingIn) return RouteNames.home;
      }
      return null;
    },

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
      GoRoute(
        name: RouteNames.raceResults,
        path: RouteNames.raceResults,
        builder: (context, state) {
          final race = state.extra as Map<String, dynamic>?;
          return RaceResultsScreen(
            raceName: race?['raceName'],
            raceResults: race?['raceResults'],
          );
        },
      ),
    ],
  );
}
