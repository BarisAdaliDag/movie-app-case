import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movieapp/core/enum/svg_enum.dart';
import 'package:movieapp/core/extension/padding_extension.dart';
import 'package:movieapp/core/theme/app_colors.dart';
import 'package:movieapp/core/theme/text_styles.dart';
import 'package:movieapp/core/utils/snackbar_helper.dart';
import 'package:movieapp/core/widgets/svg_widget.dart';
import 'package:movieapp/features/data/cubit/auth_cubit.dart';
import 'package:movieapp/features/data/cubit/auth_state.dart';
import 'package:movieapp/features/presentation/login/cubit/login_cubit.dart';
import 'package:movieapp/features/presentation/login/cubit/login_state.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../profile/profile_page.dart';
import '../../register/view/register_page.dart';
import 'package:gap/gap.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => LoginCubit(), child: _LoginPageView());
  }
}

class _LoginPageView extends StatefulWidget {
  const _LoginPageView();

  @override
  State<_LoginPageView> createState() => _LoginPageViewState();
}

class _LoginPageViewState extends State<_LoginPageView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _login(BuildContext context) {
    final formCubit = context.read<LoginCubit>();
    final authCubit = context.read<AuthCubit>();

    if (_formKey.currentState!.validate()) {
      final formData = formCubit.getFormData();
      authCubit.login(formData['email']!, formData['password']!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  backgroundColor: Colors.white,
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
            padding: const EdgeInsets.all(40),
            child: BlocBuilder<LoginCubit, LoginState>(
              builder: (context, formState) {
                final formCubit = context.read<LoginCubit>();

                return Form(
                  key: _formKey,
                  onChanged: () => formCubit.updateFormValidity(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Gap(20.h), // Header
                      Center(
                        child: Column(
                          children: [
                            const SizedBox(height: 24),
                            Center(child: const Text('Merhabalar', style: AppTextStyles.headline3)),
                            const SizedBox(height: 8),
                            Center(
                              child: Text(
                                textAlign: TextAlign.center,
                                'Tempus varius a vitae interdum id tortor elementum tristique eleifend at.',
                                style: AppTextStyles.bodyMedium,
                              ).symmetricPadding(horizontal: 12),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Email Field
                      CustomTextField(
                        // label: 'Email Address',
                        hint: 'E-Posta',
                        controller: formCubit.emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: formCubit.validateEmail,
                        prefixIcon: SvgWidget(svgPath: SvgEnum.message.svgPath, color: AppColors.white).allPadding(12),
                      ),

                      const SizedBox(height: 14),

                      // Password Field
                      CustomTextField(
                        hint: 'Şifre',
                        controller: formCubit.passwordController,
                        obscureText: formState.obscurePassword,
                        validator: formCubit.validatePassword,
                        prefixIcon: SvgWidget(svgPath: SvgEnum.unlock.svgPath, color: AppColors.white).allPadding(12),
                        suffixIcon:
                            formState.obscurePassword
                                ? GestureDetector(
                                  onTap: () => formCubit.togglePasswordVisibility(),
                                  child: SvgWidget(
                                    svgPath: SvgEnum.hide.svgPath,
                                    color: AppColors.white,
                                  ).allPadding(12),
                                )
                                : IconButton(
                                  icon: Icon(
                                    formState.obscurePassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                  ),
                                  onPressed: () => formCubit.togglePasswordVisibility(),
                                ),
                      ),

                      const SizedBox(height: 16),

                      // Remember Me
                      Row(
                        children: [
                          Text(
                            'Şifremi unuttum',
                            style: AppTextStyles.bodyMedium.copyWith(decoration: TextDecoration.underline),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // Login Button
                      BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, authState) {
                          return CustomButton(
                            text: 'Giriş Yap',
                            onPressed: () => _login(context),
                            isLoading: authState.isLoading,
                          );
                        },
                      ),

                      const SizedBox(height: 24),

                      // Test Account Info
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 60,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.white10Opacity,
                              border: Border.all(color: AppColors.white20Opacity),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: SvgWidget(svgPath: SvgEnum.google.svgPath, color: AppColors.white),
                            // Icon(Icons.google, size: 24, color: AppColors.white),
                          ),
                          Gap(8),
                          Container(
                            height: 60,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.white10Opacity,
                              border: Border.all(color: AppColors.white20Opacity),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: SvgWidget(svgPath: SvgEnum.apple.svgPath, color: AppColors.white),
                            // Icon(Icons.google, size: 24, color: AppColors.white),
                          ),
                          Gap(8),
                          Container(
                            height: 60,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.white10Opacity,
                              border: Border.all(color: AppColors.white20Opacity),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: SvgWidget(svgPath: SvgEnum.facebook.svgPath, color: AppColors.white),
                            // Icon(Icons.google, size: 24, color: AppColors.white),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // Register Link
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Bir hesabın yok mu? ", style: TextStyle(color: AppColors.textSecondary)),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RegisterPage()));
                              },
                              child: const Text('Kayıt Ol!', style: AppTextStyles.bodyMedium),
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
