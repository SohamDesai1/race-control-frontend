import 'package:flutter/material.dart';

class RaceUtils {
  static final Map<String, String> driverTeamMap = {
    // Red Bull
    'Max Verstappen': 'Red Bull',
    'Isack Hadjar': 'Red Bull',

    // Ferrari
    'Charles Leclerc': 'Ferrari',
    'Lewis Hamilton': 'Ferrari',

    // Mercedes
    'George Russell': 'Mercedes',
    'Andrea Kimi Antonelli': 'Mercedes',

    // McLaren
    'Lando Norris': 'McLaren',
    'Oscar Piastri': 'McLaren',

    // Aston Martin
    'Fernando Alonso': 'Aston Martin',
    'Lance Stroll': 'Aston Martin',

    // Alpine
    'Pierre Gasly': 'Alpine F1 Team',
    'Franco Colapinto': 'Alpine F1 Team',

    // Williams
    'Alex Albon': 'Williams',
    'Carlos Sainz': 'Williams',

    // RB F1 Team
    'Liam Lawson': 'RB F1 Team',
    'Arvid Lindblad': 'RB F1 Team',

    // Sauber
    'Nico Hulkenberg': 'Sauber',
    'Gabriel Bortoleto': 'Sauber',

    // Haas
    'Oliver Bearman': 'Haas F1 Team',
    'Esteban Ocon': 'Haas F1 Team',

    // Cadillac
    'Sergio Perez': 'Cadillac',
    'Valtteri Bottas': 'Cadillac',

    // Legacy drivers
    'Logan Sargeant': 'Williams',
    'Daniel Ricciardo': 'RB F1 Team',
    'Kevin Magnussen': 'Haas F1 Team',
    'Zhou Guanyu': 'Sauber',
    'Jack Doohan': 'Williams',
  };

  static final Map<String, Color> teamColors = {
    'Red Bull': Color(0xFF1E41FF),
    'Ferrari': Color(0xFFDC0000),
    'Mercedes': Color(0xFF00D2BE),
    'McLaren': Color(0xFFFF8700),
    'Aston Martin': Color(0xFF006F62),
    'Alpine F1 Team': Color(0xFF0090FF),
    'Alpine': Color(0xFF0090FF),
    'Williams': Color(0xFF005AFF),
    'RB F1 Team': Color(0xFF2B4562),
    'Racing Bulls': Color(0xFF2B4562),
    'AlphaTauri': Color(0xFF2B4562),
    'Sauber': Color(0xFF900000),
    'Kick Sauber': Color(0xFF900000),
    'Haas F1 Team': Color(0xFFFFFFFF),
    'Haas': Color(0xFFFFFFFF),
  };

  static Color getF1TeamColor(String name) {
    // Check if it's a team name first
    if (teamColors.containsKey(name)) {
      return teamColors[name]!;
    }

    // Check if it's a driver name
    if (driverTeamMap.containsKey(name)) {
      final teamName = driverTeamMap[name]!;
      return teamColors[teamName] ?? Colors.grey;
    }

    return Colors.grey;
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

  static String mapDriverNameFromDriverNumber(int driverNumber, int year) {
    // Driver number mappings by year
    final Map<int, Map<int, String>> driverNumbersByYear = {
      2025: {
        1: 'Max Verstappen',
        4: 'Lando Norris',
        5: 'Gabriel Bortoleto',
        6: 'Isack Hadjar',
        7: 'Jack Doohan',
        10: 'Pierre Gasly',
        11: 'Sergio Perez',
        12: 'Andrea Kimi Antonelli',
        14: 'Fernando Alonso',
        16: 'Charles Leclerc',
        18: 'Lance Stroll',
        20: 'Kevin Magnussen',
        22: 'Yuki Tsunoda',
        23: 'Alex Albon',
        24: 'Zhou Guanyu',
        27: 'Nico Hulkenberg',
        30: 'Liam Lawson',
        31: 'Esteban Ocon',
        43: 'Franco Colapinto',
        44: 'Lewis Hamilton',
        55: 'Carlos Sainz',
        63: 'George Russell',
        77: 'Valtteri Bottas',
        81: 'Oscar Piastri',
        87: 'Oliver Bearman',
      },
      2026: {
        1: 'Lando Norris',
        3: 'Max Verstappen',
        5: 'Gabriel Bortoleto',
        6: 'Isack Hadjar',
        7: 'Jack Doohan',
        10: 'Pierre Gasly',
        11: 'Sergio Perez',
        12: 'Andrea Kimi Antonelli',
        14: 'Fernando Alonso',
        16: 'Charles Leclerc',
        18: 'Lance Stroll',
        20: 'Kevin Magnussen',
        22: 'Yuki Tsunoda',
        23: 'Alex Albon',
        24: 'Zhou Guanyu',
        27: 'Nico Hulkenberg',
        30: 'Liam Lawson',
        31: 'Esteban Ocon',
        41: 'Arvid Lindblad',
        43: 'Franco Colapinto',
        44: 'Lewis Hamilton',
        55: 'Carlos Sainz',
        63: 'George Russell',
        77: 'Valtteri Bottas',
        81: 'Oscar Piastri',
        87: 'Oliver Bearman',
      },
    };

    if (driverNumbersByYear.containsKey(year)) {
      final yearDrivers = driverNumbersByYear[year];
      if (yearDrivers != null && yearDrivers.containsKey(driverNumber)) {
        return yearDrivers[driverNumber]!;
      }
    }

    // Fallback: try to find driver in any year (most recent first)
    final sortedYears = driverNumbersByYear.keys.toList()
      ..sort((a, b) => b.compareTo(a));
    for (final y in sortedYears) {
      if (driverNumbersByYear[y]!.containsKey(driverNumber)) {
        return driverNumbersByYear[y]![driverNumber]!;
      }
    }

    return 'Unknown Driver';
  }
}
