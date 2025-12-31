import 'package:freezed_annotation/freezed_annotation.dart';

part 'driver_telemetry.freezed.dart';
part 'driver_telemetry.g.dart';

@freezed
abstract class DriverTelemetryModel with _$DriverTelemetryModel {
  const factory DriverTelemetryModel({int? speed, int? distance}) =
      _DriverTelemetryModel;

  factory DriverTelemetryModel.fromJson(Map<String, dynamic> json) =>
      _$DriverTelemetryModelFromJson(json);
}
