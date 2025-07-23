import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/features/presentation/register/cubit/register_state.dart';

class RegisterFormCubit extends Cubit<RegisterFormState> {
  RegisterFormCubit() : super(const RegisterFormState());

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

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
      return 'Name is required';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    _updatePasswordStrength(value);
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirm password is required';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  // Form validation
  bool validateForm() {
    return formKey.currentState?.validate() ?? false;
  }

  void resetForm() {
    formKey.currentState?.reset();
  }

  // Password strength
  void _updatePasswordStrength(String password) {
    String strength = 'Weak';

    if (password.length >= 8) {
      bool hasUpper = password.contains(RegExp(r'[A-Z]'));
      bool hasLower = password.contains(RegExp(r'[a-z]'));
      bool hasDigit = password.contains(RegExp(r'[0-9]'));
      bool hasSpecial = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

      int score = [hasUpper, hasLower, hasDigit, hasSpecial].where((x) => x).length;

      switch (score) {
        case 4:
          strength = 'Very Strong';
          break;
        case 3:
          strength = 'Strong';
          break;
        case 2:
          strength = 'Medium';
          break;
        default:
          strength = 'Weak';
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
    resetForm();
    emit(const RegisterFormState());
  }
}
