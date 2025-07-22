abstract class Failure {
  final String errorMessage;

  Failure({required this.errorMessage});

  @override
  String toString() => errorMessage;
}

class AuthFailure extends Failure {
  AuthFailure({required super.errorMessage});

  // Factory constructors for common errors
  factory AuthFailure.invalidCredentials() => AuthFailure(errorMessage: 'Invalid email or password. Please try again.');

  factory AuthFailure.userExists() =>
      AuthFailure(errorMessage: 'This email address is already registered. Try logging in.');

  factory AuthFailure.userNotFound() => AuthFailure(errorMessage: 'User not found. Please try signing up.');

  factory AuthFailure.tokenExpired() => AuthFailure(errorMessage: 'Your session has expired. Please log in again.');

  factory AuthFailure.serverError() => AuthFailure(errorMessage: 'A server error occurred. Please try again later.');

  factory AuthFailure.networkError() => AuthFailure(errorMessage: 'No internet connection. Please check your network.');

  factory AuthFailure.unknown(String message) =>
      AuthFailure(errorMessage: message.isEmpty ? 'An unknown error occurred.' : message);
}
