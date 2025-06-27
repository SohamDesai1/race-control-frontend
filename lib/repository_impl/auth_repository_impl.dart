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
  Future<void> register(String email, String password) async {
    try {} catch (e) {}
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
