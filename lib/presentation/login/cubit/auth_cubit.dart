import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../usecases/auth/login.dart';
import '../../../models/user.dart';
part 'auth_state.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required this.loginUseCase}) : super(AuthInitial());

  final LoginUseCase loginUseCase;

  // Future<void> signInWithGoogle() async {
  //   try {
  //     emit(AuthLoading());

  //     // Tokens are fetched in datasource
  //     final user = await loginUseCase.;

  //     if (user != null) {
  //       emit(AuthSuccess(user));
  //     } else {
  //       emit(AuthFailure("Google sign-in failed"));
  //     }
  //   } catch (e) {
  //     emit(AuthFailure(e.toString()));
  //   }
  // }

  Future<void> signIn(String email, String password) async {
    try {
      emit(AuthLoading());

      final user = await loginUseCase.execute(LoginInput(email, password));

      user.fold(
        (failure) => emit(AuthFailure(failure.message)),
        (userModel) => emit(AuthSuccess(userModel)),
      );
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
