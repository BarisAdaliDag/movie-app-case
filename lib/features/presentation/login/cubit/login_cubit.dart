import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/features/presentation/login/cubit/login_state.dart';

class LoginFormCubit extends Cubit<LoginFormState> {
  LoginFormCubit() : super(const LoginFormState());

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController(text: 'safa@nodelabs.com');
  final TextEditingController passwordController = TextEditingController(text: '123451');

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }

  // Validation methods
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
    return null;
  }

  // Form validation
  bool validateForm() {
    return formKey.currentState?.validate() ?? false;
  }

  void resetForm() {
    formKey.currentState?.reset();
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
    emit(const LoginFormState());
  }

  void setTestCredentials() {
    emailController.text = 'safa@nodelabs.com';
    passwordController.text = '123451';
    updateFormValidity();
  }
}
