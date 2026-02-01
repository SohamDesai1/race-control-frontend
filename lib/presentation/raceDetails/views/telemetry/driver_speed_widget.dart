import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:frontend/presentation/raceDetails/cubit/race_details_cubit.dart';
import 'package:frontend/utils/race_utils.dart';
import 'package:frontend/core/theme/f1_theme.dart';
import 'package:frontend/widgets/f1_loading_indicator.dart';

class DriverSpeedWidget extends StatelessWidget {
  final RaceDetailsState state;
  final Map<String, String> drivers;
  final String season;

  const DriverSpeedWidget({
    super.key,
    required this.state,
    required this.drivers,
    required this.season,
  });

  @override
  Widget build(BuildContext context) {
    String formatToMmSsMs(num seconds) {
      final int minutes = seconds ~/ 60;
      final int secs = seconds.toInt() % 60;
      final int millis = ((seconds - seconds.floor()) * 1000).round();

      String twoDigits(int n) => n.toString().padLeft(2, '0');
      String threeDigits(int n) => n.toString().padLeft(3, '0');

      return '${twoDigits(minutes)}:${twoDigits(secs)}:${threeDigits(millis)}';
    }

    if (state.isLoadingDriverTelemetry) {
      return Center(
        child: F1LoadingIndicator(message: 'Loading speed trace...', size: 60),
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

    final hasDriver1 =
        state.driver1Telemetry != null && state.driver1Telemetry!.isNotEmpty;
    final hasDriver2 =
        state.driver2Telemetry != null && state.driver2Telemetry!.isNotEmpty;
    final hasDriver3 =
        state.driver3Telemetry != null && state.driver3Telemetry!.isNotEmpty;

    if (!hasDriver1 && !hasDriver2 && !hasDriver3) {
      return Center(
        child: Text(
          'No telemetry data available',
          style: F1Theme.themeData.textTheme.bodyLarge?.copyWith(
            color: F1Theme.f1TextGray,
          ),
        ),
      );
    }

    final List<LineChartBarData> lineBars = [];
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
    });

    if (hasDriver1) {
      final spots = state.driver1Telemetry!
          .asMap()
          .entries
          .where((e) => e.value.speed != null)
          .map(
            (e) => FlSpot(
              e.value.distance?.toDouble() ?? e.key.toDouble(),
              e.value.speed!.toDouble(),
            ),
          )
          .toList();

      if (spots.isNotEmpty) {
        spots.sort((a, b) => a.x.compareTo(b.x));
        lineBars.add(
          LineChartBarData(
            isCurved: true,
            curveSmoothness: 0.3,
            color: colors[0].withAlpha(200),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
            spots: spots,
          ),
        );
        driverNames.add(drivers.values.elementAt(0));
      }
    }

    if (hasDriver2) {
      final spots = state.driver2Telemetry!
          .asMap()
          .entries
          .where((e) => e.value.speed != null)
          .map(
            (e) => FlSpot(
              e.value.distance?.toDouble() ?? e.key.toDouble(),
              e.value.speed!.toDouble(),
            ),
          )
          .toList();

      if (spots.isNotEmpty) {
        spots.sort((a, b) => a.x.compareTo(b.x));
        lineBars.add(
          LineChartBarData(
            isCurved: true,
            curveSmoothness: 0.3,
            color: colors[1].withAlpha(200),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
            spots: spots,
          ),
        );
        driverNames.add(drivers.values.elementAt(1));
      }
    }

    if (hasDriver3) {
      final spots = state.driver3Telemetry!
          .asMap()
          .entries
          .where((e) => e.value.speed != null)
          .map(
            (e) => FlSpot(
              e.value.distance?.toDouble() ?? e.key.toDouble(),
              e.value.speed!.toDouble(),
            ),
          )
          .toList();

      if (spots.isNotEmpty) {
        spots.sort((a, b) => a.x.compareTo(b.x));
        lineBars.add(
          LineChartBarData(
            isCurved: true,
            curveSmoothness: 0.3,
            color: colors[2].withAlpha(200),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
            spots: spots,
          ),
        );
        driverNames.add(drivers.values.elementAt(2));
      }
    }

    if (lineBars.isEmpty) {
      return const Center(child: Text('No valid speed data'));
    }

    final allSpots = lineBars.expand((bar) => bar.spots).toList();
    final minY = allSpots.map((s) => s.y).reduce((a, b) => a < b ? a : b);
    final maxY = allSpots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    final minX = allSpots.map((s) => s.x).reduce((a, b) => a < b ? a : b);
    final maxX = allSpots.map((s) => s.x).reduce((a, b) => a > b ? a : b);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: F1Theme.mediumSpacing,
              vertical: F1Theme.smallSpacing,
            ),
            decoration: BoxDecoration(
              gradient: F1Theme.cardGradient,
              borderRadius: F1Theme.mediumBorderRadius,
              boxShadow: F1Theme.cardShadow,
            ),
            margin: EdgeInsets.all(F1Theme.smallSpacing),
            child: Wrap(
              spacing: F1Theme.mediumSpacing,
              runSpacing: F1Theme.smallSpacing,
              children: List.generate(lineBars.length, (index) {
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: F1Theme.smallSpacing,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: colors[index].withOpacity(0.1),
                    borderRadius: F1Theme.smallBorderRadius,
                    border: Border.all(color: colors[index], width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 20,
                        height: 3,
                        decoration: BoxDecoration(
                          color: colors[index],
                          borderRadius: F1Theme.smallBorderRadius,
                          boxShadow: [
                            BoxShadow(
                              color: colors[index].withOpacity(0.5),
                              blurRadius: 4,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: F1Theme.smallSpacing),
                      Text(
                        driverNames[index],
                        style: F1Theme.themeData.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colors[index],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
          Container(
            height: 300,
            padding: EdgeInsets.all(F1Theme.mediumSpacing),
            margin: EdgeInsets.symmetric(vertical: F1Theme.smallSpacing),
            decoration: BoxDecoration(
              gradient: F1Theme.cardGradient,
              borderRadius: F1Theme.mediumBorderRadius,
              boxShadow: F1Theme.cardShadow,
            ),
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  verticalInterval: 1000,
                  getDrawingVerticalLine: (value) {
                    return FlLine(
                      color: F1Theme.f1LightGray.withOpacity(0.3),
                      strokeWidth: 1,
                    );
                  },
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: F1Theme.f1LightGray.withOpacity(0.3),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    axisNameWidget: Text(
                      'Distance (m)',
                      style: F1Theme.themeData.textTheme.bodyMedium?.copyWith(
                        color: F1Theme.f1TextGray,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1000,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}',
                          style: F1Theme.themeData.textTheme.bodySmall
                              ?.copyWith(color: F1Theme.f1TextGray),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    axisNameWidget: Text(
                      'Speed (km/h)',
                      style: F1Theme.themeData.textTheme.bodyMedium?.copyWith(
                        color: F1Theme.f1TextGray,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 45,
                      interval: 20,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}',
                          style: F1Theme.themeData.textTheme.bodySmall
                              ?.copyWith(color: F1Theme.f1TextGray),
                        );
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: F1Theme.f1LightGray, width: 1),
                ),
                minX: minX,
                maxX: maxX,
                minY: minY - 10,
                maxY: maxY + 10,
                lineBarsData: lineBars,
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    tooltipRoundedRadius: 8,
                    getTooltipColor: (touchedSpot) => F1Theme.f1DarkGray,
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        final index = lineBars.indexWhere(
                          (bar) => bar.spots.contains(spot),
                        );
                        return LineTooltipItem(
                          '${driverNames[index]}\n',
                          F1Theme.themeData.textTheme.bodyLarge!.copyWith(
                            color: colors[index],
                            fontWeight: FontWeight.w600,
                          ),
                          children: [
                            TextSpan(
                              text: 'Speed: ${spot.y.toStringAsFixed(1)} km/h',
                              style: F1Theme.themeData.textTheme.bodySmall!
                                  .copyWith(color: F1Theme.f1White),
                            ),
                          ],
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: F1Theme.mediumSpacing),
          Text(
            "Fastest Lap Times",
            style: F1Theme.themeData.textTheme.displaySmall?.copyWith(
              color: F1Theme.f1Red,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: F1Theme.mediumSpacing),
          driverNames.isNotEmpty && state.sectorTimings!.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: driverNames.length,
                  itemBuilder: (context, index) {
                    if (index >= state.sectorTimings!.length)
                      return SizedBox.shrink();
                    final totalLapTime =
                        state.sectorTimings![index].sector1! +
                        state.sectorTimings![index].sector2! +
                        state.sectorTimings![index].sector3!;
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: F1Theme.smallSpacing / 2,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: colors[index],
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: colors[index].withOpacity(0.5),
                                  blurRadius: 4,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: F1Theme.smallSpacing),
                          Expanded(
                            child: Text(
                              driverNames[index],
                              style: F1Theme.themeData.textTheme.bodyLarge
                                  ?.copyWith(
                                    color: colors[index],
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                          Text(
                            formatToMmSsMs(totalLapTime),
                            style: F1Theme.themeData.textTheme.bodyLarge
                                ?.copyWith(
                                  color: F1Theme.f1White,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ],
                      ),
                    );
                  },
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
