import '../models/user.dart';

abstract class AuthRepository {
  Future<void> signIn(String email, String password);
  Future<UserModel?> signInWithGoogle();
  Future<void> signUp(String email, String password);
}
