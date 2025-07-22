import 'package:movieapp/features/auth/data/models/user_model.dart';

class AuthState {
  final bool isLoading;
  final UserModel? user;
  final String? errorMessage;
  final bool isAuthenticated;

  const AuthState({this.isLoading = false, this.user, this.errorMessage, this.isAuthenticated = false});

  AuthState copyWith({bool? isLoading, UserModel? user, String? errorMessage, bool? isAuthenticated}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      errorMessage: errorMessage,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}
