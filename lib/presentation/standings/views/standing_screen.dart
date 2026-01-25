import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'cubit/standings_cubit.dart';
import '../../../utils/race_utils.dart';
import 'widgets/standing_card.dart';
import '../../../core/theme/f1_theme.dart';
import '../../../core/widgets/f1_loading_indicator.dart';

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
              // Enhanced Year Selector
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: F1Theme.mediumSpacing,
                  vertical: F1Theme.smallSpacing,
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: F1Theme.mediumSpacing,
                  ),
                  decoration: BoxDecoration(
                    gradient: F1Theme.cardGradient,
                    borderRadius: F1Theme.largeBorderRadius,
                    boxShadow: F1Theme.cardShadow,
                  ),
                  child: DropdownButton<String>(
                    value: selectedYear,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: F1Theme.f1White,
                      size: 6.w,
                    ),
                    underline: const SizedBox(),
                    dropdownColor: F1Theme.f1DarkGray,
                    style: F1Theme.themeData.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    items: ['2025', '2026'].map((String year) {
                      return DropdownMenuItem<String>(
                        value: year,
                        child: Text(
                          year,
                          style: F1Theme.themeData.textTheme.bodyLarge
                              ?.copyWith(color: F1Theme.f1White),
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
              // Enhanced Tab Bar
              Container(
                margin: EdgeInsets.symmetric(horizontal: F1Theme.mediumSpacing),
                decoration: BoxDecoration(
                  gradient: F1Theme.redGradient,
                  borderRadius: F1Theme.mediumBorderRadius,
                  boxShadow: F1Theme.buttonShadow,
                ),
                child: TabBar(
                  indicatorColor: F1Theme.f1White,
                  labelColor: F1Theme.f1White,
                  unselectedLabelColor: F1Theme.f1White.withOpacity(0.7),
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorWeight: 3,
                  labelStyle: F1Theme.themeData.textTheme.headlineSmall
                      ?.copyWith(
                        fontFamily: 'Formula1Bold',
                        fontWeight: FontWeight.w700,
                      ),
                  unselectedLabelStyle: F1Theme.themeData.textTheme.bodyLarge
                      ?.copyWith(fontFamily: 'Formula1Regular'),
                  tabs: const [
                    Tab(text: 'Drivers'),
                    Tab(text: 'Constructors'),
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
                            decoration: BoxDecoration(
                              gradient: F1Theme.cardGradient,
                              borderRadius: F1Theme.mediumBorderRadius,
                              boxShadow: F1Theme.cardShadow,
                            ),
                            child: Column(
                              children: [
                                // Drivers Header
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: F1Theme.smallSpacing,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: F1Theme.redGradient,
                                    borderRadius: F1Theme.smallBorderRadius,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      _buildStandingsHeaderCell(
                                        'Pos',
                                        Icons.flag,
                                      ),
                                      _buildStandingsHeaderCell(
                                        'Driver',
                                        Icons.person,
                                      ),
                                      _buildStandingsHeaderCell(
                                        'Pts',
                                        Icons.star,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: F1Theme.mediumSpacing),
                                // Drivers List
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: F1Theme.f1DarkGray,
                                      borderRadius: F1Theme.mediumBorderRadius,
                                      boxShadow: [
                                        BoxShadow(
                                          color: F1Theme.f1Black.withOpacity(
                                            0.3,
                                          ),
                                          blurRadius: 4,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: ListView.builder(
                                      padding: EdgeInsets.zero,
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
                            decoration: BoxDecoration(
                              gradient: F1Theme.cardGradient,
                              borderRadius: F1Theme.mediumBorderRadius,
                              boxShadow: F1Theme.cardShadow,
                            ),
                            child: Column(
                              children: [
                                // Constructors Header
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: F1Theme.smallSpacing,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: F1Theme.redGradient,
                                    borderRadius: F1Theme.smallBorderRadius,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      _buildStandingsHeaderCell(
                                        'Pos',
                                        Icons.flag,
                                      ),
                                      _buildStandingsHeaderCell(
                                        'Team',
                                        Icons.business,
                                      ),
                                      _buildStandingsHeaderCell(
                                        'Pts',
                                        Icons.star,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: F1Theme.mediumSpacing),
                                // Constructors List
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: F1Theme.f1DarkGray,
                                      borderRadius: F1Theme.mediumBorderRadius,
                                      boxShadow: [
                                        BoxShadow(
                                          color: F1Theme.f1Black.withOpacity(
                                            0.3,
                                          ),
                                          blurRadius: 4,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: ListView.builder(
                                      padding: EdgeInsets.zero,
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
