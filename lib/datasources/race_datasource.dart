import 'package:frontend/core/constants/api_routes.dart';
import 'package:frontend/core/services/api_service.dart';
import 'package:frontend/models/constructor_leaderboard.dart';
import 'package:frontend/models/driver_leaderboard.dart';
import 'package:frontend/models/race_details.dart';
import 'package:frontend/models/recent_race.dart';
import 'package:frontend/models/upcoming_race.dart';
import 'package:injectable/injectable.dart';

@injectable
class RaceDatasource {
  var api = ApiService();

  Future<List<UpcomingRaceModel>> getUpcomingRaces() async {
    var res = await api.get(ApiRoutes.upcomingRaces);
    if (res.isSuccess) {
      final data = res.body['data'] as List? ?? [];
      return data.map((e) => UpcomingRaceModel.fromJson(e)).toList();
    }

    return [];
  }

  Future<RecentResultModel?> getRecentResult() async {
    var res = await api.get(ApiRoutes.recentResults);

    if (res.isSuccess) {
      final data = res.body['data'] as List;
      final recentResults = RecentResultModel.fromJson(data[0]);

      return recentResults;
    }

    return null;
  }

  Future<List<DriverLeaderBoardModel>> getDriverLeaderboard() async {
    var res = await api.get(ApiRoutes.driverLeaderboard(DateTime.now().year));

    if (res.isSuccess) {
      final List<dynamic> data = res.body['data'];

      return data
          .map((entry) => DriverLeaderBoardModel.fromJson(entry))
          .toList();
    }

    return [];
  }

  Future<List<ConstructorLeaderBoardModel>> getConstructorLeaderboard() async {
    var res = await api.get(
      ApiRoutes.constructorLeaderboard(DateTime.now().year),
    );

    if (res.isSuccess) {
      final List<dynamic> data = res.body['data'];

      return data
          .map((entry) => ConstructorLeaderBoardModel.fromJson(entry))
          .toList();
    }

    return [];
  }

  Future<RaceDetailsModel?> getRaceDetails(String year, String round) async {
    var res = await api.get(ApiRoutes.raceDetails(year, round));

    if (res.isSuccess) {
      return RaceDetailsModel.fromJson(res.body);
    }

    return null;
  }
}
