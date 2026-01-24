import 'package:freezed_annotation/freezed_annotation.dart';
part 'quali_details.freezed.dart';
part 'quali_details.g.dart';

@freezed
abstract class QualiDetailsModel with _$QualiDetailsModel {
  const factory QualiDetailsModel({
    @JsonKey(name: "q1") List<QualiSession>? q1,
    @JsonKey(name: "q2") List<QualiSession>? q2,
    @JsonKey(name: "q3") List<QualiSession>? q3,
  }) = _QualiDetailsModel;

  factory QualiDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$QualiDetailsModelFromJson(json);
}

@freezed
abstract class QualiSession with _$QualiSession {
  const factory QualiSession({
    @JsonKey(name: "position") int? position,
    @JsonKey(name: "driver_number") String? driverNumber,
    @JsonKey(name: "driver_code") String? driverCode,
    @JsonKey(name: "driver_name") String? driverName,
    @JsonKey(name: "constructor") String? constructor,
    @JsonKey(name: "time") String? time,
    @JsonKey(name: "time_seconds") double? timeSeconds,
  }) = _QualiSession;

  factory QualiSession.fromJson(Map<String, dynamic> json) =>
      _$QualiSessionFromJson(json);
}
