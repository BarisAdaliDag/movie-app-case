import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/core/constants/app_constants.dart';
import 'package:movieapp/features/presentation/login/cubit/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginState());

  final TextEditingController emailController = TextEditingController(text: '');
  final TextEditingController passwordController = TextEditingController(text: '');

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }

  // Validation methods
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
    return null;
  }

  // Form validation
  bool validateForm() {
    return validateEmail(emailController.text) == null && validatePassword(passwordController.text) == null;
  }

  void resetForm() {
    emailController.clear();
    passwordController.clear();
    emit(const LoginState());
  }

  // Actions
  void togglePasswordVisibility() {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }

  void toggleRememberMe() {
    emit(state.copyWith(rememberMe: !state.rememberMe));
  }

  void updateFormValidity() {
    final isValid = validateForm();
    emit(state.copyWith(isValid: isValid));
  }

  // Get form data
  Map<String, String> getFormData() {
    return {'email': emailController.text.trim(), 'password': passwordController.text};
  }

  void clearForm() {
    emailController.clear();
    passwordController.clear();
    resetForm();
    emit(const LoginState());
  }

  void setTestCredentials() {
    emailController.text = '';
    passwordController.text = '';
    updateFormValidity();
  }
}
