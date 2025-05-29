import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import '../../../repositories/auth_repository.dart';
import '../../../models/user.dart';
part 'auth_state.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required this.authRepository}) : super(AuthInitial());

  final AuthRepository authRepository;

  Future<void> signInWithGoogle() async {
    try {
      emit(AuthLoading());

      // Tokens are fetched in datasource
      final user = await authRepository.signInWithGoogle();

      if (user != null) {
        emit(AuthSuccess(user));
      } else {
        emit(AuthFailure("Google sign-in failed"));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      emit(AuthLoading());

      final user = await authRepository.signIn(email, password);

      if (user != null) {
        emit(AuthSuccess(user));
      } else {
        emit(AuthFailure("Invalid email or password"));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
