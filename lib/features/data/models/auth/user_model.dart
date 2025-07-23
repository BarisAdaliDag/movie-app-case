import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String id;
  final String email;
  final String name;
  final String? token;
  final String? photoUrl;

  UserModel({required this.id, required this.email, required this.name, this.token, this.photoUrl});

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({String? token, String? photoUrl}) {
    return UserModel(id: id, email: email, name: name, token: token ?? this.token, photoUrl: photoUrl ?? this.photoUrl);
  }
}
