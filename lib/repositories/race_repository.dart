import 'package:dartz/dartz.dart';
import 'package:frontend/models/constructor_points_history.dart';
import 'package:frontend/models/driver_points_history.dart';
import '../core/services/failure.dart';
import '../models/upcoming_race.dart';
import '../models/recent_race.dart';
import '../models/driver_leaderboard.dart';
import '../models/constructor_leaderboard.dart';


abstract class RaceRepository {
  Future<Either<Failure, List<UpcomingRaceModel>>> getUpcomingRaces(
    String date,
  );
  Future<Either<Failure, RecentResultModel?>> getRecentResult();
  Future<Either<Failure, List<DriverLeaderBoardModel>>> getDriverLeaderboard(
    int year,
    Map<String, dynamic>? queryParams,
  );
  Future<Either<Failure, List<ConstructorLeaderBoardModel>>>
  getConstructorLeaderboard(int year, Map<String, dynamic>? queryParams);
  Future<Either<Failure, DriverPointsHistoryModel>> getDriverPointsHistory(
    String season,
    String driverNumber,
  );
  Future<Either<Failure, ConstructorPointsHistoryModel>>
      getConstructorPointsHistory(String season, String constructorName);
}
