import 'dart:io';
import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import '../error/exceptions.dart';

class NetworkClient {
  late final Dio _dio;

  NetworkClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {ApiConstants.contentType: ApiConstants.applicationJson},
      ),
    );

    // Simple logging
    _dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true, logPrint: (object) => print(object)));
  }

  Future<Map<String, dynamic>> post({
    required String endpoint,
    required Map<String, dynamic> body,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.post(endpoint, data: body, options: Options(headers: headers));

      return _handleResponse(response);
    } on SocketException {
      throw NetworkException(message: 'İnternet bağlantısı yok');
    } catch (e) {
      rethrow; // Let Dio exceptions pass through
    }
  }

  Future<Map<String, dynamic>> get({required String endpoint, Map<String, String>? headers}) async {
    try {
      final response = await _dio.get(endpoint, options: Options(headers: headers));

      return _handleResponse(response);
    } on SocketException {
      throw NetworkException(message: 'İnternet bağlantısı yok');
    } catch (e) {
      rethrow; // Let Dio exceptions pass through
    }
  }

  Map<String, dynamic> _handleResponse(Response response) {
    final data = response.data;

    if (data is Map<String, dynamic>) {
      // Check if response has error structure
      if (data.containsKey('response')) {
        final responseInfo = data['response'] as Map<String, dynamic>;
        final code = responseInfo['code'] as int;
        final message = responseInfo['message'] as String?;

        // If error code, throw exception
        if (code >= 400) {
          throw ApiException(message: message ?? 'API Error', code: message);
        }
      }

      return data;
    }

    throw ApiException(message: 'Invalid response format');
  }
}
