class LoginState {
  final bool obscurePassword;
  final bool rememberMe;
  final bool isValid;

  const LoginState({this.obscurePassword = true, this.rememberMe = false, this.isValid = false});

  LoginState copyWith({bool? obscurePassword, bool? rememberMe, bool? isValid}) {
    return LoginState(
      obscurePassword: obscurePassword ?? this.obscurePassword,
      rememberMe: rememberMe ?? this.rememberMe,
      isValid: isValid ?? this.isValid,
    );
  }
}
