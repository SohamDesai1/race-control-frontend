import 'package:frontend/core/services/api_service.dart';

import '../repositories/auth_repository.dart';

class AuthDatasource extends AuthRepository {
  var api = ApiService();

  @override
  Future<void> signIn(String email, String password) async {}

  @override
  Future<void> signUp(String email, String password) async {}
}
