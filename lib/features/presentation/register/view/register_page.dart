import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/core/constants/app_constants.dart';
import 'package:movieapp/core/enum/svg_enum.dart';
import 'package:movieapp/core/extension/padding_extension.dart';
import 'package:movieapp/core/routes/navigation_helper.dart';
import 'package:movieapp/core/theme/app_colors.dart';
import 'package:movieapp/core/theme/text_styles.dart';
import 'package:movieapp/core/widgets/custom_button.dart';
import 'package:movieapp/core/widgets/custom_text_field.dart';
import 'package:movieapp/core/widgets/svg_widget.dart';
import 'package:movieapp/features/data/cubit/auth_cubit.dart';
import 'package:movieapp/features/data/cubit/auth_state.dart';
import 'package:movieapp/features/presentation/photo_upload/view/photo_upload_page.dart';
import 'package:movieapp/features/presentation/register/cubit/register_cubit.dart';
import 'package:movieapp/features/presentation/register/cubit/register_state.dart';
import 'package:movieapp/core/widgets/auth/auth_widgets.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => RegisterCubit(), child: const _RegisterPageView());
  }
}

class _RegisterPageView extends StatefulWidget {
  const _RegisterPageView();

  @override
  State<_RegisterPageView> createState() => _RegisterPageViewState();
}

class _RegisterPageViewState extends State<_RegisterPageView> with AuthFormMixin {
  void _register(BuildContext context) {
    final formCubit = context.read<RegisterCubit>();
    final authCubit = context.read<AuthCubit>();

    handleFormSubmission(() {
      final formData = formCubit.getFormData();
      authCubit.register(formData['email']!, formData['name']!, formData['password']!);
    });
  }

  void _onAuthenticated(BuildContext context, AuthState state) {
    Navigation.pushAndRemoveAll(page: PhotoUploadPage(user: state.user!, showBackButton: false));
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      child: AuthBlocListener(
        onAuthenticated: _onAuthenticated,
        child: BlocBuilder<RegisterCubit, RegisterFormState>(
          builder: (context, formState) {
            final formCubit = context.read<RegisterCubit>();

            return Form(
              key: formKey,
              onChanged: () => formCubit.updateFormValidity(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  const AuthHeader(title: AppConstants.welcome, subtitle: AppConstants.welcomeSubtitle),

                  const SizedBox(height: 40),

                  // Name Field
                  CustomTextField(
                    hint: AppConstants.fullName,
                    controller: formCubit.nameController,
                    keyboardType: TextInputType.name,
                    validator: formCubit.validateName,
                    prefixIcon: SvgWidget(svgPath: SvgEnum.addUser.svgPath, color: AppColors.white).allPadding(12),
                  ),

                  const SizedBox(height: 14),

                  // Email Field
                  CustomTextField(
                    hint: AppConstants.email,
                    controller: formCubit.emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: formCubit.validateEmail,
                    prefixIcon: SvgWidget(svgPath: SvgEnum.message.svgPath, color: AppColors.white).allPadding(12),
                  ),

                  const SizedBox(height: 14),

                  // Password Field
                  AuthPasswordField(
                    hint: AppConstants.password,
                    controller: formCubit.passwordController,
                    obscureText: formState.obscurePassword,
                    validator: formCubit.validatePassword,
                    onChanged: formCubit.onPasswordChanged,
                    onToggleVisibility: () => formCubit.togglePasswordVisibility(),
                  ),

                  const SizedBox(height: 14),

                  // Confirm Password Field
                  CustomTextField(
                    hint: AppConstants.confirmPassword,
                    controller: formCubit.confirmPasswordController,
                    obscureText: formState.obscureConfirmPassword,
                    validator: formCubit.validateConfirmPassword,
                    prefixIcon: SvgWidget(svgPath: SvgEnum.unlock.svgPath, color: AppColors.white).allPadding(12),
                  ),

                  const SizedBox(height: 16),

                  // Terms and Conditions
                  _buildTermsSection(),

                  const SizedBox(height: 32),

                  // Register Button
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, authState) {
                      return CustomButton(
                        text: AppConstants.register,
                        onPressed: () => _register(context),
                        isLoading: authState.isLoading,
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // Social Login Buttons
                  const SocialLoginButtons(),

                  const SizedBox(height: 32),

                  // Login Link
                  AuthNavigationLink(
                    text: AppConstants.alreadyHaveAccount,
                    linkText: AppConstants.loginLink,
                    onPressed: () => Navigation.ofPop(),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTermsSection() {
    return Wrap(
      children: [
        Text(
          AppConstants.termsText1,
          style: AppTextStyles.bodyMedium.copyWith(fontSize: 12, color: AppColors.textSecondary),
        ),
        GestureDetector(
          onTap: () {
            // Terms page navigation
          },
          child: Text(
            AppConstants.termsText2,
            style: AppTextStyles.bodyMedium.copyWith(decoration: TextDecoration.underline, fontSize: 12),
          ),
        ),
        Text(
          AppConstants.termsText3,
          style: AppTextStyles.bodyMedium.copyWith(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
