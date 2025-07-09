import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/presentation/auth/register/cubit/register_cubit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/core/router/app_router.dart';
import 'package:frontend/presentation/auth/login/cubit/login_cubit.dart';
import 'package:frontend/utils/injection.dart';
import 'package:sizer/sizer.dart';

void main() async {
  const isProd = !kDebugMode;
  await dotenv.load(fileName: isProd ? ".env.prod" : ".env.dev");
  await Supabase.initialize(
      url: dotenv.env['SUPABASE_PROJECT_URL']!,
      anonKey: dotenv.env['SUPABASE_ANNON_KEY']!);
  configureDependencies();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => getIt<LoginCubit>()),
      BlocProvider(create: (_) => getIt<RegisterCubit>())
    ],
    child: MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp.router(
          theme: ThemeData(
            scaffoldBackgroundColor: const Color(0xFF271F24),
            fontFamily: 'Formula1Regular',
            appBarTheme: AppBarTheme(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                toolbarHeight: 80,
                elevation: 0,
                titleTextStyle: const TextStyle(
                    fontSize: 22,
                    color: Colors.black,
                    fontWeight: FontWeight.w700),
                iconTheme: const IconThemeData(color: Colors.white)),
          ),
          debugShowCheckedModeBanner: false,
          routerConfig: Routing.router,
        );
      },
    );
  }
}
