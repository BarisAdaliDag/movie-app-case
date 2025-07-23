import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/core/utils/snackbar_helper.dart';
import 'package:movieapp/features/data/cubit/auth_cubit.dart';
import 'package:movieapp/features/data/cubit/auth_state.dart';
import 'package:movieapp/features/presentation/login/cubit/login_cubit.dart';
import 'package:movieapp/features/presentation/login/cubit/login_state.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../profile/profile_page.dart';
import '../../register/view/register_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _LoginPageView();
  }
}

class _LoginPageView extends StatelessWidget {
  const _LoginPageView();

  void _login(BuildContext context) {
    final formCubit = context.read<LoginCubit>();
    final authCubit = context.read<AuthCubit>();

    if (formCubit.validateForm()) {
      final formData = formCubit.getFormData();
      authCubit.login(formData['email']!, formData['password']!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, authState) {
          if (authState.isAuthenticated && authState.user != null) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const ProfilePage()));
          }

          if (authState.errorMessage != null) {
            SnackBarHelper.showError(context, authState.errorMessage!);
            context.read<AuthCubit>().clearError();
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: BlocBuilder<LoginCubit, LoginState>(
              builder: (context, formState) {
                final formCubit = context.read<LoginCubit>();

                return Form(
                  onChanged: () => formCubit.updateFormValidity(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),

                      // Header
                      Center(
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(Icons.movie, size: 64, color: Colors.blue),
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'Welcome Back!',
                              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Sign in to continue to Movie App',
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 48),

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
                        suffixIcon: IconButton(
                          icon: Icon(
                            formState.obscurePassword ? Icons.visibility_off : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: () => formCubit.togglePasswordVisibility(),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Remember Me
                      Row(
                        children: [
                          Checkbox(value: formState.rememberMe, onChanged: (_) => formCubit.toggleRememberMe()),
                          const Text('Remember me', style: TextStyle(color: Colors.grey)),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // Login Button
                      BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, authState) {
                          return CustomButton(
                            text: 'Sign In',
                            onPressed: formState.isValid ? () => _login(context) : null,
                            isLoading: authState.isLoading,
                          );
                        },
                      ),

                      const SizedBox(height: 24),

                      // Test Account Info
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  '🧪 Test Account',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.orange),
                                ),
                                const Spacer(),
                                TextButton(
                                  onPressed: () => formCubit.setTestCredentials(),
                                  child: const Text('Use Test Data'),
                                ),
                              ],
                            ),
                            const Text('Email: safa@nodelabs.com', style: TextStyle(fontSize: 13, color: Colors.grey)),
                            const Text('Password: 123451', style: TextStyle(fontSize: 13, color: Colors.grey)),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Register Link
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an account? ", style: TextStyle(color: Colors.grey)),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RegisterPage()));
                              },
                              child: const Text(
                                'Sign Up',
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
}
