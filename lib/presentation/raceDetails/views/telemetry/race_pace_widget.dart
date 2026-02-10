import 'package:flutter/material.dart';
import 'package:frontend/presentation/raceDetails/cubit/race_details_cubit.dart';
import 'package:frontend/presentation/raceDetails/views/race_pace_widget.dart';
import 'package:frontend/utils/race_utils.dart';
import 'package:sizer/sizer.dart';
import 'package:frontend/core/theme/f1_theme.dart';
import 'package:frontend/widgets/f1_loading_indicator.dart';

class RacePaceWidgett extends StatelessWidget {
  final RaceDetailsState state;
  final Map<String, String> drivers;
  final String season;
  final String sessionType;

  const RacePaceWidgett({
    super.key,
    required this.state,
    required this.drivers,
    required this.season,
    required this.sessionType,
  });

  @override
  Widget build(BuildContext context) {
    if (state.isLoadingRacePaceComparison) {
      return Center(
        child: F1LoadingIndicator(message: 'Loading lap times...', size: 60),
      );
    }

    if (state.error != null) {
      return Center(
        child: Text(
          state.error!,
          style: F1Theme.themeData.textTheme.bodyLarge?.copyWith(
            color: F1Theme.themeData.colorScheme.error,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    final hasSectorTimings =
        state.sectorTimings != null && state.sectorTimings!.isNotEmpty;

    if (!hasSectorTimings) {
      return Center(
        child: Text(
          'No lap times available',
          style: F1Theme.themeData.textTheme.bodyLarge?.copyWith(
            color: F1Theme.f1TextGray,
          ),
        ),
      );
    }

    final List<String> driverNames = [];
    final List<Color> colors = [];
    final Set<Color> usedColors = {};

    drivers.forEach((key, value) {
      Color baseColor = RaceUtils.getF1TeamColor(value).withAlpha(200);
      if (usedColors.contains(baseColor)) {
        baseColor = Colors.grey;
      }

      usedColors.add(baseColor);
      colors.add(baseColor);
      driverNames.add(value);
    });

    List<PacePoint> dataPoints =
        state.racePaceComparison?.map((e) {
          return PacePoint(
            x: e.x!.toDouble(),
            y: e.y!.toDouble(),
            minisector: e.minisector,
            fastestDriver: e.fastestDriver,
          );
        }).toList() ??
        [];

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(F1Theme.mediumSpacing),
        margin: EdgeInsets.symmetric(horizontal: F1Theme.smallSpacing),
        decoration: BoxDecoration(
          gradient: F1Theme.cardGradient,
          borderRadius: F1Theme.mediumBorderRadius,
          boxShadow: F1Theme.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TelemetryDescription(
              description:
                  'Analyze race pace throughout the entire race distance. Track lap time consistency, identify tire degradation, and compare strategic approaches. Green zones indicate faster laps.',
            ),
            sessionType == "Race"
                ? Column(
                    children: [
                      Divider(color: F1Theme.f1LightGray, height: 1),
                      SizedBox(height: F1Theme.mediumSpacing),
                      Text(
                        "Race Pace Comparison",
                        style: F1Theme.themeData.textTheme.headlineMedium
                            ?.copyWith(
                              color: F1Theme.f1White,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      SizedBox(height: F1Theme.mediumSpacing),
                      SizedBox(
                        height: 50.h,
                        child: RacePaceScreen(
                          dataPoints: dataPoints,
                          colors: colors,
                          driver1: driverNames.isNotEmpty
                              ? driverNames[0]
                              : 'Driver 1',
                          driver2: driverNames.length > 1
                              ? driverNames[1]
                              : 'Driver 2',
                        ),
                      ),
                      SizedBox(height: F1Theme.smallSpacing),
                    ],
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

class _TelemetryDescription extends StatelessWidget {
  final String description;

  const _TelemetryDescription({required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(F1Theme.mediumSpacing),
      margin: EdgeInsets.only(bottom: F1Theme.mediumSpacing),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            F1Theme.f1Red.withOpacity(0.15),
            F1Theme.f1Red.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: F1Theme.mediumBorderRadius,
        border: Border.all(color: F1Theme.f1Red.withOpacity(0.3), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: F1Theme.f1Red, size: 20),
          SizedBox(width: F1Theme.smallSpacing),
          Expanded(
            child: Text(
              description,
              style: F1Theme.themeData.textTheme.bodyMedium?.copyWith(
                color: F1Theme.f1White.withOpacity(0.9),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
