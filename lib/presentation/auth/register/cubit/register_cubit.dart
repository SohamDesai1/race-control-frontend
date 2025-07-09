import 'package:bloc/bloc.dart';
import 'package:frontend/usecases/auth/register.dart';
import 'package:injectable/injectable.dart';
part 'register_state.dart';

@injectable
class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit({required this.registerUseCase}) : super(RegisterState());

  final RegisterUseCase registerUseCase;

  void updateName(String name) {
    emit(state.copyWith(name: name));
  }

  void updateUsername(String username) {
    emit(state.copyWith(username: username));
  }

  void updateEmail(String email) {
    emit(state.copyWith(email: email));
  }

  void updatePassword(String password) {
    emit(state.copyWith(password: password));
  }

  void updateCPassword(String cpassword) {
    emit(state.copyWith(confirmPassword: cpassword));
  }

  void updateDob(String dob) {
    emit(state.copyWith(dob: dob));
  }

  Future<void> register() async {
    try {
      emit(state.copyWith(status: RegisterStatus.loading));

      final user = await registerUseCase.execute(RegisterInput(
        state.email!,
        state.password!,
        state.name!,
        state.dob!,
        state.username!,
      ));

      user.fold(
        (failure) {
          print("Error occurred: ${failure.message}");
          emit(state.copyWith(
            status: RegisterStatus.failure,
            error: failure.message,
          ));
        },
        (userModel) => emit(
          state.copyWith(
            status: RegisterStatus.success,
            email: userModel.email,
            password: userModel.hashedPassword,
            name: userModel.name,
            username: userModel.username,
            dob: userModel.dob,
          ),
        ),
      );
    } catch (e) {
      print("Error occurred: $e");
      emit(state.copyWith(
        status: RegisterStatus.failure,
        error: e.toString(),
      ));
    }
  }
}
