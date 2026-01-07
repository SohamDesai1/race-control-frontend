import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/presentation/raceDetails/cubit/race_details_cubit.dart';
import 'package:frontend/utils/race_utils.dart';
import 'package:sizer/sizer.dart';

class TelemetryScreen extends StatefulWidget {
  final String sessionKey;
  final Map<String, String> drivers;
  const TelemetryScreen({
    super.key,
    required this.sessionKey,
    required this.drivers,
  });

  @override
  State<TelemetryScreen> createState() => _TelemetryScreenState();
}

class _TelemetryScreenState extends State<TelemetryScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<RaceDetailsCubit>().loadDriverTelemetryData(
        widget.sessionKey,
        widget.drivers.keys.toList(),
      );
      await Future.delayed(Duration(seconds: 1));
      await context.read<RaceDetailsCubit>().loadSectorTimingsData(
        widget.sessionKey,
      );
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
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          "Telemetry Details",
          style: TextStyle(fontFamily: "Formula1Bold", color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<RaceDetailsCubit, RaceDetailsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const SizedBox(
              height: 300,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if (state.error != null) {
            return SizedBox(
              height: 300,
              child: Center(
                child: Text(
                  state.error!,
                  style: const TextStyle(color: Colors.red),
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
            return const SizedBox(
              height: 300,
              child: Center(
                child: Text(
                  'No telemetry data available',
                  style: TextStyle(color: Colors.grey),
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
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Legend
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    spacing: 16,
                    children: List.generate(lineBars.length, (index) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(width: 25, height: 3, color: colors[index]),
                          const SizedBox(width: 4),
                          Text(
                            driverNames[index],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),

                // Chart
                SizedBox(
                  height: 300,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: true,
                        ),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            axisNameWidget: const Text(
                              'Distance (m)',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              interval: 1000,
                            ),
                          ),
                          leftTitles: AxisTitles(
                            axisNameWidget: const Text(
                              'Speed (km/h)',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 45,
                            ),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        borderData: FlBorderData(
                          show: true,
                          border: Border.all(color: Colors.grey.shade800),
                        ),
                        minX: minX,
                        maxX: maxX,
                        minY: minY - 10,
                        maxY: maxY + 10,
                        lineBarsData: lineBars,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
                SizedBox(
                  height: 300,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: _getMaxSectorTime(barChartdata) * 1.15,
                      minY: 0,
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            final driver = barChartdata[rodIndex];
                            final sectors = [
                              'Sector 1',
                              'Sector 2',
                              'Sector 3',
                            ];
                            return BarTooltipItem(
                              'Driver no ${driver['driver_number']}\n',
                              const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              children: [
                                TextSpan(
                                  text:
                                      '${sectors[groupIndex]}: ${rod.toY.toStringAsFixed(3)}s',
                                  style: const TextStyle(
                                    color: Colors.white,
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
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    sectors[value.toInt()],
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
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
                                style: const TextStyle(fontSize: 10),
                              );
                            },
                          ),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 5,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: Colors.grey.withOpacity(0.2),
                            strokeWidth: 1,
                          );
                        },
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade300),
                          left: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      barGroups: _buildBarGroups(barChartdata),
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
                state.sectorTimings == null
                    ? SizedBox.shrink()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "The fastest lap for ${driverNames[0]} was ${formatToMmSsMs(state.sectorTimings![0].sector1! + state.sectorTimings![0].sector2! + state.sectorTimings![0].sector3!)}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),

                          SizedBox(height: 2.h),
                          Text(
                            "The fastest lap for ${driverNames[1]} was ${formatToMmSsMs(state.sectorTimings![1].sector1! + state.sectorTimings![1].sector2! + state.sectorTimings![1].sector3!)}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            "The fastest lap for ${driverNames[2]} was ${formatToMmSsMs(state.sectorTimings![2].sector1! + state.sectorTimings![2].sector2! + state.sectorTimings![2].sector3!)}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          );
        },
      ),
    );
  }

  Color _getDriverColor(int driverNumber) {
    // You can use your existing RaceUtils to get team colors
    return RaceUtils.getF1TeamColor(
      RaceUtils.mapDriverNameFromDriverNumber(driverNumber, 2025),
    ).withOpacity(0.8);
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

      return BarChartGroupData(
        x: sectorIndex,
        barsSpace: 4,
        barRods: barChartData.map((driver) {
          return BarChartRodData(
            toY: (driver[sectorKey] as num).toDouble(),
            color: _getDriverColor(driver['driver_number']),
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
