import 'package:freezed_annotation/freezed_annotation.dart';
part 'race_pace_comparison.freezed.dart';
part 'race_pace_comparison.g.dart';
@freezed
abstract class RacePaceComparisonModel with _$RacePaceComparisonModel {
    const factory RacePaceComparisonModel({
        int? x,
        int? y,
        int? minisector,
        @JsonKey(name: "fastest_driver")
        int? fastestDriver,
    }) = _RacePaceComparisonModel;

    factory RacePaceComparisonModel.fromJson(Map<String, dynamic> json) => _$RacePaceComparisonModelFromJson(json);
}
