import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/core/constants/app_constants.dart';
import 'package:movieapp/core/getIt/get_it.dart';
import 'package:movieapp/core/routes/navigation_helper.dart';
import 'package:movieapp/core/routes/routes.dart';
import 'package:movieapp/core/theme/app_theme.dart';
import 'package:movieapp/features/data/cubit/auth_cubit.dart';
import 'package:movieapp/features/presentation/home/cubit/home_cubit.dart';
import 'package:movieapp/features/presentation/login/cubit/login_cubit.dart';
import 'package:movieapp/features/presentation/main_tabbar/cubit/main_tabbar_cubit.dart';
import 'package:movieapp/features/presentation/paywall/cubit/paywall_cubit.dart';
import 'package:movieapp/features/presentation/photo_upload/cubit/photo_upload_cubit.dart';
import 'package:movieapp/features/presentation/register/cubit/register_cubit.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<AuthCubit>()..checkAuthStatus()),
        BlocProvider(create: (context) => getIt<HomeCubit>()),
        BlocProvider(create: (context) => getIt<MainTabbarCubit>()),
        BlocProvider(create: (context) => getIt<LoginCubit>()),
        BlocProvider(create: (context) => getIt<RegisterCubit>()),
        BlocProvider(create: (context) => getIt<PhotoUploadCubit>()),
        BlocProvider(create: (context) => getIt<PaywallCubit>()),
      ],
      child: ResponsiveSizer(
        builder: (context, orientation, screenType) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: Routes.splash,
            navigatorKey: Navigation.navigationKey,
            onGenerateRoute: Routes.onGenerateRoutes,
            title: AppConstants.sinflix,
            theme: AppTheme.darkTheme,
          );
        },
      ),
    );
  }
}
