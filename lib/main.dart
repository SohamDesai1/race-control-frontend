import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/presentation/auth/register/cubit/register_cubit.dart';
import 'package:frontend/presentation/calendar/views/cubit/calendar_cubit.dart';
import 'package:frontend/presentation/home/cubit/bottom_bar_cubit.dart';
import 'package:frontend/presentation/home/cubit/dashboard/dashboard_cubit.dart';
import 'package:frontend/presentation/raceDetails/cubit/race_details_cubit.dart';
import 'package:frontend/presentation/standings/views/cubit/standings_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/core/router/app_router.dart';
import 'package:frontend/presentation/auth/login/cubit/login_cubit.dart';
import 'package:frontend/utils/injection.dart';
import 'package:sizer/sizer.dart';
import 'package:frontend/core/theme/f1_theme.dart';

void main() async {
  const isProd = !kDebugMode;
  await dotenv.load(fileName: isProd ? ".env.prod" : ".env.dev");
  configureDependencies();
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
      ],
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

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
