import 'package:dartz/dartz.dart';
import 'package:frontend/core/services/failure.dart';
import 'package:frontend/models/upcoming_race.dart';

abstract class RaceRepository {
  Future<Either<Failure, List<UpcomingRaceModel>>> getUpcomingRaces();
}