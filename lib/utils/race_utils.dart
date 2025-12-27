import 'package:flutter/material.dart';

class RaceUtils {
  static Color getF1TeamColor(String constructorName) {
    switch (constructorName) {
      case 'Red Bull':
        return const Color(0xFF1E41FF);

      case 'Ferrari':
        return const Color(0xFFDC0000);

      case 'Mercedes':
        return const Color(0xFF00D2BE);

      case 'McLaren':
        return const Color(0xFFFF8700);

      case 'Aston Martin':
        return const Color(0xFF006F62);

      case 'Alpine F1 Team':
        return const Color(0xFF0090FF);

      case 'Williams':
        return const Color(0xFF005AFF);

      case 'RB F1 Team':
        return const Color(0xFF2B4562);

      case 'Sauber':
        return const Color(0xFF900000);

      case 'Haas F1 Team':
        return const Color(0xFFFFFFFF);

      default:
        return Colors.grey;
    }
  }

  static Color _lighten(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness + amount).clamp(0.0, 1.0))
        .toColor();
  }

  static Color _darken(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness - amount).clamp(0.0, 1.0))
        .toColor();
  }

  static LinearGradient getF1TeamGradient(String constructorName) {
    final baseColor = getF1TeamColor(constructorName);

    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [_lighten(baseColor, 0.25), _darken(baseColor, 0.25)],
    );
  }
}
