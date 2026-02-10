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

    final telemetryData = _prepareTelemetryData();

    if (telemetryData.lineBarsSpeed.isEmpty) {
      return const Center(child: Text('No valid speed data'));
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TelemetryDescription(
            description:
                'Analyze driver performance across the lap with detailed telemetry data. Compare speed, throttle application, and gear selection to understand driving techniques and identify performance differences.',
          ),
          _DriverLegend(
            driverNames: telemetryData.driverNames,
            colors: telemetryData.colors,
          ),
          _ChartSection(
            title: 'Speed Trace',
            child: _SpeedChart(telemetryData: telemetryData),
          ),
          _ChartSection(
            title: 'Throttle Application',
            child: _ThrottleChart(telemetryData: telemetryData),
          ),
          _ChartSection(
            title: 'Gear Selection',
            child: _GearChart(telemetryData: telemetryData),
          ),
          SizedBox(height: F1Theme.mediumSpacing),
        ],
      ),
    );
  }

  _TelemetryData _prepareTelemetryData() {
    final List<LineChartBarData> lineBarsSpeed = [];
    final List<LineChartBarData> lineBarsThrottle = [];
    final List<LineChartBarData> lineBarsGear = [];
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

    _addDriverTelemetry(
      state.driver1Telemetry,
      0,
      colors,
      lineBarsSpeed,
      lineBarsThrottle,
      lineBarsGear,
      driverNames,
    );

    _addDriverTelemetry(
      state.driver2Telemetry,
      1,
      colors,
      lineBarsSpeed,
      lineBarsThrottle,
      lineBarsGear,
      driverNames,
    );

    _addDriverTelemetry(
      state.driver3Telemetry,
      2,
      colors,
      lineBarsSpeed,
      lineBarsThrottle,
      lineBarsGear,
      driverNames,
    );

    return _TelemetryData(
      lineBarsSpeed: lineBarsSpeed,
      lineBarsThrottle: lineBarsThrottle,
      lineBarsGear: lineBarsGear,
      driverNames: driverNames,
      colors: colors,
    );
  }

  void _addDriverTelemetry(
    List<dynamic>? telemetry,
    int driverIndex,
    List<Color> colors,
    List<LineChartBarData> lineBarsSpeed,
    List<LineChartBarData> lineBarsThrottle,
    List<LineChartBarData> lineBarsGear,
    List<String> driverNames,
  ) {
    if (telemetry == null || telemetry.isEmpty) return;
    if (driverIndex >= colors.length || driverIndex >= drivers.length) return;

    final spotsSpeed = telemetry
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

    final spotsThrottle = telemetry
        .asMap()
        .entries
        .where((e) => e.value.speed != null)
        .map(
          (e) => FlSpot(
            e.value.distance?.toDouble() ?? e.key.toDouble(),
            e.value.throttle!.toDouble(),
          ),
        )
        .toList();

    final spotsGear = telemetry
        .asMap()
        .entries
        .where((e) => e.value.speed != null)
        .map(
          (e) => FlSpot(
            e.value.distance?.toDouble() ?? e.key.toDouble(),
            e.value.gear!.toDouble(),
          ),
        )
        .toList();

    if (spotsSpeed.isEmpty || spotsThrottle.isEmpty || spotsGear.isEmpty) {
      return;
    }

    spotsSpeed.sort((a, b) => a.x.compareTo(b.x));
    spotsThrottle.sort((a, b) => a.x.compareTo(b.x));
    spotsGear.sort((a, b) => a.x.compareTo(b.x));

    final lineBarConfig = LineChartBarData(
      isCurved: true,
      curveSmoothness: 0.3,
      color: colors[driverIndex].withAlpha(200),
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
      spots: [],
    );

    lineBarsSpeed.add(lineBarConfig.copyWith(spots: spotsSpeed));
    lineBarsThrottle.add(lineBarConfig.copyWith(spots: spotsThrottle));
    lineBarsGear.add(lineBarConfig.copyWith(spots: spotsGear));

    driverNames.add(drivers.values.elementAt(driverIndex));
  }
}

class _TelemetryData {
  final List<LineChartBarData> lineBarsSpeed;
  final List<LineChartBarData> lineBarsThrottle;
  final List<LineChartBarData> lineBarsGear;
  final List<String> driverNames;
  final List<Color> colors;

  _TelemetryData({
    required this.lineBarsSpeed,
    required this.lineBarsThrottle,
    required this.lineBarsGear,
    required this.driverNames,
    required this.colors,
  });
}

class _TelemetryDescription extends StatelessWidget {
  final String description;

  const _TelemetryDescription({required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(F1Theme.mediumSpacing),
      margin: EdgeInsets.all(F1Theme.smallSpacing),
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

class _DriverLegend extends StatelessWidget {
  final List<String> driverNames;
  final List<Color> colors;

  const _DriverLegend({required this.driverNames, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: F1Theme.mediumSpacing,
        vertical: F1Theme.smallSpacing,
      ),
      margin: EdgeInsets.all(F1Theme.smallSpacing),
      child: Wrap(
        spacing: F1Theme.mediumSpacing,
        runSpacing: F1Theme.smallSpacing,
        children: List.generate(driverNames.length, (index) {
          return Container(
            padding: EdgeInsets.symmetric(
              horizontal: F1Theme.smallSpacing,
              vertical: 4,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 15,
                  height: 15,
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
    );
  }
}

class _ChartSection extends StatelessWidget {
  final String title;
  final String? description;
  final Widget child;

  const _ChartSection({
    required this.title,
    this.description = '',
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: F1Theme.mediumSpacing,
            vertical: F1Theme.smallSpacing,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: F1Theme.themeData.textTheme.headlineSmall?.copyWith(
                  color: F1Theme.f1White,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 4),
              Text(
                description ?? '',
                style: F1Theme.themeData.textTheme.bodySmall?.copyWith(
                  color: F1Theme.f1TextGray,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
        child,
      ],
    );
  }
}

class _SpeedChart extends StatelessWidget {
  final _TelemetryData telemetryData;

  const _SpeedChart({required this.telemetryData});

  @override
  Widget build(BuildContext context) {
    final allSpots = telemetryData.lineBarsSpeed
        .expand((bar) => bar.spots)
        .toList();
    final minY = allSpots.map((s) => s.y).reduce((a, b) => a < b ? a : b);
    final maxY = allSpots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    final minX = allSpots.map((s) => s.x).reduce((a, b) => a < b ? a : b);
    final maxX = allSpots.map((s) => s.x).reduce((a, b) => a > b ? a : b);

    return Container(
      height: 300,
      padding: EdgeInsets.all(F1Theme.mediumSpacing),
      margin: EdgeInsets.symmetric(
        horizontal: F1Theme.smallSpacing,
        vertical: F1Theme.smallSpacing,
      ),
      decoration: BoxDecoration(
        gradient: F1Theme.cardGradient,
        borderRadius: F1Theme.mediumBorderRadius,
        boxShadow: F1Theme.cardShadow,
      ),
      child: LineChart(
        LineChartData(
          gridData: _buildGridData(),
          titlesData: _buildTitlesData('Distance (m)', 'Speed (km/h)'),
          borderData: _buildBorderData(),
          minX: minX,
          maxX: maxX,
          minY: minY - 10,
          maxY: maxY + 10,
          lineBarsData: telemetryData.lineBarsSpeed,
          lineTouchData: _buildTouchData(
            telemetryData.lineBarsSpeed,
            telemetryData.driverNames,
            telemetryData.colors,
            (value) => 'Speed: ${value.toStringAsFixed(1)} km/h',
          ),
        ),
      ),
    );
  }
}

class _ThrottleChart extends StatelessWidget {
  final _TelemetryData telemetryData;

  const _ThrottleChart({required this.telemetryData});

  @override
  Widget build(BuildContext context) {
    final allSpots = telemetryData.lineBarsThrottle
        .expand((bar) => bar.spots)
        .toList();
    final minY = allSpots.map((s) => s.y).reduce((a, b) => a < b ? a : b);
    final maxY = allSpots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    final minX = allSpots.map((s) => s.x).reduce((a, b) => a < b ? a : b);
    final maxX = allSpots.map((s) => s.x).reduce((a, b) => a > b ? a : b);

    return Container(
      height: 200,
      padding: EdgeInsets.all(F1Theme.mediumSpacing),
      margin: EdgeInsets.symmetric(
        horizontal: F1Theme.smallSpacing,
        vertical: F1Theme.smallSpacing,
      ),
      decoration: BoxDecoration(
        gradient: F1Theme.cardGradient,
        borderRadius: F1Theme.mediumBorderRadius,
        boxShadow: F1Theme.cardShadow,
      ),
      child: LineChart(
        LineChartData(
          gridData: _buildGridData(),
          titlesData: _buildTitlesData('Distance (m)', 'Throttle (%)'),
          borderData: _buildBorderData(),
          minX: minX,
          maxX: maxX,
          minY: minY - 10,
          maxY: maxY + 10,
          lineBarsData: telemetryData.lineBarsThrottle,
          lineTouchData: _buildTouchData(
            telemetryData.lineBarsThrottle,
            telemetryData.driverNames,
            telemetryData.colors,
            (value) => 'Throttle: ${value.toStringAsFixed(1)} %',
          ),
        ),
      ),
    );
  }
}

class _GearChart extends StatelessWidget {
  final _TelemetryData telemetryData;

  const _GearChart({required this.telemetryData});

  @override
  Widget build(BuildContext context) {
    final allSpots = telemetryData.lineBarsGear
        .expand((bar) => bar.spots)
        .toList();
    final minY = allSpots.map((s) => s.y).reduce((a, b) => a < b ? a : b);
    final maxY = allSpots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    final minX = allSpots.map((s) => s.x).reduce((a, b) => a < b ? a : b);
    final maxX = allSpots.map((s) => s.x).reduce((a, b) => a > b ? a : b);

    return Container(
      height: 200,
      padding: EdgeInsets.all(F1Theme.mediumSpacing),
      margin: EdgeInsets.symmetric(
        horizontal: F1Theme.smallSpacing,
        vertical: F1Theme.smallSpacing,
      ),
      decoration: BoxDecoration(
        gradient: F1Theme.cardGradient,
        borderRadius: F1Theme.mediumBorderRadius,
        boxShadow: F1Theme.cardShadow,
      ),
      child: LineChart(
        LineChartData(
          gridData: _buildGridData(),
          titlesData: _buildTitlesData('Distance (m)', 'Gear'),
          borderData: _buildBorderData(),
          minX: minX,
          maxX: maxX,
          minY: minY - 1,
          maxY: maxY + 1,
          lineBarsData: telemetryData.lineBarsGear,
          lineTouchData: _buildTouchData(
            telemetryData.lineBarsGear,
            telemetryData.driverNames,
            telemetryData.colors,
            (value) => 'Gear: ${value.toStringAsFixed(1)}',
          ),
        ),
      ),
    );
  }
}

FlGridData _buildGridData() {
  return FlGridData(
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
  );
}

FlTitlesData _buildTitlesData(String xAxisLabel, String yAxisLabel) {
  return FlTitlesData(
    bottomTitles: AxisTitles(
      axisNameWidget: Text(
        xAxisLabel,
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
            style: F1Theme.themeData.textTheme.bodySmall?.copyWith(
              color: F1Theme.f1TextGray,
            ),
          );
        },
      ),
    ),
    leftTitles: AxisTitles(
      axisNameWidget: Text(
        yAxisLabel,
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
            style: F1Theme.themeData.textTheme.bodySmall?.copyWith(
              color: F1Theme.f1TextGray,
            ),
          );
        },
      ),
    ),
    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
  );
}

FlBorderData _buildBorderData() {
  return FlBorderData(
    show: true,
    border: Border.all(color: F1Theme.f1LightGray, width: 1),
  );
}

LineTouchData _buildTouchData(
  List<LineChartBarData> lineBars,
  List<String> driverNames,
  List<Color> colors,
  String Function(double) formatValue,
) {
  return LineTouchData(
    enabled: true,
    touchTooltipData: LineTouchTooltipData(
      tooltipRoundedRadius: 8,
      getTooltipColor: (touchedSpot) => F1Theme.f1DarkGray,
      getTooltipItems: (touchedSpots) {
        return touchedSpots.map((spot) {
          final index = lineBars.indexWhere((bar) => bar.spots.contains(spot));
          return LineTooltipItem(
            '${driverNames[index]}\n',
            F1Theme.themeData.textTheme.bodyLarge!.copyWith(
              color: colors[index],
              fontWeight: FontWeight.w600,
            ),
            children: [
              TextSpan(
                text: formatValue(spot.y),
                style: F1Theme.themeData.textTheme.bodySmall!.copyWith(
                  color: F1Theme.f1White,
                ),
              ),
            ],
          );
        }).toList();
      },
    ),
  );
}
