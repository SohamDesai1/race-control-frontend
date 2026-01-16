import 'package:flutter/material.dart';

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

  TrackPainter(this.points, this.color1, this.color2);

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
      return Offset((p.x! - minX) * scale, size.height - (p.y! - minY) * scale);
    }

    for (int i = 0; i < points.length - 1; i++) {
      final p1 = normalize(points[i]);
      final p2 = normalize(points[i + 1]);

      final paint = Paint()
        ..color = points[i + 1].fastestDriver == 1
            ? color1 // Driver 1 = Blue
            : color2 // Driver 2 = Red
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(p1, p2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class PaceComparisonView extends StatelessWidget {
  final List<PacePoint> data;
  final Color color1;
  final Color color2;
  const PaceComparisonView({
    super.key,
    required this.data,
    required this.color1,
    required this.color2,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: CustomPaint(
        painter: TrackPainter(data, color1, color2),
        child: Container(),
      ),
    );
  }
}

class RacePaceScreen extends StatefulWidget {
  final List<PacePoint> dataPoints;
  final List<Color> colors;
  const RacePaceScreen({
    super.key,
    required this.dataPoints,
    required this.colors,
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
        ),
      ),
    );
  }
}
