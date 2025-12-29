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

  static mapTrackImage(String trackName) {
    switch (trackName) {
      case 'albert_park':
        return 'assets/tracks/Australia.svg';
      case 'americas':
        return 'assets/tracks/Americas.svg';
      case 'bahrain':
        return 'assets/tracks/Bahrain.svg';
      case 'baku':
        return 'assets/tracks/Baku.svg';
      case 'catalunya':
        return 'assets/tracks/Spain.svg';
      case 'hungaroring':
        return 'assets/tracks/Hungororing.svg';
      case 'imola':
        return 'assets/tracks/Imola.png';
      case 'interlagos':
        return 'assets/tracks/Brazil.svg';
      case 'jeddah':
        return 'assets/tracks/Jeddah.png';
      case 'losail':
        return 'assets/tracks/Qatar.png';
      case 'madring':
        return 'assets/tracks/Madrid.svg';
      case 'marina_bay':
        return 'assets/tracks/Singapore.svg';
      case 'miami':
        return 'assets/tracks/Miami.png';
      case 'monaco':
        return 'assets/tracks/Monaco.svg';
      case 'monza':
        return 'assets/tracks/Monza.svg';
      case 'red_bull_ring':
        return 'assets/tracks/Austria.svg';
      case 'rodriguez':
        return 'assets/tracks/Mexico.svg';
      case 'shanghai':
        return 'assets/tracks/China.svg';
      case 'silverstone':
        return 'assets/tracks/British.svg';
      case 'spa':
        return 'assets/tracks/Spa.svg';
      case 'suzuka':
        return 'assets/tracks/Japan.svg';
      case 'vegas':
        return 'assets/tracks/Las Vegas.png';
      case 'villeneuve':
        return 'assets/tracks/Canada.svg';
      case 'yas_marina':
        return 'assets/tracks/Yas Marina.svg';
      case 'zandvoort':
        return 'assets/tracks/Zandvoort.svg';
      default:
        return 'assets/tracks/Spa.svg';
    }
  }

  static mapSessionName(String session) {
    switch (session) {
      case 'FirstPractice':
        return 'FP1';
      case 'SecondPractice':
        return 'FP2';
      case 'ThirdPractice':
        return 'FP3';
      case 'Qualifying':
        return 'Quali';
      case 'SprintQualifying':
        return 'Sprint Quali';
      case 'Sprint':
        return 'Sprint';
      case 'Race':
        return 'Race';
      default:
        return session;
    }
  }

  static String calcStatus(DateTime date) {
    final now = DateTime.now();
    if (date.isAfter(now) && date.difference(now).inDays >= 3) {
      return "Upcoming";
    } else if (date.isAfter(now)) {
      return "Live";
    } else {
      return "Completed";
    }
  }

  static Color calcColor(DateTime date) {
    final status = calcStatus(date);
    switch (status) {
      case "Upcoming":
        return Colors.grey;
      case "Live":
        return const Color.fromARGB(255, 255, 152, 0);
      case "Completed":
        return const Color.fromARGB(255, 76, 175, 80);
      default:
        return Colors.grey;
    }
  }
}
