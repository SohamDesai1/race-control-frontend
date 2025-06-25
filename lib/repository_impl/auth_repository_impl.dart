import 'package:dartz/dartz.dart';
import 'package:frontend/core/services/failure.dart';
import 'package:frontend/datasources/auth_datasource.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

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

  @override
  Future<Either<Failure, UserModel>> signInWithGoogle() async {
    // TODO: implement signInWithGoogle
    throw UnimplementedError();
  }
}
