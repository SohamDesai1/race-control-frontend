class UserModel {
  String? id;
  DateTime? createdAt;
  String? name;
  String? email;
  String? phone;
  String? password;
  String? gender;
  String? dob;
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
    this.createdAt,
    this.dob,
    this.gender,
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
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      dob: json['dob'] ?? '',
      gender: json['gender'] ?? '',
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
      'createdAt': createdAt,
      'dob': dob,
      'gender': gender,
    };
  }
}
