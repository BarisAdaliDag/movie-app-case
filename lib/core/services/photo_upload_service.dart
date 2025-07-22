import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../utils/secure_storage.dart';

class PhotoUploadService {
  static Future<Map<String, dynamic>> uploadPhoto(File imageFile) async {
    try {
      final token = await SecureStorage.getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      var request = http.MultipartRequest('POST', Uri.parse('${ApiConstants.baseUrl}/user/upload_photo'));

      // Add headers
      request.headers.addAll({'accept': 'application/json', 'Authorization': 'Bearer $token'});

      // Add file
      var multipartFile = await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
        filename: 'profile_photo.${imageFile.path.split('.').last}',
      );

      request.files.add(multipartFile);

      print('🚀 Uploading photo: ${imageFile.path}');
      print('🔑 Using token: ${token.substring(0, 20)}...');

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print('📥 Upload response: ${response.statusCode}');
      print('📥 Upload body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = response.body;
        // Parse JSON response if needed
        return {'success': true, 'data': responseData};
      } else {
        throw Exception('Upload failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Photo upload error: $e');
      throw Exception('Failed to upload photo: $e');
    }
  }
}
