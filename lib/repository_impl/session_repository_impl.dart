import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../datasources/session_datasource.dart';
import '../repositories/session_repository.dart';
import '../core/services/failure.dart';
import '../models/race_details.dart';

@LazySingleton(as: SessionRepository)
class SessionRepositoryImpl implements SessionRepository {
  SessionRepositoryImpl({required this.remoteDataSource});
  final SessionDatasource remoteDataSource;

  @override
  Future<Either<Failure, List<SessionModel>?>> getraceSessions(
    String raceId,
    String year,
  ) async {
    try {
      final raceDetails = await remoteDataSource.getraceSessions(raceId, year);
      return Right(raceDetails);
    } catch (e) {
      return Left(Failure(400, e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<RaceModel>>> getCalendar(String year) async {
    try {
      final calendar = await remoteDataSource.getCalendar(year);
      return Right(calendar);
    } catch (e) {
      return Left(Failure(400, e.toString()));
    }
  }
}
