import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:email_sender/src/emailsender_core.dart';
part 'settings_state.dart';

@injectable
class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsState());

  void sendFeedback(
    EmailSender emailSender,
    String subject,
    String message,
  ) async {
    try {
      var response = await emailSender.sendMessage(
        "sohamcodesstuff@gmail.com",
        "Feedback from Race Control",
        subject,
        message,
      );
      print(response);
      emit(state.copyWith(isLoading: false, error: null, success: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString(), success: false));
    }
  }
}
