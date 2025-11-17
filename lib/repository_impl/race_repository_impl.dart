import 'package:dartz/dartz.dart';
import 'package:frontend/core/services/failure.dart';
import 'package:frontend/datasources/race_datasource.dart';
import 'package:frontend/models/upcoming_race.dart';
import 'package:frontend/repositories/race_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: RaceRepository)
class RaceRepositoryImpl implements RaceRepository {
  RaceRepositoryImpl({required this.raceDatasource});
  final RaceDatasource raceDatasource;

  @override
  Future<Either<Failure, List<UpcomingRaceModel>>> getUpcomingRaces() async {
    try {
      final res = await raceDatasource.getUpcomingRaces();
      return Right(res!);
    } catch (e) {
      return Left(Failure(400, e.toString()));
    }
  }
}
