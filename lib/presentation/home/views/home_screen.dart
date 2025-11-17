import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/presentation/home/cubit/bottom_bar_cubit.dart';
import 'package:frontend/presentation/home/views/dashboard_screen.dart';
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
      const Center(child: Text('Standings Screen')),
      const Center(child: Text('Drivers Screen')),
      const Center(child: Text('Settings Screen')),
    ];
    return BlocBuilder<NavigationCubit, int>(
      builder: (context, index) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: const Text('F1 Hub',
                style:
                    TextStyle(fontFamily: "Formula1Bold", color: Colors.white)),
            centerTitle: true,
          ),
          bottomNavigationBar: BottomNavBar(),
          body: screens[index],
        );
      },
    );
  }
}
