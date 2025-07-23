import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/core/enum/svg_enum.dart';
import 'package:movieapp/core/extension/padding_extension.dart';
import 'package:movieapp/core/theme/app_colors.dart';
import 'package:movieapp/core/theme/text_styles.dart';
import 'package:movieapp/core/utils/snackbar_helper.dart';
import 'package:movieapp/core/widgets/svg_widget.dart';
import 'package:movieapp/features/data/cubit/auth_cubit.dart';
import 'package:movieapp/features/data/cubit/auth_state.dart';
import 'package:movieapp/features/presentation/photo_upload/view/photo_upload_page.dart';
import 'package:movieapp/features/presentation/register/cubit/register_cubit.dart';
import 'package:movieapp/features/presentation/register/cubit/register_state.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import 'package:gap/gap.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => RegisterCubit(), child: _RegisterPageView());
  }
}

class _RegisterPageView extends StatefulWidget {
  const _RegisterPageView();

  @override
  State<_RegisterPageView> createState() => _RegisterPageViewState();
}

class _RegisterPageViewState extends State<_RegisterPageView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _register(BuildContext context) {
    final formCubit = context.read<RegisterCubit>();
    final authCubit = context.read<AuthCubit>();

    if (_formKey.currentState!.validate()) {
      final formData = formCubit.getFormData();
      authCubit.register(formData['email']!, formData['name']!, formData['password']!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            padding: const EdgeInsets.all(40),
            child: BlocBuilder<RegisterCubit, RegisterFormState>(
              builder: (context, formState) {
                final formCubit = context.read<RegisterCubit>();

                return Form(
                  key: _formKey,
                  onChanged: () => formCubit.updateFormValidity(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Gap(10.h), // Header
                      Center(
                        child: Column(
                          children: [
                            const SizedBox(height: 24),
                            Center(child: const Text('Hoşgeldiniz', style: AppTextStyles.bodyLarge)),
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

                      // Name Field
                      CustomTextField(
                        hint: 'Ad Soyad',
                        controller: formCubit.nameController,
                        keyboardType: TextInputType.name,
                        validator: formCubit.validateName,
                        prefixIcon: SvgWidget(svgPath: SvgEnum.addUser.svgPath, color: AppColors.white).allPadding(12),
                      ),

                      const SizedBox(height: 14),

                      // Email Field
                      CustomTextField(
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
                        onChanged: formCubit.onPasswordChanged,
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

                      const SizedBox(height: 14),

                      // Confirm Password Field
                      CustomTextField(
                        hint: 'Şifre Tekrar',
                        controller: formCubit.confirmPasswordController,
                        obscureText: formState.obscureConfirmPassword,
                        validator: formCubit.validateConfirmPassword,
                        prefixIcon: SvgWidget(svgPath: SvgEnum.unlock.svgPath, color: AppColors.white).allPadding(12),
                      ),

                      const SizedBox(height: 16),

                      // Terms and Conditions
                      Wrap(
                        children: [
                          Text(
                            'Kullanıcı sözleşmesini ',
                            style: AppTextStyles.bodyMedium.copyWith(fontSize: 12, color: AppColors.textSecondary),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Terms page navigation
                            },
                            child: Text(
                              'okudum ve kabul ediyorum.',
                              style: AppTextStyles.bodyMedium.copyWith(
                                decoration: TextDecoration.underline,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Text(
                            'Bu sözleşmeyi okuyarak devam ediniz lütfen.',
                            style: AppTextStyles.bodyMedium.copyWith(fontSize: 12, color: AppColors.textSecondary),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // Register Button
                      BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, authState) {
                          return CustomButton(
                            text: 'Şimdi Kaydol',
                            onPressed:
                                () => _register(
                                  context,
                                ), //formState.isValid && formState.acceptTerms ? () => _register(context) : null,
                            isLoading: authState.isLoading,
                          );
                        },
                      ),

                      const SizedBox(height: 24),

                      // Social Login Buttons
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
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // Login Link
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Zaten bir hesabın var mı? ", style: TextStyle(color: AppColors.textSecondary)),
                            GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: const Text('Giriş Yap!', style: AppTextStyles.bodyMedium),
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
