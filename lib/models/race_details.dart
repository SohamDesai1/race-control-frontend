
import 'package:freezed_annotation/freezed_annotation.dart';
part 'race_details.freezed.dart';
part 'race_details.g.dart';

@freezed
abstract class RaceDetailsModel with _$RaceDetailsModel {
  const factory RaceDetailsModel({
    required List<Circuit> circuit,
    required List<RaceModel> race,
    required List<SessionModel> sessions,
  }) = _RaceDetailsModel;

  factory RaceDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$RaceDetailsModelFromJson(json);
}

@freezed
abstract class Circuit with _$Circuit {
  const factory Circuit({
    String? circuitId,
    String? circuitName,
    String? country,
    @JsonKey(name: "created_at") DateTime? createdAt,
    String? lat,
    String? locality,
    String? long,
  }) = _Circuit;

  factory Circuit.fromJson(Map<String, dynamic> json) =>
      _$CircuitFromJson(json);
}

@freezed
abstract class RaceModel with _$RaceModel {
  const factory RaceModel({
    String? circuitId,
    @JsonKey(name: "created_at") DateTime? createdAt,
    DateTime? date,
    int? id,
    String? raceName,
    String? round,
    String? season,
    String? time,
  }) = _RaceModel;

  factory RaceModel.fromJson(Map<String, dynamic> json) => _$RaceModelFromJson(json);
}

@freezed
abstract class SessionModel with _$SessionModel {
  const factory SessionModel({
    String? country,
    DateTime? date,
    int? id,
    @JsonKey(name: "meeting_key") int? meetingKey,
    int? raceId,
    String? sessionType,
    @JsonKey(name: "session_key") int? sessionKey,
    String? time,
  }) = _SessionModel;

  factory SessionModel.fromJson(Map<String, dynamic> json) =>
      _$SessionModelFromJson(json);
}
