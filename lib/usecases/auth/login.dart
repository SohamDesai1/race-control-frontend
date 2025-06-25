import 'package:dartz/dartz.dart';
import 'package:frontend/core/services/failure.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/repositories/auth_repository.dart';
import 'package:frontend/utils/base_usecase.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class LoginUseCase implements BaseUseCase<LoginInput, UserModel> {
  LoginUseCase(this.authRepository);
  final AuthRepository authRepository;

  @override
  Future<Either<Failure, UserModel>> execute(LoginInput input) async {
    return await authRepository.signIn(input.email, input.password);
  }
}

class LoginInput {
  String email;
  String password;

  LoginInput(this.email, this.password);
}
