class ApiConstants {
  static const String baseUrl = 'https://caseapi.servicelabs.tech';
  static const String register = '/user/register';
  static const String login = '/user/login';
  static const String profile = '/user/profile';
  
  // Headers
  static const String contentType = 'Content-Type';
  static const String applicationJson = 'application/json';
  static const String authorization = 'Authorization';
  static const String bearer = 'Bearer';
  
  // Timeouts
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;
}