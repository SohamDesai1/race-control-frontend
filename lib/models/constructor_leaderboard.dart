import 'package:freezed_annotation/freezed_annotation.dart';
part 'constructor_leaderboard.freezed.dart';
part 'constructor_leaderboard.g.dart';

@freezed
abstract class ConstructorLeaderBoardModel with _$ConstructorLeaderBoardModel {
  const factory ConstructorLeaderBoardModel({
    @JsonKey(name: "Constructor") required Constructor constructor,
    @JsonKey(name: "points") required String points,
    @JsonKey(name: "position") required String position,
    @JsonKey(name: "positionText") required String positionText,
    @JsonKey(name: "wins") required String wins,
  }) = _ConstructorLeaderBoardModel;

  factory ConstructorLeaderBoardModel.fromJson(Map<String, dynamic> json) =>
      _$ConstructorLeaderBoardModelFromJson(json);
}

@freezed
abstract class Constructor with _$Constructor {
  const factory Constructor({
    @JsonKey(name: "constructorId") required String constructorId,
    @JsonKey(name: "name") required String name,
    @JsonKey(name: "nationality") required String nationality,
    @JsonKey(name: "url") required String url,
  }) = _Constructor;

  factory Constructor.fromJson(Map<String, dynamic> json) =>
      _$ConstructorFromJson(json);
}
