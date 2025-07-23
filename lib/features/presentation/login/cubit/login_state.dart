class LoginFormState {
  final bool obscurePassword;
  final bool rememberMe;
  final bool isValid;

  const LoginFormState({this.obscurePassword = true, this.rememberMe = false, this.isValid = false});

  LoginFormState copyWith({bool? obscurePassword, bool? rememberMe, bool? isValid}) {
    return LoginFormState(
      obscurePassword: obscurePassword ?? this.obscurePassword,
      rememberMe: rememberMe ?? this.rememberMe,
      isValid: isValid ?? this.isValid,
    );
  }
}
