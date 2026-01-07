import 'package:freezed_annotation/freezed_annotation.dart';
part 'sector_timings.g.dart';
part 'sector_timings.freezed.dart';

@freezed
abstract class SectorTimingsModel with _$SectorTimingsModel {
  const factory SectorTimingsModel({
    @JsonKey(name: "position") int? position,
    @JsonKey(name: "driver_number") int? driverNumber,
    @JsonKey(name: "fastest_lap") double? fastestLap,
    @JsonKey(name: "sector_1") double? sector1,
    @JsonKey(name: "sector_2") double? sector2,
    @JsonKey(name: "sector_3") double? sector3,
  }) = _SectorTimingsModel;

  factory SectorTimingsModel.fromJson(Map<String, dynamic> json) =>
      _$SectorTimingsModelFromJson(json);
}
