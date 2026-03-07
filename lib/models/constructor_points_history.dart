class ConstructorPointsHistoryModel {
  final String season;
  final List<ConstructorPoints> standings;

  ConstructorPointsHistoryModel({
    required this.season,
    required this.standings,
  });

  factory ConstructorPointsHistoryModel.fromJson(Map<String, dynamic> json) {
    return ConstructorPointsHistoryModel(
      season: json['season'] as String,
      standings: (json['standings'] as List<dynamic>)
          .map((e) => ConstructorPoints.fromJson(e as Map<String, dynamic>))
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

class ConstructorPoints {
  final String constructorId;
  final String constructorName;
  final String season;
  final String round;
  final double pointsCurrent;
  final int? position;
  final String raceName;

  ConstructorPoints({
    required this.constructorId,
    required this.constructorName,
    required this.season,
    required this.round,
    required this.pointsCurrent,
    required this.position,
    required this.raceName,
  });

  factory ConstructorPoints.fromJson(Map<String, dynamic> json) {
    final roundValue = json['round'];
    return ConstructorPoints(
      constructorId: json['constructor_id'].toString(),
      constructorName: json['constructor_name'] as String,
      season: json['season'].toString(),
      round: roundValue is String ? roundValue : roundValue.toString(),
      pointsCurrent: (json['points_current'] as num).toDouble(),
      position: json['position'] != null ? json['position'] as int : null,
      raceName: json['race_name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'constructor_id': constructorId,
      'constructor_name': constructorName,
      'season': season,
      'round': round,
      'points_current': pointsCurrent,
      'position': position,
      'race_name': raceName,
    };
  }
}
