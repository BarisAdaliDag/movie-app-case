import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const TextStyle headline1 = TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.textPrimary);

  static const TextStyle headline2 = TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary);

  static const TextStyle headline3 = TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: AppColors.textPrimary);

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  static const TextStyle movieTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle movieInfo = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  static const TextStyle castInfo = TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textPrimary);

  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
}
