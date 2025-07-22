import 'package:movieapp/features/auth/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({required super.id, required super.email, required super.name, super.token});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email, 'name': name, if (token != null) 'token': token};
  }

  @override
  UserModel copyWith({String? id, String? email, String? name, String? token}) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      token: token ?? this.token,
    );
  }
}
