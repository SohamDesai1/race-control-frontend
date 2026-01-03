import 'package:injectable/injectable.dart';
import '../core/services/api_service.dart';
import '../models/constructor_leaderboard.dart';
import '../models/driver_leaderboard.dart';
import '../models/recent_race.dart';
import '../models/upcoming_race.dart';
import '../core/constants/api_routes.dart';

@injectable
class RaceDatasource {
  var api = ApiService();

  Future<List<UpcomingRaceModel>> getUpcomingRaces(String date) async {
    var res = await api.get(ApiRoutes.upcomingRaces(date));
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

  Future<List<DriverLeaderBoardModel>> getDriverLeaderboard(
    int year,
    Map<String, dynamic>? queryParams,
  ) async {
    Map<String, dynamic> q = {};
    if (queryParams != null) {
      q = queryParams;
    }
    var res = await api.get(
      ApiRoutes.driverLeaderboard(year),
      queryParameters: q,
    );

    if (res.isSuccess) {
      final List<dynamic> data = res.body['data'];
      if (data.isEmpty) {
        return [];
      }
      return data
          .map((entry) => DriverLeaderBoardModel.fromJson(entry))
          .toList();
    }

    return [];
  }

  Future<List<ConstructorLeaderBoardModel>> getConstructorLeaderboard(
    int year,
    Map<String, dynamic>? queryParams,
  ) async {
    Map<String, dynamic> q = {};
    if (queryParams != null) {
      q = queryParams;
    }
    var res = await api.get(
      ApiRoutes.constructorLeaderboard(year),
      queryParameters: q,
    );

    if (res.isSuccess) {
      final List<dynamic> data = res.body['data'];
      if (data.isEmpty) {
        return [];
      }
      return data
          .map((entry) => ConstructorLeaderBoardModel.fromJson(entry))
          .toList();
    }

    return [];
  }
}
