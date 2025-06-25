class UserModel {
  String? id;
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

  UserModel({
    this.id,
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
    this.authProvider
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['user']['id']?.toString() ?? '',
      name: json['user']['name'] ?? '',
      username: json['user']['username'] ?? '',
      email: json['user']['email'] ?? '',
      phone: json['user']['phone'] ?? '',
      hashedPassword: json['user']['hashed_password'] ?? '',
      imageUrl: json['user']['imageUrl'] ?? '',
      token: json['token'] ?? '',
      createdAt: json['user']['created_at'] != null
          ? DateTime.parse(json['user']['created_at'])
          : null,
      dob: json['user']['dob'] ?? '',
      gender: json['user']['gender'] ?? '',
      authProvider: json['user']['auth_provider'] ?? ''
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
      'createdAt': createdAt,
      'dob': dob,
      'gender': gender,
      'authProvider':authProvider
    };
  }
}
