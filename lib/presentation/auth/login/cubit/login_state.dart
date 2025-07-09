part of 'login_cubit.dart';

enum LoginStatus { initial, loading, success, failure }

class LoginState {
  final LoginStatus status;
  final String? email;
  final String? password;
  final UserModel? user;
  final String? error;

  LoginState({
    this.status = LoginStatus.initial,
    this.email,
    this.password,
    this.user,
    this.error,
  });

  LoginState copyWith({
    LoginStatus? status,
    String? email,
    String? password,
    UserModel? user,
    String? error,
  }) {
    return LoginState(
      status: status ?? this.status,
      email: email ?? this.email,
      password: password ?? this.password,
      user: user ?? this.user,
      error: error ?? this.error,
    );
  }
}
