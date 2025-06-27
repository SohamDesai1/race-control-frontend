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
      this.createdAt,
      this.dob,
      this.gender,
      this.authProvider});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final userJson = (json['user'] as List).isNotEmpty ? json['user'][0] : {};

    return UserModel(
        id: userJson['id'],
        name: userJson['name'] ?? '',
        username: userJson['username'] ?? '',
        email: userJson['email'] ?? '',
        phone: userJson['phone'] ?? '',
        hashedPassword: userJson['hashed_password'] ?? '',
        imageUrl: userJson['imageUrl'] ?? '',
        token: json['token'] ?? '',
        createdAt: userJson['created_at'] != null
            ? DateTime.parse(userJson['created_at'])
            : null,
        dob: userJson['dob'] ?? '',
        gender: userJson['gender'] ?? '',
        authProvider: userJson['auth_provider'] ?? '');
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
      'createdAt': createdAt,
      'dob': dob,
      'gender': gender,
      'authProvider': authProvider
    };
  }
}
