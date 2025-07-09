import 'package:bloc/bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../usecases/auth/login.dart';
import '../../../../models/user.dart';
part 'login_state.dart';

@injectable
class LoginCubit extends Cubit<LoginState> {
  LoginCubit({required this.loginUseCase}) : super(LoginState());

  final LoginUseCase loginUseCase;

  void updateEmail() {}

  Future<void> signIn(String email, String password) async {
    try {
      emit(state.copyWith(status: LoginStatus.loading));

      final user = await loginUseCase.execute(LoginInput(email, password));

      user.fold(
        (failure) {
          print("Error occurred: ${failure.message}");
          emit(state.copyWith(
            status: LoginStatus.failure,
            error: failure.message,
          ));
        },
        (userModel) => emit(
          state.copyWith(
            status: LoginStatus.success,
            user: userModel,
            email: email,
            password: password,
          ),
        ),
      );
    } catch (e) {
      print("Error occurred: $e");
      emit(state.copyWith(
        status: LoginStatus.failure,
        error: e.toString(),
      ));
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      emit(state.copyWith(status: LoginStatus.loading));
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final googleUser = await googleSignIn.signIn();
      final googleAuth = await googleUser!.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;
      if (accessToken == null) {
        throw 'No Access Token found.';
      }
      if (idToken == null) {
        throw 'No ID Token found.';
      }
      final response = await Supabase.instance.client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
      emit(state.copyWith(
        status: LoginStatus.success,
      ));
      print('Sign in successful: ${response.user}');
    } catch (e) {
      print("error occured : $e");
      return;
    }
  }
}
