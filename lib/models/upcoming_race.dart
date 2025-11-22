import 'package:freezed_annotation/freezed_annotation.dart';
part 'upcoming_race.freezed.dart';
part 'upcoming_race.g.dart';

@freezed
abstract class UpcomingRaceModel with _$UpcomingRaceModel {
  factory UpcomingRaceModel({
    required String circuitId,
    @JsonKey(name: 'created_at') 
    required String createdAt,
    required String date,
    required int id,
    required String raceName,
    required String round,
    required String season,

    required String time,
  }) = _UpcomingRaceModel;

  factory UpcomingRaceModel.fromJson(Map<String, dynamic> json) =>
      _$UpcomingRaceModelFromJson(json);
}
