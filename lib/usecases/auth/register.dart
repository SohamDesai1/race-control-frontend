import 'package:dartz/dartz.dart';
import 'package:frontend/core/services/failure.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/repositories/auth_repository.dart';
import 'package:frontend/utils/base_usecase.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class RegisterUseCase implements BaseUseCase<RegisterInput, UserModel> {
  RegisterUseCase(this.authRepository);
  final AuthRepository authRepository;

  @override
  Future<Either<Failure, UserModel>> execute(RegisterInput input) async {
    return await authRepository.register(
        input.email, input.password, input.dob, input.name, input.username);
  }
}

class RegisterInput {
  String email;
  String password;
  String name;
  String dob;
  String username;

  RegisterInput(this.email, this.password, this.name, this.dob, this.username);
}
