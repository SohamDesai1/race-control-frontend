class UserModel {
  int? id;
  DateTime? createdAt;
  String? name;
  String? username;
  String? email;
  String? phone;
  String? hashedPassword;
  String? gender;
  String? dob;
  String? imageUrl;
  String? token;
  String? refreshToken;
  String? authProvider;

  UserModel(
      {this.id,
      this.name,
      this.username,
      this.email,
      this.phone,
      this.hashedPassword,
      this.imageUrl,
      this.token,
      this.refreshToken,
      this.createdAt,
      this.dob,
      this.gender,
      this.authProvider});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final userJson = (json['data']['user'] as List).isNotEmpty
        ? json['data']
        : {};

    return UserModel(
        id: userJson['user'][0]['id'],
        name: userJson['user'][0]['name'] ?? '',
        username: userJson['user'][0]['username'] ?? '',
        email: userJson['user'][0]['email'] ?? '',
        phone: userJson['user'][0]['phone'] ?? '',
        hashedPassword: userJson['user'][0]['hashed_password'] ?? '',
        imageUrl: userJson['user'][0]['imageUrl'] ?? '',
        token: json['data']['acces_token'] ?? '',
        refreshToken: json['data']['refresh_token'] ?? '',
        createdAt: userJson['user'][0]['created_at'] != null
            ? DateTime.parse(userJson['user'][0]['created_at'])
            : null,
        dob: userJson['user'][0]['dob'] ?? '',
        gender: userJson['user'][0]['gender'] ?? '',
        authProvider: userJson['user'][0]['auth_provider'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'phone': phone,
      'hashedPassword': hashedPassword,
      'imageUrl': imageUrl,
      'token': token,
      'refreshToken': refreshToken,
      'createdAt': createdAt,
      'dob': dob,
      'gender': gender,
      'authProvider': authProvider,
    };
  }
}
