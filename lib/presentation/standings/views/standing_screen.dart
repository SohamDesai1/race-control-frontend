import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'cubit/standings_cubit.dart';
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
  String selectedYear = DateTime.now().year.toString();
  @override
  void initState() {
    super.initState();
    context.read<StandingsCubit>().loadStandingsData(int.parse(selectedYear));
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
      body: BlocBuilder<StandingsCubit, StandingsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
            return Center(child: Text(state.error!));
          }

          if (state.constructorLeaderboard == null ||
              state.driverLeaderboard == null) {
            return const SizedBox.shrink();
          }
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 3.w),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 35, 35, 35),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButton<String>(
                    value: selectedYear,
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.white,
                    ),
                    underline: const SizedBox(),
                    dropdownColor: const Color.fromARGB(255, 35, 35, 35),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    items: ['2025', '2026'].map((String year) {
                      return DropdownMenuItem<String>(
                        value: year,
                        child: Text(year),
                      );
                    }).toList(),
                    onChanged: (String? newYear) {
                      if (newYear != null && newYear != selectedYear) {
                        setState(() {
                          selectedYear = newYear;
                        });
                        context.read<StandingsCubit>().loadStandingsData(
                          int.parse(selectedYear),
                        );
                      }
                    },
                  ),
                ),
              ),
              TabBar(
                indicatorColor: Colors.red,
                labelColor: Colors.white,
                controller: _tabController,
                labelStyle: TextStyle(
                  fontSize: 5.w,
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
                    context
                            .read<StandingsCubit>()
                            .state
                            .driverLeaderboard!
                            .isEmpty
                        ? Center(child: Text("Season not yet started"))
                        : Container(
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
                                  height:
                                      MediaQuery.of(context).size.height * 0.6,
                                  child: ListView.builder(
                                    itemBuilder: (context, index) {
                                      final driver = context
                                          .read<StandingsCubit>()
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
                                        .read<StandingsCubit>()
                                        .state
                                        .driverLeaderboard
                                        ?.length,
                                  ),
                                ),
                              ],
                            ),
                          ),
                    context
                            .read<StandingsCubit>()
                            .state
                            .constructorLeaderboard!
                            .isEmpty
                        ? Center(child: Text("Season not yet started"))
                        : Container(
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
                                  height:
                                      MediaQuery.of(context).size.height * 0.6,
                                  child: ListView.builder(
                                    itemBuilder: (context, index) {
                                      final constructor = context
                                          .read<StandingsCubit>()
                                          .state
                                          .constructorLeaderboard![index];
                                      final color = RaceUtils.getF1TeamColor(
                                        constructor.constructor.name,
                                      );
                                      return StandingCard(
                                        position: int.parse(
                                          constructor.position,
                                        ),
                                        driverName:
                                            constructor.constructor.name,
                                        points: int.parse(constructor.points),
                                        highlightColor: color,
                                        index: index,
                                      );
                                    },
                                    itemCount: context
                                        .read<StandingsCubit>()
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
          );
        },
      ),
    );
  }
}
