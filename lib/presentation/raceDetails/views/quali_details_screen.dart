import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constants/route_names.dart';
import 'package:frontend/presentation/raceDetails/cubit/race_details_cubit.dart';
import 'package:frontend/presentation/standings/views/widgets/standing_card.dart';
import 'package:frontend/utils/race_utils.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:frontend/core/theme/f1_theme.dart';
import 'package:frontend/core/widgets/f1_loading_indicator.dart';

class QualiDetailsScreen extends StatefulWidget {
  final String sessionName;
  final String sessionKey;
  final String season;
  final String round;
  const QualiDetailsScreen({
    super.key,
    required this.sessionName,
    required this.sessionKey,
    required this.season,
    required this.round,
  });

  @override
  State<QualiDetailsScreen> createState() => _QualiDetailsScreenState();
}

class _QualiDetailsScreenState extends State<QualiDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  bool _showFab = true;
  double _lastScrollPosition = 0;

  void _onScroll() {
    final currentPosition = _scrollController.position.pixels;
    if (currentPosition > _lastScrollPosition && currentPosition > 100) {
      // Scrolling down
      if (_showFab) {
        setState(() => _showFab = false);
      }
    } else if (currentPosition < _lastScrollPosition) {
      // Scrolling up
      if (!_showFab) {
        setState(() => _showFab = true);
      }
    }
    _lastScrollPosition = currentPosition;
  }

  Widget _buildQualiHeaderCell(String text, IconData icon) {
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
    _tabController = TabController(length: 3, vsync: this);
    _scrollController.addListener(_onScroll);
    if (widget.sessionName == "Quali") {
      context.read<RaceDetailsCubit>().loadQualiSessionData(
        widget.season,
        widget.round,
      );
    } else {
      context.read<RaceDetailsCubit>().loadSprintQualiSessionData(
        widget.sessionKey,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: F1Theme.f1Black,
        title: Text(
          "${widget.sessionName} Details",
          style: F1Theme.themeData.textTheme.displaySmall,
        ),
        centerTitle: true,
        bottom: TabBar(
          indicatorColor: F1Theme.f1Red,
          labelColor: F1Theme.f1White,
          controller: _tabController,
          indicatorSize: TabBarIndicatorSize.label,
          indicatorWeight: 3,
          labelStyle: TextStyle(
            fontSize: 5.w,
            fontFamily: 'Formula1Bold',
            fontWeight: FontWeight.w700,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 4.5.w,
            fontFamily: 'Formula1Regular',
          ),
          tabs: [
            Tab(text: 'Q1'),
            Tab(text: 'Q2'),
            Tab(text: 'Q3'),
          ],
        ),
      ),
      body: BlocBuilder<RaceDetailsCubit, RaceDetailsState>(
        builder: (context, state) {
          if (state.isLoadingQualiDetails) {
            return Center(
              child: F1LoadingIndicator(
                message: 'Loading qualifying details...',
              ),
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
          final details = state.qualiDetails;
          if (details == null) {
            return const Center(child: Text("No session details available."));
          }
          return TabBarView(
            controller: _tabController,
            children: [
              Container(
                padding: EdgeInsets.all(F1Theme.mediumSpacing),
                decoration: BoxDecoration(
                  gradient: F1Theme.cardGradient,
                  borderRadius: F1Theme.mediumBorderRadius,
                  boxShadow: F1Theme.cardShadow,
                ),
                child: Column(
                  children: [
                    // Q1 Header
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: F1Theme.smallSpacing,
                      ),
                      decoration: BoxDecoration(
                        gradient: F1Theme.redGradient,
                        borderRadius: F1Theme.smallBorderRadius,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildQualiHeaderCell('Pos', Icons.flag),
                          _buildQualiHeaderCell('Driver', Icons.person),
                          _buildQualiHeaderCell('Pts', Icons.star),
                        ],
                      ),
                    ),
                    SizedBox(height: F1Theme.mediumSpacing),
                    // Q1 Results
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: F1Theme.f1DarkGray,
                          borderRadius: F1Theme.mediumBorderRadius,
                          boxShadow: [
                            BoxShadow(
                              color: F1Theme.f1Black.withOpacity(0.3),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          controller: _scrollController,
                          itemBuilder: (context, index) {
                            final driver = details.q1![index];
                            final name =
                                RaceUtils.mapDriverNameFromDriverNumber(
                                  int.parse(driver.driverNumber!),
                                  int.parse(widget.season),
                                );
                            final color = RaceUtils.getF1TeamColor(name);
                            return StandingCard(
                              position: index + 1,
                              driverName: name,
                              highlightColor: color,
                              index: index,
                            );
                          },
                          itemCount: details.q1!.length,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(F1Theme.mediumSpacing),
                decoration: BoxDecoration(
                  gradient: F1Theme.cardGradient,
                  borderRadius: F1Theme.mediumBorderRadius,
                  boxShadow: F1Theme.cardShadow,
                ),
                child: Column(
                  children: [
                    // Q2 Header
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: F1Theme.smallSpacing,
                      ),
                      decoration: BoxDecoration(
                        gradient: F1Theme.redGradient,
                        borderRadius: F1Theme.smallBorderRadius,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildQualiHeaderCell('Pos', Icons.flag),
                          _buildQualiHeaderCell('Driver', Icons.person),
                          _buildQualiHeaderCell('Pts', Icons.star),
                        ],
                      ),
                    ),
                    SizedBox(height: F1Theme.mediumSpacing),
                    // Q2 Results
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: F1Theme.f1DarkGray,
                          borderRadius: F1Theme.mediumBorderRadius,
                          boxShadow: [
                            BoxShadow(
                              color: F1Theme.f1Black.withOpacity(0.3),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          controller: _scrollController,
                          itemBuilder: (context, index) {
                            final driver = details.q2![index];
                            final name =
                                RaceUtils.mapDriverNameFromDriverNumber(
                                  int.parse(driver.driverNumber!),
                                  int.parse(widget.season),
                                );
                            final color = RaceUtils.getF1TeamColor(name);
                            return StandingCard(
                              position: index + 1,
                              driverName: name,
                              highlightColor: color,
                              index: index,
                            );
                          },
                          itemCount: details.q2!.length,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(F1Theme.mediumSpacing),
                decoration: BoxDecoration(
                  gradient: F1Theme.cardGradient,
                  borderRadius: F1Theme.mediumBorderRadius,
                  boxShadow: F1Theme.cardShadow,
                ),
                child: Column(
                  children: [
                    // Q3 Header
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: F1Theme.smallSpacing,
                      ),
                      decoration: BoxDecoration(
                        gradient: F1Theme.redGradient,
                        borderRadius: F1Theme.smallBorderRadius,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildQualiHeaderCell('Pos', Icons.flag),
                          _buildQualiHeaderCell('Driver', Icons.person),
                          _buildQualiHeaderCell('Pts', Icons.star),
                        ],
                      ),
                    ),
                    SizedBox(height: F1Theme.mediumSpacing),
                    // Q3 Results
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: F1Theme.f1DarkGray,
                          borderRadius: F1Theme.mediumBorderRadius,
                          boxShadow: [
                            BoxShadow(
                              color: F1Theme.f1Black.withOpacity(0.3),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          controller: _scrollController,
                          itemBuilder: (context, index) {
                            final driver = details.q3![index];
                            final name =
                                RaceUtils.mapDriverNameFromDriverNumber(
                                  int.parse(driver.driverNumber!),
                                  int.parse(widget.season),
                                );
                            final color = RaceUtils.getF1TeamColor(name);
                            return StandingCard(
                              position: index + 1,
                              driverName: name,
                              highlightColor: color,
                              index: index,
                            );
                          },
                          itemCount: details.q3!.length,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: _showFab
          ? BlocBuilder<RaceDetailsCubit, RaceDetailsState>(
              builder: (context, state) {
                final details = state.qualiDetails;
                if (details == null || state.isLoadingQualiDetails) {
                  return Container(); // Hide button when loading or no data
                }
                return FloatingActionButton.extended(
                  onPressed: () {
                    context.pushNamed(
                      RouteNames.telemetryDetails,
                      extra: {
                        "sessionKey": widget.sessionKey,
                        "drivers": {
                          for (var driver in details.q3!.take(3))
                            driver.driverNumber!.toString():
                                RaceUtils.mapDriverNameFromDriverNumber(
                                  int.parse(driver.driverNumber!),
                                  int.parse(widget.season),
                                ),
                        },
                        "season": widget.season,
                        "sessionType": widget.sessionName,
                      },
                    );
                  },
                  label: Row(
                    children: [
                      Icon(Icons.analytics, color: F1Theme.f1White, size: 4.w),
                      SizedBox(width: F1Theme.smallSpacing),
                      Text(
                        "View Telemetry",
                        style: F1Theme.themeData.textTheme.bodyMedium?.copyWith(
                          color: F1Theme.f1White,
                          fontFamily: "Formula1Bold",
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: F1Theme.f1Red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 4,
                );
              },
            )
          : null,
    );
  }
}
