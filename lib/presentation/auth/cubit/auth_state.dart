part of 'auth_cubit.dart';

enum AuthStatus { initial, loading, success, failure }

class AuthState {
  final AuthStatus status;
  final String? email;
  final String? password;
  final UserModel? user;
  final String? error;

  AuthState({
    this.status = AuthStatus.initial,
    this.email,
    this.password,
    this.user,
    this.error,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? email,
    String? password,
    UserModel? user,
    String? error,
  }) {
    return AuthState(
      status: status ?? this.status,
      email: email ?? this.email,
      password: password ?? this.password,
      user: user ?? this.user,
      error: error ?? this.error,
    );
  }
}

