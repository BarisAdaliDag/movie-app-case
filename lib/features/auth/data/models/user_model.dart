class UserModel {
  final String id;
  final String email;
  final String name;
  final String? token;

  UserModel({required this.id, required this.email, required this.name, this.token});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      token: json['token'] as String?, // nullable olabilir
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email, 'name': name, 'token': token};
  }

  UserModel copyWith({String? token}) {
    return UserModel(id: id, email: email, name: name, token: token ?? this.token);
  }
}
