import 'package:flutter/material.dart';

class RaceUtils {
  static final Map<int, Map<String, String>> driverTeamByYear = {
    // Red Bull
    2025: {
      'Max Verstappen': 'Red Bull',
      'Liam Lawson': 'Red Bull',

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
      'Isack Hadjar': 'RB F1 Team',
      'Yuki Tsunoda': 'RB F1 Team',

      // Sauber
      'Nico Hulkenberg': 'Sauber',
      'Gabriel Bortoleto': 'Sauber',

      // Haas
      'Oliver Bearman': 'Haas F1 Team',
      'Esteban Ocon': 'Haas F1 Team',
    },

    2026: {
      // Cadillac
      'Sergio Perez': 'Cadillac',
      'Valtteri Bottas': 'Cadillac',

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
      'Yuki Tsunoda': 'RB F1 Team',

      // Sauber
      'Nico Hulkenberg': 'Audi',
      'Gabriel Bortoleto': 'Audi',

      // Haas
      'Oliver Bearman': 'Haas F1 Team',
      'Esteban Ocon': 'Haas F1 Team',
    },
  };
  // // Legacy drivers
  // 'Logan Sargeant': 'Williams',
  // 'Daniel Ricciardo': 'RB F1 Team',
  // 'Kevin Magnussen': 'Haas F1 Team',
  // 'Zhou Guanyu': 'Sauber',
  // 'Jack Doohan': 'Williams',

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
    "Cadillac": Color(0xFF909090),
    "Audi": Color(0xFFF50537),
  };

  static Color getF1TeamColor(String name, {int year = 2025}) {
    // Check if it's a team name first
    if (teamColors.containsKey(name)) {
      return teamColors[name]!;
    }

    if (driverTeamByYear.containsKey(year)) {
      final yearDrivers = driverTeamByYear[year];
      if (yearDrivers != null && yearDrivers.containsKey(name)) {
        return teamColors[yearDrivers[name]!] ?? Colors.grey;
      }
    }

    // Fallback: try to find driver in any year (most recent first)
    final sortedYears = driverTeamByYear.keys.toList()
      ..sort((a, b) => b.compareTo(a));
    for (final y in sortedYears) {
      if (driverTeamByYear[y]!.containsKey(name)) {
        return teamColors[driverTeamByYear[y]![name]!] ?? Colors.grey;
      }
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

  static String? getDriverImage(String? driverName) {
    if (driverName == null) return null;

    final Map<String, String> driverImageMap = {
      'Max Verstappen': 'assets/drivers/max.png',
      'Lando Norris': 'assets/drivers/lando.png',
      'Charles Leclerc': 'assets/drivers/leclerc.png',
      'Lewis Hamilton': 'assets/drivers/lewis.png',
      'George Russell': 'assets/drivers/russel.png',
      'Oscar Piastri': 'assets/drivers/oscar.png',
      'Fernando Alonso': 'assets/drivers/alonso.png',
      'Lance Stroll': 'assets/drivers/stroll.png',
      'Pierre Gasly': 'assets/drivers/gasly.png',
      'Franco Colapinto': 'assets/drivers/colapinto.png',
      'Alexander Albon': 'assets/drivers/albon.png',
      'Alex Albon': 'assets/drivers/albon.png',
      'Carlos Sainz': 'assets/drivers/carlos.png',
      'Liam Lawson': 'assets/drivers/lawson.png',
      'Arvid Lindblad': 'assets/drivers/arvid.png',
      'Nico Hülkenberg': 'assets/drivers/nico.png',
      'Nico Hulkenberg': 'assets/drivers/nico.png',
      'Gabriel Bortoleto': 'assets/drivers/gabreil.png',
      'Oliver Bearman': 'assets/drivers/bearman.png',
      'Esteban Ocon': 'assets/drivers/ocon.png',
      'Sergio Perez': 'assets/drivers/perez.png',
      'Valtteri Bottas': 'assets/drivers/bottas.png',
      'Andrea Kimi Antonelli': 'assets/drivers/kimi.png',
      'Isack Hadjar': 'assets/drivers/hadjar.png',
      'Yuki Tsunoda': 'assets/drivers/tsunoda.png',
      'Jack Doohan': 'assets/drivers/jack.png',
    };

    return driverImageMap[driverName];
  }

  static String getConstructorLogo(String constructorName) {
    final Map<String, String> constructorLogoMap = {
      'Red Bull': 'assets/constructors/red_bull.png',
      'Ferrari': 'assets/constructors/ferrari.png',
      'Mercedes': 'assets/constructors/mercedes.png',
      'McLaren': 'assets/constructors/mclaren.png',
      'Aston Martin': 'assets/constructors/aston_martin.png',
      'Alpine F1 Team': 'assets/constructors/alpine.png',
      'Alpine': 'assets/constructors/alpine.png',
      'Williams': 'assets/constructors/williams.png',
      'RB F1 Team': 'assets/constructors/rb.png',
      'Racing Bulls': 'assets/constructors/rb.png',
      'AlphaTauri': 'assets/constructors/rb.png',
      'Sauber': 'assets/constructors/sauber.png',
      'Kick Sauber': 'assets/constructors/sauber.png',
      'Audi': 'assets/constructors/audi.png',
      'Haas F1 Team': 'assets/constructors/haas.png',
      'Haas': 'assets/constructors/haas.png',
      'Cadillac': 'assets/constructors/cadillac.png',
    };

    return constructorLogoMap[constructorName] ??
        'assets/constructors/placeholder.png';
  }

  static String getCountryFlag(String? nationality) {
    final Map<String, String> countryFlags = {
      'Dutch': '🇳🇱',
      'British': '🇬🇧',
      'Monégasque': '🇲🇨',
      'German': '🇩🇪',
      'Australian': '🇦🇺',
      'Spanish': '🇪🇸',
      'French': '🇫🇷',
      'Thai': '🇹🇭',
      'Japanese': '🇯🇵',
      'Mexican': '🇲🇽',
      'Chinese': '🇨🇳',
      'Finnish': '🇫🇮',
      'Italian': '🇮🇹',
      'Canadian': '🇨🇦',
      'Brazilian': '🇧🇷',
      'American': '🇺🇸',
      'Danish': '🇩🇰',
      'New Zealander': '🇳🇿',
      'Argentinian': '🇦🇷',
      'Colombian': '🇨🇴',
    };

    return countryFlags[nationality ?? ''] ?? '🏳️';
  }

  static String mapConstructorNameFromDriverNumber(int driverNumber, int year) {
    final driverName = mapDriverNameFromDriverNumber(driverNumber, year);
    final teamColor = getF1TeamColor(driverName, year: year);

    // Reverse lookup to find constructor by color
    for (final entry in teamColors.entries) {
      if (entry.value == teamColor) {
        return entry.key;
      }
    }

    return 'Unknown Constructor';
  }
}
