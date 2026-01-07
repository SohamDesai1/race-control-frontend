import 'package:dartz/dartz.dart';
import 'package:frontend/models/driver_telemetry.dart';
import 'package:frontend/models/sector_timings.dart';
import 'package:frontend/models/session_details.dart';
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

  @override
  Future<Either<Failure, List<SessionDetailsModel>?>> getSessionDetails(
    String sessionId,
  ) async {
    try {
      final sessionDetails = await remoteDataSource.getSessionDetails(
        sessionId,
      );
      return Right(sessionDetails);
    } catch (e) {
      return Left(Failure(400, e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<DriverTelemetryModel>?>> getDriverTelemetryData(
    String sessionId,
    String driverNumber,
  ) async {
    try {
      final driverTelemetryData = await remoteDataSource.getDriverTelemetryData(
        sessionId,
        driverNumber,
      );
      return Right(driverTelemetryData);
    } catch (e) {
      return Left(Failure(400, e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SectorTimingsModel>?>> getSectorTimingsData(
    String sessionId,
  ) async {
    try {
      final sectorTimingsData = await remoteDataSource.getSectorTimingsData(
        sessionId,
      );
      return Right(sectorTimingsData);
    } catch (e) {
      return Left(Failure(400, e.toString()));
    }
  }
}
