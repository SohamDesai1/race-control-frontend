import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/presentation/home/cubit/dashboard/dashboard_cubit.dart';
import 'package:frontend/presentation/home/views/widgets/carousel.dart';
import 'package:frontend/presentation/home/views/widgets/driver_card.dart';
import 'package:frontend/presentation/home/views/widgets/upcoming_card.dart';
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
                builder: (context, state) {
                  if (state is DashboardLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is DashboardSuccess) {
                    return SizedBox(
                      height: 35.h,
                      child: ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          final race = state.races[index];
                          return UpcomingCard(
                            date: race.date,
                            raceName: race.raceName,
                            location: race.circuitId,
                          );
                        },
                        separatorBuilder: (context, index) =>
                            SizedBox(width: 2.w),
                        itemCount: state.races.length - 1,
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
              SizedBox(
                height: 20.h,
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 2.h),
                      child: const DriverCard(raceResult: true),
                    );
                  },
                ),
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
