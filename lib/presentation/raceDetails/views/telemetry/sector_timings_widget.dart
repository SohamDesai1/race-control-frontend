import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:frontend/presentation/raceDetails/cubit/race_details_cubit.dart';
import 'package:frontend/utils/race_utils.dart';
import 'package:frontend/core/theme/f1_theme.dart';
import 'package:frontend/widgets/f1_loading_indicator.dart';

class SectorTimingsWidget extends StatelessWidget {
  final RaceDetailsState state;
  final Map<String, String> drivers;
  final String season;

  SectorTimingsWidget({
    super.key,
    required this.state,
    required this.drivers,
    required this.season,
  });

  final Map<int, Color> _driverColorCache = {};

  Color _getDriverColorForSector(
    int driverNumber,
    Set<Color> usedColorsInSector,
  ) {
    final baseColor = _driverColorCache.putIfAbsent(driverNumber, () {
      return RaceUtils.getF1TeamColor(
        RaceUtils.mapDriverNameFromDriverNumber(
          driverNumber,
          int.parse(season),
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

  @override
  Widget build(BuildContext context) {
    if (state.isLoadingSectorTimings) {
      return Center(
        child: F1LoadingIndicator(message: 'Loading sector times...', size: 60),
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

    final barChartdata =
        state.sectorTimings
            ?.where((st) => drivers.keys.contains(st.driverNumber.toString()))
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

    if (barChartdata.isEmpty) {
      return Center(
        child: Text(
          'No sector times available',
          style: F1Theme.themeData.textTheme.bodyLarge?.copyWith(
            color: F1Theme.f1TextGray,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Container(
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
                  final sectors = ['Sector 1', 'Sector 2', 'Sector 3'];
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
                        style: F1Theme.themeData.textTheme.bodySmall!.copyWith(
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
                    final sectors = ['Sector 1', 'Sector 2', 'Sector 3'];
                    if (value.toInt() >= 0 && value.toInt() < sectors.length) {
                      return Padding(
                        padding: EdgeInsets.only(top: F1Theme.smallSpacing),
                        child: Text(
                          sectors[value.toInt()],
                          style: F1Theme.themeData.textTheme.bodyMedium
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
                      style: F1Theme.themeData.textTheme.bodySmall?.copyWith(
                        fontSize: 10,
                        color: F1Theme.f1TextGray,
                      ),
                    );
                  },
                ),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
    );
  }
}
