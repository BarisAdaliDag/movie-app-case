import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/core/constants/app_assets.dart';
import 'package:movieapp/features/data/cubit/auth_cubit.dart';
import 'package:movieapp/features/data/cubit/auth_state.dart';
import 'package:movieapp/features/presentation/photo_upload/view/photo_upload_page.dart';
import '../../../core/widgets/loading_widget.dart';
import '../login/view/login_page.dart';
import '../profile/profile_page.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) async {
          if (!state.isLoading) {
            await Future.delayed(const Duration(seconds: 2));
            if (state.isAuthenticated && state.user != null) {
              Navigator.of(
                context,
              ).pushReplacement(MaterialPageRoute(builder: (_) => PhotoUploadPage(user: state.user!)));
            } else {
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginPage()));
            }
          }
        },
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            return Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(image: AssetImage(AppAssets.splashImage), fit: BoxFit.cover),
              ),
            );
          },
        ),
      ),
    );
  }
}
