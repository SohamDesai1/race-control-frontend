import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/utils/race_utils.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../cubit/race_details_cubit.dart';

class RaceDetailScreen extends StatefulWidget {
  final String gpName;
  final String trackimage;
  final String season;
  final String round;
  const RaceDetailScreen({
    super.key,
    required this.trackimage,
    required this.gpName,
    required this.season,
    required this.round,
  });

  @override
  State<RaceDetailScreen> createState() => _RaceDetailScreenState();
}

class _RaceDetailScreenState extends State<RaceDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<RaceDetailsCubit>().loadRaceDetails(
      widget.season,
      widget.round,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          widget.gpName,
          style: TextStyle(fontFamily: "Formula1Bold", color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: SizedBox(
                width: 80.w,
                height: 30.h,
                child: widget.trackimage.contains('png')
                    ? Image.asset(
                        widget.trackimage,
                        fit: BoxFit.contain,
                        color:
                            widget.trackimage.contains('Miami') ||
                                widget.trackimage.contains('Imola')
                            ? Colors.white
                            : null,
                      )
                    : SvgPicture.asset(
                        widget.trackimage,
                        colorFilter: ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                        fit: BoxFit.contain,
                      ),
              ),
            ),
            BlocBuilder<RaceDetailsCubit, RaceDetailsState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.error != null) {
                  return Center(child: Text(state.error!));
                }

                final raceDetails = state.raceDetails;
                if (raceDetails == null) {
                  return const SizedBox.shrink();
                }

                return Column(
                  children: [
                    SizedBox(
                      height: raceDetails.sessions.length * 10.h,
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: raceDetails.sessions.length,
                        itemBuilder: (context, index) {
                          final session = raceDetails.sessions[index];
                          final sessionName = RaceUtils.mapSessionName(
                            session.sessionType!,
                          );
                          final formattedDate = DateFormat(
                            'dd MMM',
                          ).format(session.date!);
                          final dateStr = DateFormat(
                            'yyyy-MM-dd',
                          ).format(session.date!);
                          final timeStr = session.time!.replaceAll(
                            RegExp(r'\+\d{2}$'),
                            '',
                          );
                          final dateTime = DateTime.parse(
                            '${dateStr}T${timeStr}Z',
                          );
                          final formattedTime = DateFormat(
                            'HH:mm',
                          ).format(dateTime.toLocal());
                          return Container(
                            color: index % 2 == 0
                                ? Color.fromARGB(
                                    255,
                                    255,
                                    30,
                                    0,
                                  ).withOpacity(0.5)
                                : Colors.black,
                            padding: EdgeInsets.symmetric(
                              vertical: 1.h,
                              horizontal: 2.w,
                            ),
                            margin: EdgeInsets.only(bottom: 1.h),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 10.w,
                                  child: Text(
                                    formattedDate,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                Container(
                                  width: .5.w,
                                  height: 5.h,
                                  color: Colors.white,
                                  margin: EdgeInsets.symmetric(horizontal: 2.w),
                                ),
                                SizedBox(width: 2.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        sessionName,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 5.w,
                                        ),
                                      ),
                                      Text(
                                        formattedTime,
                                        style: TextStyle(
                                          color: Colors.grey[400],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (dateTime.isAfter(DateTime.now())) {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          backgroundColor: Colors.grey[900],
                                          title: Text(
                                            '$sessionName Details',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          content: Text(
                                            'The session has not started yet.',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text(
                                                'OK',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  },
                                  child: Text(
                                    'View Details',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 2.h),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
