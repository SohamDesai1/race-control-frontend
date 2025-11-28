import 'package:freezed_annotation/freezed_annotation.dart';
part 'driver_leaderboard.freezed.dart';
part 'driver_leaderboard.g.dart';

@freezed
abstract class DriverLeaderBoardModel with _$DriverLeaderBoardModel {
  const factory DriverLeaderBoardModel({
    @JsonKey(name: "Constructors") required List<Constructor> constructors,
    @JsonKey(name: "Driver") required Driver driver,
    required String points,
    required String position,
    required String positionText,
    required String wins,
  }) = _DriverLeaderBoardModel;
  factory DriverLeaderBoardModel.fromJson(Map<String, dynamic> json) =>
      _$DriverLeaderBoardModelFromJson(json);
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
