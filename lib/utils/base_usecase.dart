import 'package:dartz/dartz.dart';
import 'package:frontend/core/services/failure.dart';

abstract class BaseUseCase<In, Out> {
  Future<Either<Failure, Out>> execute(In input);
}