class DriverPointsHistoryModel {
  final String season;
  final List<DriverPoints> standings;

  DriverPointsHistoryModel({required this.season, required this.standings});

  factory DriverPointsHistoryModel.fromJson(Map<String, dynamic> json) {
    return DriverPointsHistoryModel(
      season: json['season'] as String,
      standings: (json['standings'] as List<dynamic>)
          .map(
            (e) => DriverPoints.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'season': season,
      'standings': standings.map((e) => e.toJson()).toList(),
    };
  }
}

class DriverPoints {
  final String driverNumber;
  final String season;
  final String round;
  final double pointsCurrent;
  final int? position;
  final String raceName;

  DriverPoints({
    required this.driverNumber,
    required this.season,
    required this.round,
    required this.pointsCurrent,
    required this.position,
    required this.raceName,
  });

  factory DriverPoints.fromJson(Map<String, dynamic> json) {
    final roundValue = json['round'];
    return DriverPoints(
      driverNumber: json['driver_number'].toString(),
      season: json['season'].toString(),
      round: roundValue is String ? roundValue : roundValue.toString(),
      pointsCurrent: (json['points_current'] as num).toDouble(),
      position: json['position'] != null ? json['position'] as int : null,
      raceName: json['race_name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'driver_number': driverNumber,
      'season': season,
      'round': round,
      'points_current': pointsCurrent,
      'position': position,
      'race_name': raceName,
    };
  }
}
