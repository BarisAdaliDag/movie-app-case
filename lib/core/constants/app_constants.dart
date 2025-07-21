class AppConstants {
  static const String appName = 'Movie App';
  static const String tokenKey = 'auth_token';
  static const String userDataKey = 'user_data';
  
  // Error Messages
  static const String networkError = 'Network error occurred';
  static const String serverError = 'Server error occurred';
  static const String invalidEmailFormat = 'Please enter a valid email';
  static const String passwordTooShort = 'Password must be at least 6 characters';
  static const String fieldsRequired = 'All fields are required';
  static const String loginFailed = 'Login failed. Please check your credentials.';
  static const String registrationFailed = 'Registration failed. Please try again.';
  static const String profileFetchFailed = 'Failed to fetch profile data.';
  
  // Validation
  static const int minPasswordLength = 6;
}