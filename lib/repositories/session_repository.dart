import 'package:dartz/dartz.dart';
import 'package:frontend/core/services/failure.dart';
import 'package:frontend/models/race_details.dart';

abstract class SessionRepository {
  Future<Either<Failure, List<SessionModel>?>> getraceSessions(
    String raceId,  
    String year,
  );
  Future<Either<Failure, List<RaceModel>>> getCalendar(String year);
}
