import 'package:freezed_annotation/freezed_annotation.dart';
part 'upcoming_race.freezed.dart';
part 'upcoming_race.g.dart';

@freezed
abstract class UpcomingRaceModel with _$UpcomingRaceModel {
  factory UpcomingRaceModel({
    @JsonKey(name: 'circuit_id') String? circuitId,
    @JsonKey(name: 'circuit_name') String? circuitName,
    String? country,
    String? lat,
    String? long,
    String? locality,
    @JsonKey(name: 'created_at') String? createdAt,
    String? date,
    int? id,
    @JsonKey(name: 'race_name') String? raceName,
    String? round,
    String? season,
    String? time,
  }) = _UpcomingRaceModel;

  factory UpcomingRaceModel.fromJson(Map<String, dynamic> json) =>
      _$UpcomingRaceModelFromJson(json);
}
