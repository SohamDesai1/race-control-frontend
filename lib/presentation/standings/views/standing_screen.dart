import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/presentation/home/cubit/dashboard/dashboard_cubit.dart';
import 'package:frontend/presentation/standings/views/widgets/standing_card.dart';
import 'package:sizer/sizer.dart';

class StandingScreen extends StatefulWidget {
  const StandingScreen({super.key});

  @override
  State<StandingScreen> createState() => _StandingScreenState();
}

class _StandingScreenState extends State<StandingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Color getF1TeamColor(String constructorName) {
    switch (constructorName) {
      case 'Red Bull':
        return const Color(0xFF1E41FF); // Red Bull Blue

      case 'Ferrari':
        return const Color(0xFFDC0000);

      case 'Mercedes':
        return const Color(0xFF00D2BE);

      case 'McLaren':
        return const Color(0xFFFF8700);

      case 'Aston Martin':
        return const Color(0xFF006F62);

      case 'Alpine F1 Team':
        return const Color(0xFF0090FF);

      case 'Williams':
        return const Color(0xFF005AFF);

      case 'RB F1 Team':
        return const Color(0xFF2B4562);

      case 'Sauber':
        return const Color(0xFF900000);

      case 'Haas F1 Team':
        return const Color(0xFFFFFFFF);

      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text(
          'Standings',
          style: TextStyle(fontFamily: "Formula1Bold", color: Colors.white),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          TabBar(
            indicatorColor: Colors.red,
            labelColor: Colors.white,
            controller: _tabController,
            labelStyle: const TextStyle(
              fontSize: 18,
              fontFamily: 'Formula1Regular',
            ),
            tabs: const [
              Tab(text: 'Drivers'),
              Tab(text: 'Constructors'),
            ],
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.height * 0.8,
                  color: Color.fromARGB(255, 25, 18, 18),
                  child: Column(
                    children: [
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          SizedBox(width: 5.w),
                          Text(
                            'Pos',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(width: 18.w),
                          Text(
                            'Driver',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(width: 40.w),
                          Text(
                            'Pts',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      SizedBox(height: 1.h),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.62,
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            final driver = context
                                .read<DashboardCubit>()
                                .state
                                .driverLeaderboard![index];
                            final color = getF1TeamColor(
                              driver.constructors[0].name,
                            );
                            return DriverStandingCard(
                              position: int.parse(driver.position),
                              driverName:
                                  "${driver.driver.givenName} ${driver.driver.familyName}",
                              points: int.parse(driver.points),
                              highlightColor: color,
                            );
                          },
                          itemCount: context
                              .read<DashboardCubit>()
                              .state
                              .driverLeaderboard
                              ?.length,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.height * 0.8,
                  color: Color.fromARGB(255, 25, 18, 18),
                  child: Column(
                    children: [
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          SizedBox(width: 5.w),
                          Text(
                            'Pos',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(width: 18.w),
                          Text(
                            'Driver',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(width: 40.w),
                          Text(
                            'Pts',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      SizedBox(height: 1.h),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.62,
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            final constructor = context
                                .read<DashboardCubit>()
                                .state
                                .constructorLeaderboard![index];
                            final color = getF1TeamColor(
                              constructor.constructor.name,
                            );
                            return DriverStandingCard(
                              position: int.parse(constructor.position),
                              driverName: constructor.constructor.name,
                              points: int.parse(constructor.points),
                              highlightColor: color,
                            );
                          },
                          itemCount: context
                              .read<DashboardCubit>()
                              .state
                              .constructorLeaderboard
                              ?.length,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
