import 'package:injectable/injectable.dart';
import '../core/services/api_service.dart';
import '../models/user.dart';
import '../core/constants/api_endpoints.dart';

@injectable
class AuthDatasource {
  var api = ApiService();

  Future<UserModel?> signIn(String email, String password) async {
    var res = await api.post(ApiEndpoints.login, {
      'email': email,
      'password': password,
    });
    if (res.isSuccess) {
      var user = UserModel.fromJson(res.body['data']);
      return user;
    }
    return null;
  }

  Future<void> register(String email, String password) async {}
}
