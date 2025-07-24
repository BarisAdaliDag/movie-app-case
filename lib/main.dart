import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/core/getIt/get_it.dart';
import 'package:movieapp/core/routes/navigation_helper.dart';
import 'package:movieapp/core/routes/routes.dart';
import 'package:movieapp/core/theme/app_theme.dart';
import 'package:movieapp/features/data/cubit/auth_cubit.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

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
      child: ResponsiveSizer(
        builder: (context, orientation, screenType) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: Routes.splash,
            navigatorKey: Navigation.navigationKey,
            onGenerateRoute: Routes.onGenerateRoutes,
            title: 'Movie App',
            theme: AppTheme.darkTheme,
          );
        },
      ),
    );
  }
}
