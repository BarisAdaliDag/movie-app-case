import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/core/constants/app_constants.dart';
import 'package:movieapp/features/presentation/register/cubit/register_state.dart';

class RegisterCubit extends Cubit<RegisterFormState> {
  RegisterCubit() : super(const RegisterFormState());

  final TextEditingController emailController = TextEditingController(text: 'ada2@gmail.com');
  final TextEditingController nameController = TextEditingController(text: "ada");
  final TextEditingController passwordController = TextEditingController(text: "password123");
  final TextEditingController confirmPasswordController = TextEditingController(text: "password123");

  @override
  Future<void> close() {
    emailController.dispose();
    nameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    return super.close();
  }

  // Validation methods
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return AppConstants.nameRequired;
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return AppConstants.emailRequired;
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return AppConstants.enterValidEmail;
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppConstants.passwordRequired;
    }
    if (value.length < 6) {
      return AppConstants.passwordMinLength;
    }

    _updatePasswordStrength(value);
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppConstants.confirmPasswordRequired;
    }
    if (value != passwordController.text) {
      return AppConstants.passwordsDoNotMatch;
    }
    return null;
  }

  // Form validation
  bool validateForm() {
    return validateName(nameController.text) == null &&
        validateEmail(emailController.text) == null &&
        validatePassword(passwordController.text) == null &&
        validateConfirmPassword(confirmPasswordController.text) == null;
  }

  void resetForm() {
    emailController.clear();
    nameController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    emit(const RegisterFormState());
  }

  // Password strength
  void _updatePasswordStrength(String password) {
    String strength = AppConstants.weak;

    if (password.length >= 8) {
      bool hasUpper = password.contains(RegExp(r'[A-Z]'));
      bool hasLower = password.contains(RegExp(r'[a-z]'));
      bool hasDigit = password.contains(RegExp(r'[0-9]'));
      bool hasSpecial = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

      int score = [hasUpper, hasLower, hasDigit, hasSpecial].where((x) => x).length;

      switch (score) {
        case 4:
          strength = AppConstants.veryStrong;
          break;
        case 3:
          strength = AppConstants.strong;
          break;
        case 2:
          strength = AppConstants.medium;
          break;
        default:
          strength = AppConstants.weak;
      }
    }

    emit(state.copyWith(passwordStrength: strength));
  }

  // Actions
  void togglePasswordVisibility() {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }

  void toggleConfirmPasswordVisibility() {
    emit(state.copyWith(obscureConfirmPassword: !state.obscureConfirmPassword));
  }

  void toggleAcceptTerms() {
    emit(state.copyWith(acceptTerms: !state.acceptTerms));
    updateFormValidity();
  }

  void updateFormValidity() {
    final isValid = validateForm() && state.acceptTerms;
    emit(state.copyWith(isValid: isValid));
  }

  void onPasswordChanged(String value) {
    _updatePasswordStrength(value);
    updateFormValidity();
  }

  // Get form data
  Map<String, String> getFormData() {
    return {
      'email': emailController.text.trim(),
      'name': nameController.text.trim(),
      'password': passwordController.text,
    };
  }

  void clearForm() {
    emailController.clear();
    nameController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    emit(const RegisterFormState());
  }
}
