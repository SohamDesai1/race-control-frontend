import 'package:dartz/dartz.dart';
import '../core/services/failure.dart';
import '../models/upcoming_race.dart';
import '../models/recent_race.dart';
import '../models/driver_leaderboard.dart';
import '../models/constructor_leaderboard.dart';

abstract class RaceRepository {
  Future<Either<Failure, List<UpcomingRaceModel>>> getUpcomingRaces(String date);
  Future<Either<Failure, RecentResultModel?>> getRecentResult();
  Future<Either<Failure, List<DriverLeaderBoardModel>>> getDriverLeaderboard();
  Future<Either<Failure, List<ConstructorLeaderBoardModel>>>
  getConstructorLeaderboard();
}
