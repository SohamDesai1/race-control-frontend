import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'cubit/standings_cubit.dart';
import '../../../utils/race_utils.dart';
import 'widgets/standing_card.dart';
import '../../../core/theme/f1_theme.dart';
import '../../../core/constants/route_names.dart';
import '../../../widgets/f1_loading_indicator.dart';

class StandingScreen extends StatefulWidget {
  const StandingScreen({super.key});

  @override
  State<StandingScreen> createState() => _StandingScreenState();
}

class _StandingScreenState extends State<StandingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String selectedYear = DateTime.now().year.toString();

  Widget _buildStandingsHeaderCell(String text, IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: F1Theme.f1White, size: 4.w),
        SizedBox(width: F1Theme.smallSpacing),
        Text(
          text,
          style: F1Theme.themeData.textTheme.bodyLarge?.copyWith(
            color: F1Theme.f1White,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

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
        backgroundColor: F1Theme.f1Black,
        title: Text(
          'Standings',
          style: F1Theme.themeData.textTheme.displaySmall,
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: F1Theme.smallSpacing),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: F1Theme.smallSpacing),
              decoration: BoxDecoration(
                gradient: F1Theme.cardGradient,
                borderRadius: BorderRadius.circular(15),
              ),
              child: DropdownButton<String>(
                value: selectedYear,
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: F1Theme.f1White,
                  size: 4.w,
                ),
                underline: const SizedBox(),
                dropdownColor: F1Theme.f1DarkGray,
                style: F1Theme.themeData.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: F1Theme.f1White,
                ),
                items: ['2025', '2026'].map((String year) {
                  return DropdownMenuItem<String>(
                    value: year,
                    child: Text(
                      year,
                      style: F1Theme.themeData.textTheme.bodyLarge?.copyWith(
                        color: F1Theme.f1White,
                      ),
                    ),
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
        ],
      ),
      backgroundColor: F1Theme.f1Black,
      body: BlocBuilder<StandingsCubit, StandingsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return Center(
              child: F1LoadingIndicator(message: 'Loading standings...'),
            );
          }

          if (state.error != null) {
            return Center(
              child: Text(
                state.error!,
                style: F1Theme.themeData.textTheme.bodyLarge?.copyWith(
                  color: F1Theme.themeData.colorScheme.error,
                ),
              ),
            );
          }

          if (state.constructorLeaderboard == null ||
              state.driverLeaderboard == null) {
            return const SizedBox.shrink();
          }
          return Column(
            children: [
              SizedBox(height: 2.h),
              // Enhanced Tab Bar
              Container(
                margin: EdgeInsets.symmetric(horizontal: F1Theme.mediumSpacing),
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      F1Theme.f1Black.withOpacity(0.5),
                      F1Theme.f1Black.withOpacity(0.3),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(35),
                  border: Border.all(
                    color: F1Theme.f1Red.withOpacity(0.2),
                    width: 1.5,
                  ),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [F1Theme.f1Red, F1Theme.f1Red.withOpacity(0.8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: F1Theme.f1Red.withOpacity(0.5),
                        blurRadius: 12,
                        spreadRadius: 1,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  labelColor: F1Theme.f1White,
                  unselectedLabelColor: F1Theme.f1White.withOpacity(0.5),
                  labelStyle: F1Theme.themeData.textTheme.headlineSmall
                      ?.copyWith(
                        fontFamily: 'Formula1Bold',
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        letterSpacing: 0.5,
                      ),
                  unselectedLabelStyle: F1Theme
                      .themeData
                      .textTheme
                      .headlineSmall
                      ?.copyWith(
                        fontFamily: 'Formula1Regular',
                        fontSize: 12,
                        letterSpacing: 0.3,
                      ),
                  splashFactory: NoSplash.splashFactory,
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                  tabs: const [
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person, size: 18),
                          SizedBox(width: 4),
                          Text('Drivers'),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.directions_car, size: 18),
                          SizedBox(width: 4),
                          Text('Constructors'),
                        ],
                      ),
                    ),
                  ],
                ),
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
                        ? Center(
                            child: Text(
                              "Season not yet started",
                              style: F1Theme.themeData.textTheme.bodyLarge
                                  ?.copyWith(color: F1Theme.f1TextGray),
                            ),
                          )
                        : Container(
                            padding: EdgeInsets.all(F1Theme.mediumSpacing),

                            child: Column(
                              children: [
                                // Drivers Header
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: F1Theme.smallSpacing,
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(width: 4.w),
                                      _buildStandingsHeaderCell(
                                        'Pos',
                                        Icons.flag,
                                      ),
                                      SizedBox(width: 9.w),
                                      _buildStandingsHeaderCell(
                                        'Racer',
                                        Icons.person,
                                      ),
                                      SizedBox(width: 28.w),
                                      _buildStandingsHeaderCell(
                                        'Pts',
                                        Icons.star,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: F1Theme.smallSpacing),
                                // Drivers List
                                Expanded(
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemBuilder: (context, index) {
                                      final driver = context
                                          .read<StandingsCubit>()
                                          .state
                                          .driverLeaderboard![index];
                                      final color = RaceUtils.getF1TeamColor(
                                        driver.constructors[0].name,
                                        year: int.parse(selectedYear),
                                      );
                                      return StandingCard(
                                        position: int.parse(driver.position),
                                        driverName:
                                            "${driver.driver.givenName} ${driver.driver.familyName}",
                                        constructorName:
                                            driver.constructors[0].name,
                                        points: int.parse(driver.points),
                                        highlightColor: color,
                                        index: index,
                                        onTap: () {
                                          context.push(
                                            RouteNames.driverInfo,
                                            extra: {
                                              'driverName':
                                                  "${driver.driver.givenName} ${driver.driver.familyName}",
                                              'constructorName':
                                                  driver.constructors[0].name,
                                              'season': selectedYear,
                                            },
                                          );
                                        },
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
                        ? Center(
                            child: Text(
                              "Season not yet started",
                              style: F1Theme.themeData.textTheme.bodyLarge
                                  ?.copyWith(color: F1Theme.f1TextGray),
                            ),
                          )
                        : Container(
                            padding: EdgeInsets.all(F1Theme.mediumSpacing),

                            child: Column(
                              children: [
                                // Constructors Header
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: F1Theme.smallSpacing,
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(width: 4.w),
                                      _buildStandingsHeaderCell(
                                        'Pos',
                                        Icons.flag,
                                      ),
                                      SizedBox(width: 9.w),
                                      _buildStandingsHeaderCell(
                                        'Team',
                                        Icons.business,
                                      ),
                                      SizedBox(width: 28.w),
                                      _buildStandingsHeaderCell(
                                        'Pts',
                                        Icons.star,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: F1Theme.smallSpacing),
                                // Constructors List
                                Expanded(
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemBuilder: (context, index) {
                                      final constructor = context
                                          .read<StandingsCubit>()
                                          .state
                                          .constructorLeaderboard![index];
                                      final color = RaceUtils.getF1TeamColor(
                                        constructor.constructor.name,
                                        year: int.parse(selectedYear),
                                      );
                                      return StandingCard(
                                        position: int.parse(
                                          constructor.position,
                                        ),
                                        driverName:
                                            constructor.constructor.name,
                                        constructorName:
                                            constructor.constructor.name,
                                        points: int.parse(constructor.points),
                                        highlightColor: color,
                                        index: index,
                                        onTap: () {
                                          context.push(
                                            RouteNames.constructorInfo,
                                            extra: {
                                              'constructorName':
                                                  constructor.constructor.name,
                                              'season': selectedYear,
                                            },
                                          );
                                        },
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
