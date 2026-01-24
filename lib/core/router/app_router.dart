import 'package:flutter/material.dart';
import 'package:frontend/presentation/raceDetails/views/quali_details_screen.dart';
import 'package:frontend/presentation/raceDetails/views/race_detail_screen.dart';
import 'package:frontend/presentation/raceDetails/views/session_detail_screen.dart';
import 'package:frontend/presentation/raceDetails/views/telemetry_screen.dart';
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
        pageBuilder: (context, state) => _buildF1Transition(
          context: context,
          state: state,
          child: const HomeScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.login,
        pageBuilder: (context, state) => _buildF1Transition(
          context: context,
          state: state,
          child: const LoginScreen(),
          transitionType: F1TransitionType.fade,
        ),
      ),
      GoRoute(
        path: RouteNames.register,
        pageBuilder: (context, state) => _buildF1Transition(
          context: context,
          state: state,
          child: const RegisterScreen(),
          transitionType: F1TransitionType.fade,
        ),
      ),
      GoRoute(
        path: RouteNames.setPassword,
        pageBuilder: (context, state) => _buildF1Transition(
          context: context,
          state: state,
          child: const SetPasswordScreen(),
        ),
      ),
      GoRoute(
        name: RouteNames.raceResults,
        path: RouteNames.raceResults,
        pageBuilder: (context, state) {
          final race = state.extra as Map<String, dynamic>?;
          return _buildF1Transition(
            context: context,
            state: state,
            child: RaceResultsScreen(
              raceName: race?['raceName'],
              raceResults: race?['raceResults'],
            ),
          );
        },
      ),
      GoRoute(
        name: RouteNames.raceDetails,
        path: RouteNames.raceDetails,
        pageBuilder: (context, state) {
          final race = state.extra as Map<String, dynamic>?;
          return _buildF1Transition(
            context: context,
            state: state,
            child: RaceDetailScreen(
              trackimage: race?['trackimage'],
              gpName: race?['gpName'],
              season: race?['season'],
              raceId: race?['raceId'],
              round: race?['round'],
            ),
          );
        },
      ),
      GoRoute(
        name: RouteNames.sessionDetails,
        path: RouteNames.sessionDetails,
        pageBuilder: (context, state) {
          final session = state.extra as Map<String, dynamic>?;
          return _buildF1Transition(
            context: context,
            state: state,
            child: SessionDetailScreen(
              sessionKey: session?['sessionKey'],
              sessionName: session?['sessionName'],
              season: session?['season'],
            ),
          );
        },
      ),
      GoRoute(
        name: RouteNames.qualiDetails,
        path: RouteNames.qualiDetails,
        pageBuilder: (context, state) {
          final session = state.extra as Map<String, dynamic>?;
          return _buildF1Transition(
            context: context,
            state: state,
            child: QualiDetailsScreen(
              sessionKey: session?['sessionKey'],
              sessionName: session?['sessionName'],
              season: session?['season'],
              round: session?['round'],
            ),
          );
        },
      ),
      GoRoute(
        name: RouteNames.telemetryDetails,
        path: RouteNames.telemetryDetails,
        pageBuilder: (context, state) {
          final session = state.extra as Map<String, dynamic>?;
          return _buildF1Transition(
            context: context,
            state: state,
            child: TelemetryScreen(
              sessionKey: session?['sessionKey'],
              drivers: session?['drivers'],
              season: session?['season'],
              sessionType: session?['sessionType'],
            ),
          );
        },
      ),
    ],
  );

  static Page _buildF1Transition({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
    F1TransitionType transitionType = F1TransitionType.speedSlide,
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        switch (transitionType) {
          case F1TransitionType.speedSlide:
            return _buildSpeedSlideTransition(
              animation,
              secondaryAnimation,
              child,
            );
          case F1TransitionType.fade:
            return _buildFadeTransition(animation, child);
        }
      },
      transitionDuration: const Duration(milliseconds: 400),
      reverseTransitionDuration: const Duration(milliseconds: 300),
    );
  }

  static Widget _buildSpeedSlideTransition(
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const curve = Curves.easeInOutCubic;

    final slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: animation, curve: curve));

    final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animation,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    final exitSlideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-0.3, 0.0),
    ).animate(CurvedAnimation(parent: secondaryAnimation, curve: curve));

    final exitFadeAnimation = Tween<double>(begin: 1.0, end: 0.7).animate(
      CurvedAnimation(parent: secondaryAnimation, curve: Curves.easeOut),
    );

    return SlideTransition(
      position: secondaryAnimation.status == AnimationStatus.forward
          ? exitSlideAnimation
          : slideAnimation,
      child: FadeTransition(
        opacity: secondaryAnimation.status == AnimationStatus.forward
            ? exitFadeAnimation
            : fadeAnimation,
        child: child,
      ),
    );
  }

  static Widget _buildFadeTransition(
    Animation<double> animation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
      child: child,
    );
  }
}

enum F1TransitionType { speedSlide, fade }
