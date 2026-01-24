import 'package:dartz/dartz.dart';
import 'package:frontend/core/services/failure.dart';
import 'package:frontend/models/driver_telemetry.dart';
import 'package:frontend/models/quali_details.dart';
import 'package:frontend/models/race_details.dart';
import 'package:frontend/models/race_pace_comparison.dart';
import 'package:frontend/models/sector_timings.dart';
import 'package:frontend/models/session_details.dart';

abstract class SessionRepository {
  Future<Either<Failure, List<SessionModel>?>> getraceSessions(
    String raceId,
    String year,
  );
  Future<Either<Failure, List<RaceModel>>> getCalendar(String year);
  Future<Either<Failure, List<SessionDetailsModel>?>> getSessionDetails(
    String sessionId,
  );
  Future<Either<Failure, List<DriverTelemetryModel>?>> getDriverTelemetryData(
    String sessionId,
    String driverNumber,
  );
  Future<Either<Failure, List<SectorTimingsModel>?>> getSectorTimingsData(
    String sessionId,
  );
  Future<Either<Failure, QualiDetailsModel?>> getQualiDetails(
    String year,
    String round,
  );
  Future<Either<Failure, QualiDetailsModel?>> getSprintQualiDetails(
    String sessionId,
  );
  Future<Either<Failure, List<RacePaceComparisonModel>?>>
  getRacePaceComparisonData(String sessionId, int driver1, int driver2);
}
