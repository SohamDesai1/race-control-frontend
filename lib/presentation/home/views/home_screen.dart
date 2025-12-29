import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/presentation/calendar/views/calendar_screen.dart';
import 'package:frontend/presentation/home/cubit/bottom_bar_cubit.dart';
import 'package:frontend/presentation/home/views/dashboard_screen.dart';
import 'package:frontend/presentation/standings/views/standing_screen.dart';
import 'package:frontend/widgets/bottom_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List screens = [
      const DashboardScreen(),
      const StandingScreen(),
      const CalendarScreen(),
      const Center(child: Text('Settings Screen')),
    ];
    return BlocBuilder<NavigationCubit, int>(
      builder: (context, index) {
        return Scaffold(
          bottomNavigationBar: BottomNavBar(),
          body: screens[index],
        );
      },
    );
  }
}
