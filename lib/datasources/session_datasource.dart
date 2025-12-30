import 'package:injectable/injectable.dart';
import '../core/services/api_service.dart';
import '../models/race_details.dart';
import '../core/constants/api_routes.dart';

@injectable
class SessionDatasource {
  var api = ApiService();

  Future<List<SessionModel>?> getraceSessions(String raceId, String year) async {
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
}
