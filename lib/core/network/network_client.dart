import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../error/exceptions.dart';

class NetworkClient {
  final http.Client client;

  NetworkClient({required this.client});

  Future<Map<String, dynamic>> get({
    required String endpoint,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await client
          .get(
            Uri.parse('${ApiConstants.baseUrl}$endpoint'),
            headers: {
              ApiConstants.contentType: ApiConstants.applicationJson,
              ...?headers,
            },
          )
          .timeout(const Duration(milliseconds: ApiConstants.connectionTimeout));

      return _handleResponse(response);
    } on SocketException {
      throw const NetworkException('No internet connection');
    } on HttpException {
      throw const NetworkException('HTTP error occurred');
    } catch (e) {
      throw NetworkException('Network error: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> post({
    required String endpoint,
    required Map<String, dynamic> body,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await client
          .post(
            Uri.parse('${ApiConstants.baseUrl}$endpoint'),
            headers: {
              ApiConstants.contentType: ApiConstants.applicationJson,
              ...?headers,
            },
            body: json.encode(body),
          )
          .timeout(const Duration(milliseconds: ApiConstants.connectionTimeout));

      return _handleResponse(response);
    } on SocketException {
      throw const NetworkException('No internet connection');
    } on HttpException {
      throw const NetworkException('HTTP error occurred');
    } catch (e) {
      throw NetworkException('Network error: ${e.toString()}');
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        return json.decode(response.body);
      } catch (e) {
        throw const ServerException('Invalid response format');
      }
    } else if (response.statusCode == 401) {
      throw const AuthException('Unauthorized');
    } else if (response.statusCode == 400) {
      throw const ValidationException('Invalid request data');
    } else if (response.statusCode >= 500) {
      throw const ServerException('Server error');
    } else {
      throw ServerException('Request failed with status: ${response.statusCode}');
    }
  }
}