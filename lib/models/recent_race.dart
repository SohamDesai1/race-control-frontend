import 'package:freezed_annotation/freezed_annotation.dart';

part 'recent_race.freezed.dart';
part 'recent_race.g.dart';

@freezed
abstract class RecentResultModel with _$RecentResultModel {
  const factory RecentResultModel({
    @JsonKey(name: "Circuit") required Circuit circuit,
    @JsonKey(name: "Results") required List<Result> results,
    required DateTime date,
    required String raceName,
    required String round,
    required String season,
    required String time,
    required String url,
  }) = _RecentResultModel;

  factory RecentResultModel.fromJson(Map<String, dynamic> json) =>
      _$RecentResultModelFromJson(json);
}

@freezed
abstract class Circuit with _$Circuit {
  const factory Circuit({
    @JsonKey(name: "Location") required Location location,
    required String circuitId,
    required String circuitName,
    required String url,
  }) = _Circuit;

  factory Circuit.fromJson(Map<String, dynamic> json) =>
      _$CircuitFromJson(json);
}

@freezed
abstract class Location with _$Location {
  const factory Location({
    required String country,
    required String lat,
    required String locality,
    required String long,
  }) = _Location;

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);
}

@freezed
abstract class Result with _$Result {
  const factory Result({
    @JsonKey(name: "Constructor") required Constructor constructor,
    @JsonKey(name: "Driver") required Driver driver,
    @JsonKey(name: "FastestLap") FastestLap? fastestLap,
    @JsonKey(name: "Time") ResultTime? time,
    required String grid,
    required String laps,
    required String number,
    required String points,
    required String position,
    required String positionText,
    required Status status,
  }) = _Result;

  factory Result.fromJson(Map<String, dynamic> json) => _$ResultFromJson(json);
}

@freezed
abstract class Constructor with _$Constructor {
  const factory Constructor({
    required String constructorId,
    required String name,
    required String nationality,
    required String url,
  }) = _Constructor;

  factory Constructor.fromJson(Map<String, dynamic> json) =>
      _$ConstructorFromJson(json);
}

@freezed
abstract class Driver with _$Driver {
  const factory Driver({
    required String code,
    required DateTime dateOfBirth,
    required String driverId,
    required String familyName,
    required String givenName,
    required String nationality,
    required String permanentNumber,
    required String url,
  }) = _Driver;

  factory Driver.fromJson(Map<String, dynamic> json) => _$DriverFromJson(json);
}

@freezed
abstract class FastestLap with _$FastestLap {
  const factory FastestLap({
    @JsonKey(name: "Time") required FastestLapTime time,
    required String lap,
    required String rank,
  }) = _FastestLap;

  factory FastestLap.fromJson(Map<String, dynamic> json) =>
      _$FastestLapFromJson(json);
}

@freezed
abstract class FastestLapTime with _$FastestLapTime {
  const factory FastestLapTime({required String time}) = _FastestLapTime;

  factory FastestLapTime.fromJson(Map<String, dynamic> json) =>
      _$FastestLapTimeFromJson(json);
}

@freezed
abstract class ResultTime with _$ResultTime {
  const factory ResultTime({required String millis, required String time}) =
      _ResultTime;

  factory ResultTime.fromJson(Map<String, dynamic> json) =>
      _$ResultTimeFromJson(json);
}

enum Status {
  @JsonValue("Disqualified")
  DISQUALIFIED,

  @JsonValue("Finished")
  FINISHED,

  @JsonValue("Lapped")
  LAPPED,

  @JsonValue("Retired")
  RETIRED,
}
