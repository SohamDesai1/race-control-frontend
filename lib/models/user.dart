class UserModel {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? password;
  String? imageUrl;
  String? token;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.password,
    this.imageUrl,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      password: json['password'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      token: json['token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'imageUrl': imageUrl,
      'token': token,
    };
  }
}
