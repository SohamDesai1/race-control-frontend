import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/presentation/raceDetails/cubit/race_details_cubit.dart';
import 'package:frontend/presentation/raceDetails/views/race_pace_widget.dart';
import 'package:frontend/utils/race_utils.dart';
import 'package:sizer/sizer.dart';
import 'package:frontend/core/theme/f1_theme.dart';
import 'package:frontend/core/widgets/f1_loading_indicator.dart';

class TelemetryScreen extends StatefulWidget {
  final String sessionKey;
  final Map<String, String> drivers;
  final String season;
  final String sessionType;
  const TelemetryScreen({
    super.key,
    required this.sessionKey,
    required this.drivers,
    required this.season,
    required this.sessionType,
  });

  @override
  State<TelemetryScreen> createState() => _TelemetryScreenState();
}

class _TelemetryScreenState extends State<TelemetryScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Load all data in parallel for better performance
      await Future.wait([
        context.read<RaceDetailsCubit>().loadDriverTelemetryData(
          widget.sessionKey,
          widget.drivers.keys.toList(),
        ),
        context.read<RaceDetailsCubit>().loadSectorTimingsData(
          widget.sessionKey,
        ),
        context.read<RaceDetailsCubit>().loadRacePaceComparisonData(
          widget.sessionKey,
          widget.drivers.keys.elementAt(0),
          widget.drivers.keys.elementAt(1),
        ),
      ]);
    });
  }

  String formatToMmSsMs(num seconds) {
    final int minutes = seconds ~/ 60;
    final int secs = seconds.toInt() % 60;
    final int millis = ((seconds - seconds.floor()) * 1000).round();

    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String threeDigits(int n) => n.toString().padLeft(3, '0');

    return '${twoDigits(minutes)}:${twoDigits(secs)}:${threeDigits(millis)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: F1Theme.f1Black,
        title: Text(
          "Telemetry Details",
          style: F1Theme.themeData.textTheme.displaySmall,
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<RaceDetailsCubit, RaceDetailsState>(
        builder: (context, state) {
          // Show loading indicator if any of the required data is loading
          if (state.isLoadingDriverTelemetry ||
              state.isLoadingSectorTimings ||
              state.isLoadingRacePaceComparison) {
            return SizedBox(
              height: 300,
              child: F1LoadingIndicator(
                message: 'Loading telemetry data...',
                size: 60,
              ),
            );
          }

          if (state.error != null) {
            return SizedBox(
              height: 300,
              child: Center(
                child: Text(
                  state.error!,
                  style: F1Theme.themeData.textTheme.bodyLarge?.copyWith(
                    color: F1Theme.themeData.colorScheme.error,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          // Check if at least one driver has data
          final hasDriver1 =
              state.driver1Telemetry != null &&
              state.driver1Telemetry!.isNotEmpty;
          final hasDriver2 =
              state.driver2Telemetry != null &&
              state.driver2Telemetry!.isNotEmpty;
          final hasDriver3 =
              state.driver3Telemetry != null &&
              state.driver3Telemetry!.isNotEmpty;
          final hasSectorTimings =
              state.sectorTimings != null && state.sectorTimings!.isNotEmpty;

          if (!hasDriver1 && !hasDriver2 && !hasDriver3 && !hasSectorTimings) {
            return SizedBox(
              height: 300,
              child: Center(
                child: Text(
                  'No telemetry data available',
                  style: F1Theme.themeData.textTheme.bodyLarge?.copyWith(
                    color: F1Theme.f1TextGray,
                  ),
                ),
              ),
            );
          }

          final List<LineChartBarData> lineBars = [];
          final List<String> driverNames = [];
          final List<Color> colors = [];
          final Set<Color> usedColors = {};

          widget.drivers.forEach((key, value) {
            Color baseColor = RaceUtils.getF1TeamColor(value).withAlpha(200);
            if (usedColors.contains(baseColor)) {
              baseColor = Colors.grey;
            }

            usedColors.add(baseColor);
            colors.add(baseColor);
          });

          // Driver 1
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
              driverNames.add(
                widget.drivers.values.elementAt(0),
              ); // Replace with actual driver name
            }
          }

          // Driver 2
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
              driverNames.add(
                widget.drivers.values.elementAt(1),
              ); // Replace with actual driver name
            }
          }

          // Driver 3
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
              driverNames.add(
                widget.drivers.values.elementAt(2),
              ); // Replace with actual driver name
            }
          }

          if (lineBars.isEmpty) {
            return const SizedBox(
              height: 300,
              child: Center(child: Text('No valid speed data')),
            );
          }

          // Calculate min/max
          final allSpots = lineBars.expand((bar) => bar.spots).toList();
          final minY = allSpots.map((s) => s.y).reduce((a, b) => a < b ? a : b);
          final maxY = allSpots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
          final minX = allSpots.map((s) => s.x).reduce((a, b) => a < b ? a : b);
          final maxX = allSpots.map((s) => s.x).reduce((a, b) => a > b ? a : b);

          final barChartdata =
              state.sectorTimings
                  ?.where(
                    (st) => widget.drivers.keys.contains(
                      st.driverNumber.toString(),
                    ),
                  )
                  .map(
                    (st) => {
                      'driver_number': st.driverNumber,
                      'sector_1': st.sector1,
                      'sector_2': st.sector2,
                      'sector_3': st.sector3,
                      'fastest_lap': st.sector1! + st.sector2! + st.sector3!,
                    },
                  )
                  .toList() ??
              [];

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Enhanced Legend with team colors
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
                              style: F1Theme.themeData.textTheme.bodyLarge
                                  ?.copyWith(
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

                // Enhanced Chart with F1 styling
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
                            style: F1Theme.themeData.textTheme.bodyMedium
                                ?.copyWith(
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
                            style: F1Theme.themeData.textTheme.bodyMedium
                                ?.copyWith(
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
                        border: Border.all(
                          color: F1Theme.f1LightGray,
                          width: 1,
                        ),
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
                                    text:
                                        'Speed: ${spot.y.toStringAsFixed(1)} km/h',
                                    style: F1Theme
                                        .themeData
                                        .textTheme
                                        .bodySmall!
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
                Container(
                  height: 300,
                  padding: EdgeInsets.all(F1Theme.mediumSpacing),
                  margin: EdgeInsets.symmetric(vertical: F1Theme.smallSpacing),
                  decoration: BoxDecoration(
                    gradient: F1Theme.cardGradient,
                    borderRadius: F1Theme.mediumBorderRadius,
                    boxShadow: F1Theme.cardShadow,
                  ),
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: _getMaxSectorTime(barChartdata) * 1.15,
                      minY: 0,
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          tooltipRoundedRadius: 8,
                          getTooltipColor: (group) => F1Theme.f1DarkGray,
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            final driver = barChartdata[rodIndex];
                            final sectors = [
                              'Sector 1',
                              'Sector 2',
                              'Sector 3',
                            ];
                            return BarTooltipItem(
                              'Driver no ${driver['driver_number']}\n',
                              F1Theme.themeData.textTheme.bodyLarge!.copyWith(
                                color: F1Theme.f1White,
                                fontWeight: FontWeight.bold,
                              ),
                              children: [
                                TextSpan(
                                  text:
                                      '${sectors[groupIndex]}: ${rod.toY.toStringAsFixed(3)}s',
                                  style: F1Theme.themeData.textTheme.bodySmall!
                                      .copyWith(
                                        color: F1Theme.f1White,
                                        fontWeight: FontWeight.normal,
                                      ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final sectors = [
                                'Sector 1',
                                'Sector 2',
                                'Sector 3',
                              ];
                              if (value.toInt() >= 0 &&
                                  value.toInt() < sectors.length) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                    top: F1Theme.smallSpacing,
                                  ),
                                  child: Text(
                                    sectors[value.toInt()],
                                    style: F1Theme
                                        .themeData
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: F1Theme.f1White,
                                        ),
                                  ),
                                );
                              }
                              return const Text('');
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                '${value.toStringAsFixed(0)}s',
                                style: F1Theme.themeData.textTheme.bodySmall
                                    ?.copyWith(
                                      fontSize: 10,
                                      color: F1Theme.f1TextGray,
                                    ),
                              );
                            },
                          ),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 5,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: F1Theme.f1LightGray.withOpacity(0.2),
                            strokeWidth: 1,
                          );
                        },
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border(
                          bottom: BorderSide(color: F1Theme.f1LightGray),
                          left: BorderSide(color: F1Theme.f1LightGray),
                        ),
                      ),
                      barGroups: _buildBarGroups(barChartdata),
                    ),
                  ),
                ),
                SizedBox(height: F1Theme.mediumSpacing),
                state.sectorTimings == null
                    ? SizedBox.shrink()
                    : Container(
                        padding: EdgeInsets.all(F1Theme.mediumSpacing),
                        margin: EdgeInsets.symmetric(
                          horizontal: F1Theme.smallSpacing,
                        ),
                        decoration: BoxDecoration(
                          gradient: F1Theme.cardGradient,
                          borderRadius: F1Theme.mediumBorderRadius,
                          boxShadow: F1Theme.cardShadow,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Fastest Lap Times",
                              style: F1Theme.themeData.textTheme.displaySmall
                                  ?.copyWith(
                                    color: F1Theme.f1Red,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            SizedBox(height: F1Theme.smallSpacing),
                            driverNames.isNotEmpty &&
                                    state.sectorTimings!.isNotEmpty
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
                                                    color: colors[index]
                                                        .withOpacity(0.5),
                                                    blurRadius: 4,
                                                    offset: Offset(0, 1),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: F1Theme.smallSpacing,
                                            ),
                                            Expanded(
                                              child: Text(
                                                driverNames[index],
                                                style: F1Theme
                                                    .themeData
                                                    .textTheme
                                                    .bodyLarge
                                                    ?.copyWith(
                                                      color: colors[index],
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                              ),
                                            ),
                                            Text(
                                              formatToMmSsMs(totalLapTime),
                                              style: F1Theme
                                                  .themeData
                                                  .textTheme
                                                  .bodyLarge
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
                            SizedBox(height: F1Theme.mediumSpacing),
                            widget.sessionType == "Race"
                                ? Column(
                                    children: [
                                      Divider(
                                        color: F1Theme.f1LightGray,
                                        height: 1,
                                      ),
                                      SizedBox(height: F1Theme.mediumSpacing),
                                      Text(
                                        "Race Pace Comparison",
                                        style: F1Theme
                                            .themeData
                                            .textTheme
                                            .headlineMedium
                                            ?.copyWith(
                                              color: F1Theme.f1White,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                      SizedBox(height: F1Theme.smallSpacing),
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
              ],
            ),
          );
        },
      ),
    );
  }

  final Map<int, Color> _driverColorCache = {};

  Color _getDriverColorForSector(
    int driverNumber,
    Set<Color> usedColorsInSector,
  ) {
    final baseColor = _driverColorCache.putIfAbsent(driverNumber, () {
      return RaceUtils.getF1TeamColor(
        RaceUtils.mapDriverNameFromDriverNumber(
          driverNumber,
          int.parse(widget.season),
        ),
      ).withOpacity(0.85);
    });

    if (usedColorsInSector.contains(baseColor)) {
      return Colors.white;
    }

    usedColorsInSector.add(baseColor);
    return baseColor;
  }

  double _getMaxSectorTime(List<Map<String, dynamic>> barChartData) {
    double max = 0;
    for (var driver in barChartData) {
      final s1 = (driver['sector_1'] as num).toDouble();
      final s2 = (driver['sector_2'] as num).toDouble();
      final s3 = (driver['sector_3'] as num).toDouble();
      if (s1 > max) max = s1;
      if (s2 > max) max = s2;
      if (s3 > max) max = s3;
    }
    return max;
  }

  List<BarChartGroupData> _buildBarGroups(
    List<Map<String, dynamic>> barChartData,
  ) {
    return List.generate(3, (sectorIndex) {
      final sectorKeys = ['sector_1', 'sector_2', 'sector_3'];
      final sectorKey = sectorKeys[sectorIndex];
      final Set<Color> usedColorsInSector = {};

      return BarChartGroupData(
        x: sectorIndex,
        barsSpace: 4,
        barRods: barChartData.map((driver) {
          final int driverNumber = driver['driver_number'] as int;
          final color = _getDriverColorForSector(
            driverNumber,
            usedColorsInSector,
          );
          return BarChartRodData(
            toY: (driver[sectorKey] as num).toDouble(),
            color: color,
            width: 20,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          );
        }).toList(),
      );
    });
  }
}
