import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../home/cubit/dashboard/dashboard_cubit.dart';
import '../../../utils/race_utils.dart';
import 'widgets/standing_card.dart';

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
            labelStyle: TextStyle(fontSize: 5.w, fontFamily: 'Formula1Regular'),
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
                          SizedBox(width: 13.w),
                          Text(
                            'Driver',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(width: 43.w),
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
                            final color = RaceUtils.getF1TeamColor(
                              driver.constructors[0].name,
                            );
                            return StandingCard(
                              position: int.parse(driver.position),
                              driverName:
                                  "${driver.driver.givenName} ${driver.driver.familyName}",
                              points: int.parse(driver.points),
                              highlightColor: color,
                              index: index,
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
                          SizedBox(width: 13.w),
                          Text(
                            'Team',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(width: 43.w),
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
                            final color = RaceUtils.getF1TeamColor(
                              constructor.constructor.name,
                            );
                            return StandingCard(
                              position: int.parse(constructor.position),
                              driverName: constructor.constructor.name,
                              points: int.parse(constructor.points),
                              highlightColor: color,
                              index: index,
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
