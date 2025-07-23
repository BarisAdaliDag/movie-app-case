import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/features/presentation/cubit/auth_cubit.dart';
import 'package:movieapp/features/presentation/cubit/auth_state.dart';
import 'package:movieapp/features/presentation/pages/photo_upload_page.dart';
import '../widgets/loading_widget.dart';
import 'login_page.dart';
import 'profile_page.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (!state.isLoading) {
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
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.movie, size: 120, color: Colors.white),
                  SizedBox(height: 24),
                  Text('Movie App', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                  SizedBox(height: 48),
                  LoadingWidget(message: 'Initializing...'),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
