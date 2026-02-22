part of 'settings_cubit.dart';

class SettingsState {
  final bool isLoading;
  final String? error;
  final String? subject;
  final String? message;
  final bool? success;
  SettingsState({
    this.subject,
    this.message,
    this.success = false,
    this.isLoading = false,
    this.error,
  });

  SettingsState copyWith({
    bool? isLoading,
    String? error,
    String? subject,
    String? message,
    bool? success,
  }) {
    return SettingsState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      subject: subject ?? this.subject,
      message: message ?? this.message,
      success: success ?? this.success,
    );
  }
}
