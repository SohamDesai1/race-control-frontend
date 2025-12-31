import 'package:frontend/models/driver_telemetry.dart';
import 'package:frontend/models/session_details.dart';
import 'package:injectable/injectable.dart';
import '../core/services/api_service.dart';
import '../models/race_details.dart';
import '../core/constants/api_routes.dart';

@injectable
class SessionDatasource {
  var api = ApiService();

  Future<List<SessionModel>?> getraceSessions(
    String raceId,
    String year,
  ) async {
    var res = await api.get(ApiRoutes.raceSessions(raceId, year));

    if (res.isSuccess) {
      final List<dynamic> data = res.body['sessions'];
      return data.map((entry) => SessionModel.fromJson(entry)).toList();
    }

    return null;
  }

  Future<List<RaceModel>> getCalendar(String year) async {
    var res = await api.get(ApiRoutes.allRacesInSeason(year));

    if (res.isSuccess) {
      final List<dynamic> data = res.body['data'];

      return data.map((entry) => RaceModel.fromJson(entry)).toList();
    }

    return [];
  }

  Future<List<SessionDetailsModel>?> getSessionDetails(String sessionId) async {
    var res = await api.get(ApiRoutes.sessionDetails(sessionId));

    if (res.isSuccess) {
      final List<dynamic> data = res.body['data'];
      return data.map((entry) => SessionDetailsModel.fromJson(entry)).toList();
    }

    return null;
  }

  Future<List<DriverTelemetryModel>?> getDriverTelemetryData(
    String sessionId,
    String driverNumber,
  ) async {
    var res = await api.get(
      ApiRoutes.driverTelemetryData(sessionId, driverNumber),
    );

    if (res.isSuccess) {
      final List<dynamic> data = res.body['data'];
      return data.map((entry) => DriverTelemetryModel.fromJson(entry)).toList();
    }

    return null;
  }
}
