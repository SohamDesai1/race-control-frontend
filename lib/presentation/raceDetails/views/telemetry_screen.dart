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
    context.read<RaceDetailsCubit>().loadDriverTelemetryData(
      widget.sessionKey,
      widget.drivers.keys.toList(),
    );
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

          if (!hasDriver1 && !hasDriver2 && !hasDriver3) {
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
              int alpha = 200;
              while (usedColors.any(
                    (c) => c.value == baseColor.withAlpha(alpha).value,
                  ) &&
                  alpha > 70) {
                alpha -= 70;
              }
              baseColor = baseColor.withAlpha(alpha);
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

          return Column(
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
                        Container(width: 20, height: 3, color: colors[index]),
                        const SizedBox(width: 4),
                        Text(
                          driverNames[index],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
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
                      gridData: FlGridData(show: true, drawVerticalLine: true),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          axisNameWidget: const Text(
                            'Distance (m)',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
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
                            style: TextStyle(color: Colors.grey, fontSize: 12),
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
            ],
          );
        },
      ),
    );
  }
}
