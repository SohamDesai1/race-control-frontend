import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../cubit/race_details_cubit.dart';
import '../../../utils/race_utils.dart';
import '../../../core/constants/route_names.dart';
import '../../../core/theme/f1_theme.dart';
import '../../../core/widgets/f1_loading_indicator.dart';

class RaceDetailScreen extends StatefulWidget {
  final String gpName;
  final String trackimage;
  final String season;
  final String raceId;
  final String round;
  const RaceDetailScreen({
    super.key,
    required this.trackimage,
    required this.gpName,
    required this.season,
    required this.raceId,
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
      widget.raceId,
      widget.season,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: F1Theme.f1Black,
        title: Text(
          widget.gpName,
          style: F1Theme.themeData.textTheme.displaySmall,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Enhanced Track Header
            Container(
              padding: EdgeInsets.all(F1Theme.mediumSpacing),
              decoration: BoxDecoration(
                gradient: F1Theme.redGradient,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(F1Theme.xLargeSpacing),
                  bottomRight: Radius.circular(F1Theme.xLargeSpacing),
                ),
                boxShadow: F1Theme.cardShadow,
              ),
              child: Center(
                child: SizedBox(
                  width: 90.w,
                  height: 32.h,
                  child: widget.trackimage.contains('png')
                      ? Image.asset(
                          widget.trackimage,
                          fit: BoxFit.contain,
                          color:
                              widget.trackimage.contains('Miami') ||
                                  widget.trackimage.contains('Imola')
                              ? F1Theme.f1White
                              : null,
                        )
                      : SvgPicture.asset(
                          widget.trackimage,
                          colorFilter: ColorFilter.mode(
                            F1Theme.f1White,
                            BlendMode.srcIn,
                          ),
                          fit: BoxFit.contain,
                        ),
                ),
              ),
            ),
            SizedBox(height: F1Theme.mediumSpacing),
            BlocBuilder<RaceDetailsCubit, RaceDetailsState>(
              builder: (context, state) {
                if (state.isLoadingRaceDetails) {
                  return Center(
                    child: F1LoadingIndicator(
                      message: 'Loading race details...',
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

                final raceDetails = state.raceDetails;
                if (raceDetails == null) {
                  return const SizedBox.shrink();
                }
                return Column(
                  children: [
                    SizedBox(
                      height: raceDetails.length * 10.h,
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: raceDetails.length,
                        itemBuilder: (context, index) {
                          final session = raceDetails[index];
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
                            decoration: BoxDecoration(
                              gradient: index % 2 == 0
                                  ? F1Theme.cardGradient
                                  : LinearGradient(
                                      colors: [
                                        F1Theme.f1MediumGray,
                                        F1Theme.f1MediumGray,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                              borderRadius: F1Theme.mediumBorderRadius,
                              boxShadow: F1Theme.cardShadow,
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: 1.h,
                              horizontal: 2.w,
                            ),
                            margin: EdgeInsets.only(bottom: 1.h),
                            child: Row(
                              children: [
                                // Date Column
                                SizedBox(
                                  width: 10.w,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        formattedDate.split(' ')[0], // Day
                                        style: F1Theme
                                            .themeData
                                            .textTheme
                                            .displaySmall
                                            ?.copyWith(
                                              fontSize: 6.w,
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                      Text(
                                        formattedDate.split(' ')[1], // Month
                                        style: F1Theme
                                            .themeData
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: F1Theme.f1TextGray,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Divider
                                Container(
                                  width: .5.w,
                                  height: 5.h,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [F1Theme.f1Red, F1Theme.f1White],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                    borderRadius: BorderRadius.circular(1),
                                  ),
                                  margin: EdgeInsets.symmetric(horizontal: 2.w),
                                ),
                                SizedBox(width: 2.w),
                                // Session Info
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        sessionName,
                                        style: F1Theme
                                            .themeData
                                            .textTheme
                                            .headlineMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.access_time,
                                            size: 3.w,
                                            color: F1Theme.f1TextGray,
                                          ),
                                          SizedBox(width: 1.w),
                                          Text(
                                            formattedTime,
                                            style: F1Theme
                                                .themeData
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color: F1Theme.f1TextGray,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                // Status
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 1.w,
                                    vertical: 0.5.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: RaceUtils.calcColor(
                                      dateTime.toLocal(),
                                    ).withOpacity(0.1),
                                    borderRadius: F1Theme.smallBorderRadius,
                                    border: Border.all(
                                      color: RaceUtils.calcColor(
                                        dateTime.toLocal(),
                                      ),
                                      width: 1,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      RaceUtils.calcStatus(dateTime.toLocal()),
                                      style: F1Theme
                                          .themeData
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: RaceUtils.calcColor(
                                              dateTime.toLocal(),
                                            ),
                                            fontWeight: FontWeight.w600,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 7 .w),
                                // View Details Button
                                GestureDetector(
                                  onTap: () {
                                    if (dateTime.toLocal().isAfter(
                                      DateTime.now(),
                                    )) {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          backgroundColor: F1Theme.f1DarkGray,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                F1Theme.mediumBorderRadius,
                                          ),
                                          title: Text(
                                            '$sessionName Details',
                                            style: F1Theme
                                                .themeData
                                                .textTheme
                                                .headlineMedium
                                                ?.copyWith(
                                                  color: F1Theme.f1Red,
                                                ),
                                          ),
                                          content: Text(
                                            'The session has not started yet.',
                                            style: F1Theme
                                                .themeData
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color: F1Theme.f1TextGray,
                                                ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text(
                                                'OK',
                                                style: F1Theme
                                                    .themeData
                                                    .textTheme
                                                    .labelLarge
                                                    ?.copyWith(
                                                      color: F1Theme.f1Red,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      if (sessionName == "Quali" ||
                                          sessionName == "Sprint Quali") {
                                        context.pushNamed(
                                          RouteNames.qualiDetails,
                                          extra: {
                                            'sessionKey': session.sessionKey
                                                .toString(),
                                            'sessionName': sessionName,
                                            'season': widget.season,
                                            'round': widget.round,
                                          },
                                        );
                                      } else {
                                        context.pushNamed(
                                          RouteNames.sessionDetails,
                                          extra: {
                                            'sessionKey': session.sessionKey
                                                .toString(),
                                            'sessionName': sessionName,
                                            'season': widget.season,
                                          },
                                        );
                                      }
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 2.w,
                                      vertical: 0.8.h,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: F1Theme.redGradient,
                                      borderRadius: F1Theme.smallBorderRadius,
                                      boxShadow: F1Theme.buttonShadow,
                                    ),
                                    child: Text(
                                      'View Details',
                                      style: F1Theme
                                          .themeData
                                          .textTheme
                                          .labelLarge
                                          ?.copyWith(color: F1Theme.f1White),
                                    ),
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
