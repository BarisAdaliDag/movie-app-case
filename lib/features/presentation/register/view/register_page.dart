import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/core/getIt/get_It.dart';
import 'package:movieapp/core/utils/snackbar_helper.dart';
import 'package:movieapp/features/presentation/photo_upload/view/photo_upload_page.dart';
import 'package:movieapp/features/presentation/register/cubit/register_cubit.dart';
import 'package:movieapp/features/presentation/register/cubit/register_state.dart';
import '../../../data/cubit/auth_cubit.dart';
import '../../../data/cubit/auth_state.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../profile/profile_page.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _RegisterPageView();
  }
}

class _RegisterPageView extends StatelessWidget {
  const _RegisterPageView();

  void _register(BuildContext context) {
    final formCubit = context.read<RegisterCubit>();
    final authCubit = context.read<AuthCubit>();

    if (formCubit.validateForm() && formCubit.state.acceptTerms) {
      final formData = formCubit.getFormData();
      authCubit.register(formData['email']!, formData['name']!, formData['password']!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, authState) {
          if (authState.isAuthenticated && authState.user != null) {
            Navigator.of(
              context,
            ).pushReplacement(MaterialPageRoute(builder: (_) => PhotoUploadPage(user: authState.user!)));
          }

          if (authState.errorMessage != null) {
            SnackBarHelper.showError(context, authState.errorMessage!);
            context.read<AuthCubit>().clearError();
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: BlocBuilder<RegisterCubit, RegisterFormState>(
              builder: (context, formState) {
                final formCubit = context.read<RegisterCubit>();

                return Form(
                  onChanged: () => formCubit.updateFormValidity(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back Button
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back),
                        padding: EdgeInsets.zero,
                      ),

                      const SizedBox(height: 24),

                      // Header
                      Center(
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(Icons.person_add, size: 64, color: Colors.green),
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'Create Account',
                              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Sign up to get started with Movie App',
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Name Field
                      CustomTextField(
                        label: 'Full Name',
                        hint: 'Enter your full name',
                        controller: formCubit.nameController,
                        validator: formCubit.validateName,
                      ),

                      const SizedBox(height: 24),

                      // Email Field
                      CustomTextField(
                        label: 'Email Address',
                        hint: 'Enter your email',
                        controller: formCubit.emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: formCubit.validateEmail,
                      ),

                      const SizedBox(height: 24),

                      // Password Field
                      CustomTextField(
                        label: 'Password',
                        hint: 'Enter your password',
                        controller: formCubit.passwordController,
                        obscureText: formState.obscurePassword,
                        validator: formCubit.validatePassword,
                        onChanged: formCubit.onPasswordChanged,
                        suffixIcon: IconButton(
                          icon: Icon(
                            formState.obscurePassword ? Icons.visibility_off : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: () => formCubit.togglePasswordVisibility(),
                        ),
                      ),

                      // Password Strength Indicator
                      if (formState.passwordStrength != null) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text('Password Strength: ', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                            Text(
                              formState.passwordStrength!,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: _getPasswordStrengthColor(formState.passwordStrength!),
                              ),
                            ),
                          ],
                        ),
                      ],

                      const SizedBox(height: 24),

                      // Confirm Password Field
                      CustomTextField(
                        label: 'Confirm Password',
                        hint: 'Confirm your password',
                        controller: formCubit.confirmPasswordController,
                        obscureText: formState.obscureConfirmPassword,
                        validator: formCubit.validateConfirmPassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            formState.obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: () => formCubit.toggleConfirmPasswordVisibility(),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Terms and Conditions
                      Row(
                        children: [
                          Checkbox(value: formState.acceptTerms, onChanged: (_) => formCubit.toggleAcceptTerms()),
                          const Expanded(
                            child: Text(
                              'I accept the Terms and Conditions and Privacy Policy',
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // Register Button
                      BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, authState) {
                          return CustomButton(
                            text: 'Create Account',
                            onPressed: formState.isValid ? () => _register(context) : null,
                            isLoading: authState.isLoading,
                            backgroundColor: Colors.green,
                          );
                        },
                      ),

                      const SizedBox(height: 32),

                      // Login Link
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Already have an account? ', style: TextStyle(color: Colors.grey)),
                            GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: const Text(
                                'Sign In',
                                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Color _getPasswordStrengthColor(String strength) {
    switch (strength) {
      case 'Very Strong':
        return Colors.green;
      case 'Strong':
        return Colors.lightGreen;
      case 'Medium':
        return Colors.orange;
      default:
        return Colors.red;
    }
  }
}
