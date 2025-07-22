import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/core/getIt/get_it.dart';
import 'package:movieapp/features/auth/presentation/bloc/auth_cubit.dart';
import 'features/auth/presentation/pages/splash_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setup(); // GetIt setup
  runApp(const MovieApp());
}

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthCubit>()..checkAuthStatus(),
      child: MaterialApp(
        title: 'Movie App',
        theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
        home: const SplashPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
