import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constants/route_names.dart';
import 'package:frontend/presentation/raceDetails/cubit/race_details_cubit.dart';
import 'package:frontend/presentation/standings/views/widgets/standing_card.dart';
import 'package:frontend/utils/race_utils.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          "${widget.sessionName} Details",
          style: TextStyle(fontFamily: "Formula1Bold", color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<RaceDetailsCubit, RaceDetailsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
            return Center(child: Text(state.error!));
          }
          final details = state.qualiDetails;
          if (details == null) {
            return const Center(child: Text("No session details available."));
          }
          return Column(
            children: [
              TabBar(
                indicatorColor: Colors.red,
                labelColor: Colors.white,
                controller: _tabController,
                labelStyle: TextStyle(
                  fontSize: 5.w,
                  fontFamily: 'Formula1Regular',
                ),
                tabs: [
                  Tab(text: 'Q1'),
                  Tab(text: 'Q2'),
                  Tab(text: 'Q3'),
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
                          SizedBox(height: 2.h),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.66,
                            child: ListView.builder(
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
                          SizedBox(height: 2.h),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.66,
                            child: ListView.builder(
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
                          SizedBox(height: 2.h),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.66,
                            child: ListView.builder(
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 2.h),
              GestureDetector(
                onTap: () {
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
                    },
                  );
                },
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 30, 0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      "View Telemetry",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Formula1Bold",
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
