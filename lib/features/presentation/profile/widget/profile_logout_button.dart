import 'package:flutter/material.dart';
import 'package:movieapp/core/constants/app_constants.dart';
import 'package:movieapp/core/theme/app_colors.dart';
import 'package:movieapp/core/theme/text_styles.dart';
import 'package:movieapp/features/presentation/profile/widget/profile_logout_dialog.dart';

class ProfileLogoutButton extends StatelessWidget {
  const ProfileLogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => ProfileLogoutDialog.show(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(AppConstants.logout, style: AppTextStyles.buttonText.copyWith(color: AppColors.white)),
      ),
    );
  }
}
