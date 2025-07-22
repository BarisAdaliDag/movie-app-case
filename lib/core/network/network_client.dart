import 'package:dio/dio.dart';
import '../constants/api_constants.dart';

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

    _dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true, logPrint: (object) => print(object)));
  }

  Future<Map<String, dynamic>> post({
    required String endpoint,
    required Map<String, dynamic> body,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.post(endpoint, data: body, options: Options(headers: headers));
      return response.data;
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  Future<Map<String, dynamic>> get({required String endpoint, Map<String, String>? headers}) async {
    try {
      final response = await _dio.get(endpoint, options: Options(headers: headers));
      return response.data;
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  Exception _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Connection timeout');
      case DioExceptionType.badResponse:
        return Exception(e.response?.data['message'] ?? 'Server error');
      default:
        return Exception('Network error occurred');
    }
  }
}
