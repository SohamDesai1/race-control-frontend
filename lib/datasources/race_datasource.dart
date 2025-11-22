import 'package:frontend/core/constants/api_routes.dart';
import 'package:frontend/core/services/api_service.dart';
import 'package:frontend/models/upcoming_race.dart';
import 'package:injectable/injectable.dart';

@injectable
class RaceDatasource {
  var api = ApiService();

  Future<List<UpcomingRaceModel>> getUpcomingRaces() async {
    var res = await api.get(ApiRoutes.upcomingRaces);

    if (res.isSuccess) {
      final data = res.body['data'] as List;
      final races = data.map((e) => UpcomingRaceModel.fromJson(e)).toList();

      return races;
    }

    return [];
  }
}
