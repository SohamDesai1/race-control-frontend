part of 'register_cubit.dart';

enum RegisterStatus { initial, loading, success, failure }

class RegisterState {
  final RegisterStatus status;
  final String? name;
  final String? username;
  final String? email;
  final String? password;
  final String? confirmPassword;
  final String? dob;
  final String? error;

  RegisterState({
    this.status = RegisterStatus.initial,
    this.name = '',
    this.username = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.dob = '',
    this.error,
  });

  RegisterState copyWith({
    RegisterStatus? status,
    String? name,
    String? username,
    String? email,
    String? password,
    String? confirmPassword,
    String? dob,
    String? error,
  }) {
    return RegisterState(
      status: status ?? this.status,
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      dob: dob ?? this.dob,
      error: error ?? this.error,
    );
  }
}
