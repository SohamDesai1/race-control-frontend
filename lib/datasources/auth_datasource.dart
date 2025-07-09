import 'package:frontend/core/constants/api_routes.dart';
import 'package:injectable/injectable.dart';
import '../core/services/api_service.dart';
import '../models/user.dart';

@injectable
class AuthDatasource {
  var api = ApiService();

  Future<UserModel?> signIn(String email, String password) async {
    var res = await api.post(ApiRoutes.login, {
      'email': email,
      'password': password,
    });
    if (res.isSuccess) {
      var user = UserModel.fromJson(res.body);
      return user;
    }
    return null;
  }

  Future<UserModel?> register(String email, String password, String name,
      String dob, String username) async {
    var body = {
      "name": name,
      "username": username,
      "email": email,
      "dob": dob,
      "password": password,
    };
    var res = await api.post(ApiRoutes.register, body);
    if (res.isSuccess) {
      var user = UserModel.fromJson(res.body);
      return user;
    }
    return null;
  }
}
