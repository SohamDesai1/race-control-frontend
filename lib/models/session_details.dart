import 'package:freezed_annotation/freezed_annotation.dart';
part 'session_details.freezed.dart';
part 'session_details.g.dart';

@freezed
abstract class SessionDetailsModel with _$SessionDetailsModel {
  const factory SessionDetailsModel({
    bool? dnf,
    bool? dns,
    @JsonKey(name: 'driver_number') int? driverNumber,
    bool? dsq,
    double? duration,
    @JsonKey(name: 'gap_to_leader') dynamic gapToLeader,
    @JsonKey(name: 'meeting_key') int? meetingKey,
    @JsonKey(name: 'number_of_laps') int? numberOfLaps,
    double? points,
    int? position,
    @JsonKey(name: 'session_key')int? sessionKey,
  }) = _SessionDetailsModel;

  factory SessionDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$SessionDetailsModelFromJson(json);
}
