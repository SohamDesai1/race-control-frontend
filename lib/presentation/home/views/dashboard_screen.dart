import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/presentation/home/cubit/dashboard/dashboard_cubit.dart';
import 'package:frontend/presentation/home/views/widgets/carousel.dart';
import 'package:frontend/presentation/home/views/widgets/driver_card.dart';
import 'package:frontend/presentation/home/views/widgets/upcoming_card.dart';
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
    context.read<DashboardCubit>().fetchUpcomingRaces();
    context.read<DashboardCubit>().fetchRecentResults();
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
              Text("Upcoming Races", style: TextStyle(fontSize: 4.w)),
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
              Text("Recent Race Results", style: TextStyle(fontSize: 4.w)),
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
                    return SizedBox(
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
                    );
                  } else if (state is DashboardError) {
                    return Text(state.message);
                  }
                  return SizedBox.shrink();
                },
              ),
              Text("Top Drivers", style: TextStyle(fontSize: 4.w)),
              SizedBox(height: 2.h),
              SizedBox(
                height: 20.h,
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 2.h),
                      child: const DriverCard(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
