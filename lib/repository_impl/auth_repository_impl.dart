import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../core/services/failure.dart';
import '../datasources/auth_datasource.dart';
import '../repositories/auth_repository.dart';
import '../models/user.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required this.authDatasource});
  final AuthDatasource authDatasource;

  @override
  Future<Either<Failure, UserModel>> register(String email, String password,
      String name, String dob, String username) async {
    try {
      final res =
          await authDatasource.register(email, password, name, dob, username);
      return Right(res!);
    } catch (e) {
      return Left(Failure(400, e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel>> signIn(
      String email, String password) async {
    try {
      final res = await authDatasource.signIn(email, password);
      return Right(res!);
    } catch (e) {
      return Left(Failure(400, e.toString()));
    }
  }
}
