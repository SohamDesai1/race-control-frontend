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
  bool? isProfileComplete;
  UserModel({
    this.id,
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
    this.authProvider,
    this.isProfileComplete,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final userJson = json['data']?['user'] as Map<String, dynamic>? ?? {};
    final dataJson = json['data'] as Map<String, dynamic>? ?? {};

    return UserModel(
      id: userJson['id'],
      name: userJson['name'] ?? '',
      username: userJson['username'] ?? '',
      email: userJson['email'] ?? '',
      phone: userJson['phone'] ?? '',
      hashedPassword: userJson['hashed_password'] ?? '',
      imageUrl: userJson['imageUrl'] ?? '',
      token: dataJson['access_token'] ?? '',
      refreshToken: dataJson['refresh_token'] ?? '',
      createdAt: userJson['created_at'] != null
          ? DateTime.parse(userJson['created_at'])
          : null,
      dob: userJson['dob'] ?? '',
      gender: userJson['gender'] ?? '',
      authProvider: userJson['auth_provider'] ?? '',
      isProfileComplete: userJson['is_profile_complete'] ?? false,
    );
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
      'isProfileComplete': isProfileComplete,
    };
  }
}
