// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_upload_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PhotoUploadResponse _$PhotoUploadResponseFromJson(Map<String, dynamic> json) =>
    PhotoUploadResponse(
      id: json['_id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      photoUrl: json['photoUrl'] as String?,
    );

Map<String, dynamic> _$PhotoUploadResponseToJson(
  PhotoUploadResponse instance,
) => <String, dynamic>{
  '_id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'photoUrl': instance.photoUrl,
};
