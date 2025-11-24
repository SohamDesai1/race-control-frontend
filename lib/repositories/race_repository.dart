import 'package:dartz/dartz.dart';
import 'package:frontend/core/services/failure.dart';
import '../models/upcoming_race.dart';
import '../models/recent_race.dart';

abstract class RaceRepository {
  Future<Either<Failure, List<UpcomingRaceModel>>> getUpcomingRaces();
  Future<Either<Failure, RecentResultModel?>> getRecentResult();
}
