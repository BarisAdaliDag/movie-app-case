import 'package:flutter/material.dart';
import 'package:movieapp/features/presentation/splash/splash_page.dart';
import 'package:movieapp/features/presentation/login/view/login_page.dart';
import 'package:movieapp/features/presentation/register/view/register_page.dart';
import 'package:movieapp/features/presentation/profile/profile_page.dart';
import 'package:movieapp/features/presentation/photo_upload/view/photo_upload_page.dart';
import 'package:movieapp/features/data/models/auth/user_model.dart';

final class Routes {
  Routes._();

  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const profile = '/profile';
  static const photoUpload = '/photo-upload';

  static Route<dynamic> onGenerateRoutes(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case splash:
        return _materialPageRoute(const SplashPage());
      case login:
        return _materialPageRoute(const LoginPage());
      case register:
        return _materialPageRoute(const RegisterPage());
      case profile:
        return _materialPageRoute(const ProfilePage());
      case photoUpload:
        final args = routeSettings.arguments as Map<String, dynamic>?;
        return _materialPageRoute(
          PhotoUploadPage(user: args?['user'] as UserModel, showBackButton: args?['showBackButton'] as bool? ?? true),
        );
      default:
        return _materialPageRoute(const Scaffold(body: Center(child: Text('Page not found'))));
    }
  }

  static MaterialPageRoute<dynamic> _materialPageRoute(Widget page) => MaterialPageRoute(builder: (context) => page);
}
