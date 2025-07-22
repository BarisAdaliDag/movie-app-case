import 'package:dio/dio.dart';
import 'package:movieapp/core/error/failures.dart';
import 'exceptions.dart';

class ErrorHandler {
  static AuthFailure handleError(dynamic error) {
    print('🔴 Error: $error');

    if (error is DioException) {
      return _handleDioError(error);
    } else if (error is ApiException) {
      return _handleApiError(error);
    } else if (error is NetworkException) {
      return AuthFailure.networkError();
    } else {
      return AuthFailure.unknown(error.toString());
    }
  }

  static AuthFailure _handleDioError(DioException error) {
    // Network errors
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError) {
      return AuthFailure.networkError();
    }

    // API response errors
    if (error.response != null) {
      final responseData = error.response!.data;

      if (responseData is Map<String, dynamic>) {
        final response = responseData['response'];
        if (response is Map<String, dynamic>) {
          final message = response['message'] as String?;

          // Handle specific error codes
          switch (message) {
            case 'INVALID_CREDENTIALS':
              return AuthFailure.invalidCredentials();
            case 'USER_EXISTS':
              return AuthFailure.userExists();
            case 'USER_NOT_FOUND':
              return AuthFailure.userNotFound();
            case 'TOKEN_EXPIRED':
              return AuthFailure.tokenExpired();
            default:
              return AuthFailure.serverError();
          }
        }
      }
    }

    return AuthFailure.serverError();
  }

  static AuthFailure _handleApiError(ApiException error) {
    switch (error.code) {
      case 'INVALID_CREDENTIALS':
        return AuthFailure.invalidCredentials();
      case 'USER_EXISTS':
        return AuthFailure.userExists();
      case 'USER_NOT_FOUND':
        return AuthFailure.userNotFound();
      case 'TOKEN_EXPIRED':
        return AuthFailure.tokenExpired();
      default:
        return AuthFailure.unknown(error.message);
    }
  }
}
