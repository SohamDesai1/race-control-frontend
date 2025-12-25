import 'package:freezed_annotation/freezed_annotation.dart';
part 'upcoming_race.freezed.dart';
part 'upcoming_race.g.dart';

@freezed
abstract class UpcomingRaceModel with _$UpcomingRaceModel {
  factory UpcomingRaceModel({
     String? circuitId,
     String? circuitName,
     String? country,
     String? lat,
     String? long,
     String? locality,
    @JsonKey(name: 'created_at') 
     String? createdAt,
     String? date,
     int? id,
     String? raceName,
     String? round,
     String? season,
     String? time,
  }) = _UpcomingRaceModel;

  factory UpcomingRaceModel.fromJson(Map<String, dynamic> json) =>
      _$UpcomingRaceModelFromJson(json);
}
