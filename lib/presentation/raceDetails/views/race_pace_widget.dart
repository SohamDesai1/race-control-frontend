import 'package:flutter/material.dart';
import 'package:frontend/core/theme/f1_theme.dart';

class PacePoint {
  double? x;
  double? y;
  int? minisector;
  int? fastestDriver;

  PacePoint({this.x, this.y, this.minisector, this.fastestDriver});

  factory PacePoint.fromJson(Map<String, dynamic> json) {
    return PacePoint(
      x: json['x'].toDouble(),
      y: json['y'].toDouble(),
      minisector: json['minisector'],
      fastestDriver: json['fastest_driver'],
    );
  }
}

class TrackPainter extends CustomPainter {
  final List<PacePoint> points;
  final Color color1;
  final Color color2;
  final String driver1;
  final String driver2;

  TrackPainter(
    this.points,
    this.color1,
    this.color2,
    this.driver1,
    this.driver2,
  );

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    final minX = points.map((p) => p.x).reduce((a, b) => a! < b! ? a : b);
    final maxX = points.map((p) => p.x).reduce((a, b) => a! > b! ? a : b);
    final minY = points.map((p) => p.y).reduce((a, b) => a! < b! ? a : b);
    final maxY = points.map((p) => p.y).reduce((a, b) => a! > b! ? a : b);

    double scaleX = size.width / (maxX! - minX!);
    double scaleY = size.height / (maxY! - minY!);
    double scale = scaleX < scaleY ? scaleX : scaleY;

    Offset normalize(PacePoint p) {
      final normalizedX = (p.x! - minX) * scale;
      final normalizedY = (p.y! - minY) * scale;

      // Calculate offsets to center the track
      final totalWidth = (maxX - minX) * scale;
      final totalHeight = (maxY - minY) * scale;

      final offsetX = (size.width - totalWidth) / 2;
      final offsetY = (size.height - totalHeight) / 2;

      return Offset(normalizedX + offsetX, size.height - normalizedY + offsetY);
    }

    // Draw the pace comparison lines with enhanced styling
    for (int i = 0; i < points.length - 1; i++) {
      final p1 = normalize(points[i]);
      final p2 = normalize(points[i + 1]);

      final paint = Paint()
        ..color = points[i + 1].fastestDriver == 1
            ? color1.withOpacity(0.8) // Driver 1
            : color2.withOpacity(0.8) // Driver 2
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      // Add glow effect
      final glowPaint = Paint()
        ..color = points[i + 1].fastestDriver == 1
            ? color1.withOpacity(0.3)
            : color2.withOpacity(0.3)
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4);

      canvas.drawLine(p1, p2, glowPaint);
      canvas.drawLine(p1, p2, paint);
    }

    // Draw legend
    final legendStyle = TextStyle(
      color: F1Theme.f1White,
      fontSize: 12,
      fontFamily: 'Formula1Regular',
    );

    final legendText1 = TextPainter(
      text: TextSpan(
        text: driver1,
        style: legendStyle.copyWith(color: color1),
      ),
      textDirection: TextDirection.ltr,
    );
    legendText1.layout();
    legendText1.paint(canvas, Offset(10, 10));

    final legendText2 = TextPainter(
      text: TextSpan(
        text: driver2,
        style: legendStyle.copyWith(color: color2),
      ),
      textDirection: TextDirection.ltr,
    );
    legendText2.layout();
    legendText2.paint(canvas, Offset(10, 30));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class PaceComparisonView extends StatelessWidget {
  final List<PacePoint> data;
  final Color color1;
  final Color color2;
  final String driver1;
  final String driver2;
  const PaceComparisonView({
    super.key,
    required this.data,
    required this.color1,
    required this.color2,
    required this.driver1,
    required this.driver2,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: CustomPaint(
        painter: TrackPainter(data, color1, color2, driver1, driver2),
        child: Container(),
      ),
    );
  }
}

class RacePaceScreen extends StatefulWidget {
  final List<PacePoint> dataPoints;
  final List<Color> colors;
  final String driver1;
  final String driver2;
  const RacePaceScreen({
    super.key,
    required this.dataPoints,
    required this.colors,
    required this.driver1,
    required this.driver2,
  });

  @override
  State<RacePaceScreen> createState() => _RacePaceScreenState();
}

class _RacePaceScreenState extends State<RacePaceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: PaceComparisonView(
          data: widget.dataPoints,
          color1: widget.colors.first,
          color2: widget.colors[1],
          driver1: widget.driver1,
          driver2: widget.driver2,
        ),
      ),
    );
  }
}
