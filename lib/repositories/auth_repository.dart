import 'package:dartz/dartz.dart';
import '../core/services/failure.dart';
import '../models/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserModel>> signIn(String email, String password);
  Future<Either<Failure, UserModel>> signInWithGoogle();
  Future<void> register(String email, String password);
}
