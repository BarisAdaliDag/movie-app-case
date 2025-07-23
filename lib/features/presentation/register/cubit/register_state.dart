class RegisterFormState {
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final bool acceptTerms;
  final bool isValid;
  final String? passwordStrength;

  const RegisterFormState({
    this.obscurePassword = true,
    this.obscureConfirmPassword = true,
    this.acceptTerms = false,
    this.isValid = false,
    this.passwordStrength,
  });

  RegisterFormState copyWith({
    bool? obscurePassword,
    bool? obscureConfirmPassword,
    bool? acceptTerms,
    bool? isValid,
    String? passwordStrength,
  }) {
    return RegisterFormState(
      obscurePassword: obscurePassword ?? this.obscurePassword,
      obscureConfirmPassword: obscureConfirmPassword ?? this.obscureConfirmPassword,
      acceptTerms: acceptTerms ?? this.acceptTerms,
      isValid: isValid ?? this.isValid,
      passwordStrength: passwordStrength ?? this.passwordStrength,
    );
  }
}
