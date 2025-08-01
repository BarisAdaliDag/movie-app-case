import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/core/constants/app_constants.dart';
import 'package:movieapp/core/enum/svg_enum.dart';
import 'package:movieapp/core/extension/padding_extension.dart';
import 'package:movieapp/core/routes/navigation_helper.dart';
import 'package:movieapp/core/routes/routes.dart';
import 'package:movieapp/core/theme/app_colors.dart';
import 'package:movieapp/core/theme/text_styles.dart';
import 'package:movieapp/core/widgets/custom_button.dart';
import 'package:movieapp/core/widgets/custom_text_field.dart';
import 'package:movieapp/core/widgets/svg_widget.dart';
import 'package:movieapp/features/data/cubit/auth_cubit.dart';
import 'package:movieapp/features/data/cubit/auth_state.dart';
import 'package:movieapp/features/presentation/login/cubit/login_cubit.dart';
import 'package:movieapp/features/presentation/login/cubit/login_state.dart';
import 'package:movieapp/core/widgets/auth/auth_widgets.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => LoginCubit(), child: const _LoginPageView());
  }
}

class _LoginPageView extends StatefulWidget {
  const _LoginPageView();

  @override
  State<_LoginPageView> createState() => _LoginPageViewState();
}

class _LoginPageViewState extends State<_LoginPageView> with AuthFormMixin {
  void _login(BuildContext context) {
    final formCubit = context.read<LoginCubit>();
    final authCubit = context.read<AuthCubit>();

    handleFormSubmission(() {
      final formData = formCubit.getFormData();
      authCubit.login(formData['email']!, formData['password']!);
    });
  }

  void _onAuthenticated(BuildContext context, AuthState state) {
    Navigation.pushReplacementNamed(root: Routes.main);
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      child: AuthBlocListener(
        onAuthenticated: _onAuthenticated,
        child: BlocBuilder<LoginCubit, LoginState>(
          builder: (context, formState) {
            final formCubit = context.read<LoginCubit>();

            return Form(
              key: formKey,
              onChanged: () => formCubit.updateFormValidity(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),

                  // Header
                  AuthHeader(
                    title: AppConstants.welcome,
                    subtitle: AppConstants.welcomeSubtitle,
                    titleStyle: AppTextStyles.headline3,
                  ),

                  const SizedBox(height: 40),

                  // Email Field
                  CustomTextField(
                    hint: AppConstants.email,
                    controller: formCubit.emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: formCubit.validateEmail,
                    prefixIcon: SvgWidget(svgPath: SvgEnum.message.svgPath, color: AppColors.white).allPadding(12),
                  ),

                  const SizedBox(height: 14),

                  // Password Field
                  AuthPasswordField(
                    hint: AppConstants.password,
                    controller: formCubit.passwordController,
                    obscureText: formState.obscurePassword,
                    textInputAction: TextInputAction.done,
                    validator: formCubit.validatePassword,
                    onToggleVisibility: () => formCubit.togglePasswordVisibility(),
                  ),

                  const SizedBox(height: 16),

                  // Forgot Password
                  Row(
                    children: [
                      Text(
                        AppConstants.forgotPassword,
                        style: AppTextStyles.bodyMedium.copyWith(decoration: TextDecoration.underline),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Login Button
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, authState) {
                      return CustomButton(
                        text: AppConstants.login,
                        onPressed: () => _login(context),
                        isLoading: authState.isLoading,
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // Social Login Buttons
                  const SocialLoginButtons(),

                  const SizedBox(height: 32),

                  // Register Link
                  AuthNavigationLink(
                    text: AppConstants.noAccount,
                    linkText: AppConstants.registerLink,
                    onPressed: () {
                      Navigation.pushNamed(root: Routes.register);
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
