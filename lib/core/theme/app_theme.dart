import 'package:flutter/material.dart';
import 'package:movieapp/core/theme/app_colors.dart';
import 'text_styles.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.primaryColor,
      scaffoldBackgroundColor: AppColors.scaffoldBackground,
      fontFamily: 'EuclidCircularA', // Global font family
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.headline2,
      ),
      cardTheme: const CardTheme(color: AppColors.cardBackground, elevation: 4, margin: EdgeInsets.all(8)),
      textTheme: const TextTheme(
        displayLarge: AppTextStyles.headline1,
        displayMedium: AppTextStyles.headline2,
        displaySmall: AppTextStyles.headline3,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondaryColor,
          foregroundColor: AppColors.textPrimary,
          textStyle: AppTextStyles.buttonText,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(style: IconButton.styleFrom(foregroundColor: AppColors.textPrimary)),
    );
  }
}
