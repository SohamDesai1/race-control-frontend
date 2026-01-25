import 'package:flutter/material.dart';
import 'package:frontend/core/theme/f1_theme.dart';

class F1LoadingIndicator extends StatelessWidget {
  final String? message;
  final double size;

  const F1LoadingIndicator({super.key, this.message, this.size = 50});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: Stack(
              children: [
                // Outer circle - F1 Red
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        F1Theme.f1Red.withOpacity(0.2),
                        F1Theme.f1DarkRed.withOpacity(0.1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
                // Inner rotating circle
                Center(
                  child: SizedBox(
                    width: size * 0.8,
                    height: size * 0.8,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(F1Theme.f1Red),
                      backgroundColor: F1Theme.f1DarkGray,
                    ),
                  ),
                ),
                // F1 Logo placeholder
                Center(
                  child: Icon(
                    Icons.directions_car_filled,
                    color: F1Theme.f1Red,
                    size: size * 0.4,
                  ),
                ),
              ],
            ),
          ),
          if (message != null) ...[
            SizedBox(height: F1Theme.mediumSpacing),
            Text(
              message!,
              style: F1Theme.themeData.textTheme.bodyLarge?.copyWith(
                color: F1Theme.f1TextGray,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class F1ShimmerLoading extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const F1ShimmerLoading({
    super.key,
    this.width = double.infinity,
    this.height = 200,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            F1Theme.f1DarkGray,
            F1Theme.f1MediumGray,
            F1Theme.f1DarkGray,
          ],
          stops: [0.1, 0.5, 0.9],
          begin: Alignment(-1.0, -0.5),
          end: Alignment(1.0, 0.5),
        ),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
