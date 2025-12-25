import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constants/route_names.dart';
import 'package:frontend/presentation/home/cubit/dashboard/dashboard_cubit.dart';
import 'package:frontend/presentation/home/views/widgets/carousel.dart';
import 'package:frontend/presentation/home/views/widgets/driver_card.dart';
import 'package:frontend/presentation/home/views/widgets/upcoming_card.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardCubit>().loadDashboardData(); // Only once
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text(
          'F1 Hub',
          style: TextStyle(fontFamily: "Formula1Bold", color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: BlocBuilder<DashboardCubit, DashboardState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.error != null) {
              log("Error loading dashboard data: ${state.error}");
              return Center(child: Text(state.error!));
            }

            if (!state.hasLoaded) {
              return const SizedBox.shrink();
            }

            final upcoming = state.upcomingRaces;
            final recent = state.recentResults;
            final leaderboard = state.driverLeaderboard;

            final upcomingLength = upcoming!.length <= 2 ? upcoming.length : 3;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Carousel(),
                  SizedBox(height: 2.h),

                  Text(
                    "Upcoming Races",
                    style: TextStyle(
                      fontSize: 5.w,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  if (upcoming.isEmpty)
                    Text(
                      "No upcoming races available.",
                      style: TextStyle(fontSize: 4.w),
                    ),
                  if (upcoming.isNotEmpty)
                    SizedBox(
                      height: upcomingLength * 17.5.h,
                      child: ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: upcomingLength,
                        separatorBuilder: (_, __) => SizedBox(height: 2.h),
                        itemBuilder: (context, index) {
                          final race = upcoming[index];
                          final date = DateTime.parse(race.date!);
                          final formatted = DateFormat('dd MMM').format(date);

                          return UpcomingCard(
                            date: formatted,
                            raceName: race.raceName!,
                            location: "${race.locality}, ${race.country}",
                          );
                        },
                      ),
                    ),

                  SizedBox(height: 3.h),

                  Text(
                    "Recent Race Results",
                    style: TextStyle(
                      fontSize: 5.w,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2.h),

                  if (recent != null) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          recent.raceName,
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
                                'raceName': recent.raceName,
                                'raceResults': recent.results,
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
                        itemBuilder: (_, index) {
                          final r = recent.results[index];
                          return Padding(
                            padding: EdgeInsets.only(bottom: 2.h),
                            child: DriverCard(
                              driverName:
                                  "${r.driver.givenName} ${r.driver.familyName}",
                              teamName: r.constructor.name,
                              position: r.position,
                              raceResult: true,
                            ),
                          );
                        },
                      ),
                    ),
                  ],

                  SizedBox(height: 3.h),
                  Text(
                    "Top Drivers",
                    style: TextStyle(
                      fontSize: 5.w,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2.h),

                  SizedBox(
                    height: 20.h,
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 3,
                      itemBuilder: (_, index) {
                        final d = leaderboard![index];
                        return Padding(
                          padding: EdgeInsets.only(bottom: 2.h),
                          child: DriverCard(
                            driverName:
                                "${d.driver.givenName} ${d.driver.familyName}",
                            teamName: d.constructors.first.name,
                            points: d.points,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
