import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';
import '../datasources/race_datasource.dart';
import '../core/services/failure.dart';
import '../repositories/race_repository.dart';
import '../models/constructor_leaderboard.dart';
import '../models/driver_leaderboard.dart';
import '../models/recent_race.dart';
import '../models/upcoming_race.dart';

@LazySingleton(as: RaceRepository)
class RaceRepositoryImpl implements RaceRepository {
  RaceRepositoryImpl({required this.raceDatasource});
  final RaceDatasource raceDatasource;

  @override
  Future<Either<Failure, List<UpcomingRaceModel>>> getUpcomingRaces(
    String date,
  ) async {
    try {
      final res = await raceDatasource.getUpcomingRaces(date);
      return Right(res);
    } catch (e) {
      return Left(Failure(400, e.toString()));
    }
  }

  @override
  Future<Either<Failure, RecentResultModel?>> getRecentResult() async {
    try {
      final res = await raceDatasource.getRecentResult();
      return Right(res);
    } catch (e) {
      return Left(Failure(400, e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<DriverLeaderBoardModel>>> getDriverLeaderboard(
    int year,
    Map<String, dynamic>? queryParams,
  ) async {
    try {
      final res = await raceDatasource.getDriverLeaderboard(year, queryParams);
      return Right(res);
    } catch (e) {
      return Left(Failure(400, e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ConstructorLeaderBoardModel>>>
  getConstructorLeaderboard(int year, Map<String, dynamic>? queryParams) async {
    try {
      final res = await raceDatasource.getConstructorLeaderboard(
        year,
        queryParams,
      );
      return Right(res);
    } catch (e) {
      return Left(Failure(400, e.toString()));
    }
  }
}
