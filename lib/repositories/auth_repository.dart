import '../models/user.dart';

abstract class AuthRepository {
  Future<UserModel?> signIn(String email, String password);
  Future<UserModel?> signInWithGoogle();
  Future<void> register(String email, String password);
}
