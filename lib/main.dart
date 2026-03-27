import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/services/notification_service.dart';
import 'package:frontend/core/services/shorebird_update_service.dart';
import 'package:frontend/presentation/auth/register/cubit/register_cubit.dart';
import 'package:frontend/presentation/calendar/views/cubit/calendar_cubit.dart';
import 'package:frontend/presentation/home/cubit/bottom_bar_cubit.dart';
import 'package:frontend/presentation/home/cubit/dashboard/dashboard_cubit.dart';
import 'package:frontend/presentation/raceDetails/cubit/race_details_cubit.dart';
import 'package:frontend/presentation/settings/cubit/settings_cubit.dart';
import 'package:frontend/presentation/standings/views/cubit/standings_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/core/router/app_router.dart';
import 'package:frontend/presentation/auth/login/cubit/login_cubit.dart';
import 'package:restart_app/restart_app.dart';
import 'package:frontend/utils/injection.dart';
import 'package:sizer/sizer.dart';
import 'package:frontend/core/theme/f1_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const isProd = kReleaseMode;
  await dotenv.load(fileName: isProd ? ".env.prod" : ".env.dev");
  configureDependencies();
  await getIt<NotificationService>().initialize();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<LoginCubit>()),
        BlocProvider(create: (_) => getIt<RegisterCubit>()),
        BlocProvider(create: (_) => getIt<NavigationCubit>()),
        BlocProvider(create: (_) => getIt<DashboardCubit>()),
        BlocProvider(create: (_) => getIt<RaceDetailsCubit>()),
        BlocProvider(create: (_) => getIt<CalendarCubit>()),
        BlocProvider(create: (_) => getIt<StandingsCubit>()),
        BlocProvider(create: (_) => getIt<SettingsCubit>()),
      ],
      child: MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final ShorebirdUpdateService _shorebirdUpdateService =
      ShorebirdUpdateService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForStartupUpdate();
    });
  }

  Future<void> _checkForStartupUpdate() async {
    final outcome = await _shorebirdUpdateService.checkForUpdatesAndInstall();
    if (!mounted) {
      return;
    }

    if (outcome == ShorebirdUpdateOutcome.updated) {
      await _showRestartDialog();
    }
  }

  Future<void> _showRestartDialog() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: F1Theme.f1DarkGray,
        title: const Text(
          'Update Ready',
          style: TextStyle(color: F1Theme.f1White),
        ),
        content: const Text(
          'A new patch has been downloaded. Restart now to apply it.',
          style: TextStyle(color: F1Theme.f1TextGray),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Later',
              style: TextStyle(color: F1Theme.f1TextGray),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Restart.restartApp();
            },
            child: const Text(
              'Restart now',
              style: TextStyle(color: F1Theme.f1Red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp.router(
          theme: F1Theme.themeData,
          debugShowCheckedModeBanner: false,
          routerConfig: Routing.router,
        );
      },
    );
  }
}
