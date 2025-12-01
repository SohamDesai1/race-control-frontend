import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import '../cubit/dashboard/dashboard_cubit.dart';
import '../../../core/constants/route_names.dart';
import 'widgets/carousel.dart';
import 'widgets/driver_card.dart';
import 'widgets/upcoming_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardCubit>().fetchUpcomingRaces();
    context.read<DashboardCubit>().fetchRecentResults();
    context.read<DashboardCubit>().fetchDriverLeaderboard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Carousel(),
              SizedBox(height: 3.h),
              Text(
                "Upcoming Races",
                style: TextStyle(fontSize: 5.w, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 2.h),
              BlocBuilder<DashboardCubit, DashboardState>(
                buildWhen: (prev, curr) =>
                    curr is DashboardUpcomingLoading ||
                    curr is DashboardUpcomingSuccess ||
                    curr is DashboardError,
                builder: (context, state) {
                  if (state is DashboardUpcomingLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is DashboardUpcomingSuccess) {
                    var length = state.upcomingRaces.length <= 2
                        ? state.upcomingRaces.length
                        : state.upcomingRaces.length - 1;

                    return SizedBox(
                      height: length * 17.h,
                      child: ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          final race = state.upcomingRaces[index];
                          DateTime date = DateTime.parse(race.date);
                          String formattedDate = DateFormat(
                            'dd MMM',
                          ).format(date);
                          return UpcomingCard(
                            date: formattedDate,
                            raceName: race.raceName,
                            location: "${race.locality}, ${race.country}",
                          );
                        },
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 2.h),
                        itemCount: length,
                      ),
                    );
                  } else if (state is DashboardError) {
                    return Center(child: Text(state.message));
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),
              SizedBox(height: 2.h),
              Text(
                "Recent Race Results",
                style: TextStyle(fontSize: 5.w, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 2.h),
              BlocBuilder<DashboardCubit, DashboardState>(
                buildWhen: (prev, curr) =>
                    curr is DashboardRecentLoading ||
                    curr is DashboardRecentSuccess ||
                    curr is DashboardError,
                builder: (context, state) {
                  if (state is DashboardRecentLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is DashboardRecentSuccess) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              state.recentResults.raceName,
                              style: TextStyle(
                                fontSize: 4.w,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                context.pushNamed(
                                  RouteNames.raceResults,
                                  extra: {
                                    'raceName': state.recentResults.raceName,
                                    'raceResults': state.recentResults.results,
                                  },
                                );
                              },
                              child: Text(
                                "Full Results",
                                style: TextStyle(
                                  fontSize: 3.5.w,
                                  color: Colors.red,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2.h),
                        SizedBox(
                          height: 20.h,
                          child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: 3,
                            itemBuilder: (context, index) {
                              final recent = state.recentResults.results[index];
                              return Padding(
                                padding: EdgeInsets.only(bottom: 2.h),
                                child: DriverCard(
                                  driverName:
                                      "${recent.driver.givenName} ${recent.driver.familyName}",
                                  teamName: recent.constructor.name,
                                  position: recent.position,
                                  raceResult: true,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  } else if (state is DashboardError) {
                    return Text(state.message);
                  }
                  return SizedBox.shrink();
                },
              ),
              Text(
                "Top Drivers",
                style: TextStyle(fontSize: 5.w, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 2.h),
              BlocBuilder<DashboardCubit, DashboardState>(
                buildWhen: (prev, curr) =>
                    curr is DashboardDriverLeaderboardLoading ||
                    curr is DashboardDriverLeaderboardSuccess ||
                    curr is DashboardError,
                builder: (context, state) {
                  if (state is DashboardDriverLeaderboardLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is DashboardDriverLeaderboardSuccess) {
                    return SizedBox(
                      height: 20.h,
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          final recent = state.driverLeaderboard[index];
                          return Padding(
                            padding: EdgeInsets.only(bottom: 2.h),
                            child: DriverCard(
                              driverName:
                                  "${recent.driver.givenName} ${recent.driver.familyName}",
                              teamName: recent.constructors.first.name,
                              points: recent.points,
                            ),
                          );
                        },
                      ),
                    );
                  } else if (state is DashboardError) {
                    return Text(state.message);
                  }
                  return SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
