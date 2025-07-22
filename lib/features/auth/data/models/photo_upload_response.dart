import 'package:json_annotation/json_annotation.dart';

part 'photo_upload_response.g.dart';

@JsonSerializable()
class PhotoUploadResponse {
  @JsonKey(name: '_id')
  final String id;
  final String name;
  final String email;
  final String? photoUrl;

  PhotoUploadResponse({required this.id, required this.name, required this.email, this.photoUrl});

  factory PhotoUploadResponse.fromJson(Map<String, dynamic> json) => _$PhotoUploadResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PhotoUploadResponseToJson(this);
}
