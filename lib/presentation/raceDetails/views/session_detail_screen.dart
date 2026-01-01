import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import '../cubit/race_details_cubit.dart';
import '../../standings/views/widgets/standing_card.dart';
import '../../../utils/race_utils.dart';
import '../../../core/constants/route_names.dart';

class SessionDetailScreen extends StatefulWidget {
  final String sessionName;
  final String sessionKey;
  const SessionDetailScreen({
    super.key,
    required this.sessionName,
    required this.sessionKey,
  });

  @override
  State<SessionDetailScreen> createState() => _SessionDetailScreenState();
}

class _SessionDetailScreenState extends State<SessionDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<RaceDetailsCubit>().loadSessionDetails(widget.sessionKey);
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
          final sessionDetails = state.sessionDetails;
          if (sessionDetails == null) {
            return const Center(child: Text("No session details available."));
          }
          return Container(
            width: MediaQuery.of(context).size.width,
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
                  height: MediaQuery.of(context).size.height * 0.66,
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      final driver = sessionDetails[index];
                      final name = RaceUtils.mapDriverNameFromDriverNumber(
                        driver.driverNumber!,
                        2025,
                      );
                      final color = RaceUtils.getF1TeamColor(name);
                      return StandingCard(
                        position: index + 1,
                        driverName: name,
                        points: driver.points,
                        highlightColor: color,
                        index: index,
                      );
                    },
                    itemCount: sessionDetails.length,
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
                          for (var driver in sessionDetails.take(3))
                            driver.driverNumber!.toString():
                                RaceUtils.mapDriverNameFromDriverNumber(
                                  driver.driverNumber!,
                                  2025,
                                ),
                        },
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
            ),
          );
        },
      ),
    );
  }
}
