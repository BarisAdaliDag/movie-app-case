import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/core/routes/navigation_helper.dart';
import 'package:movieapp/core/routes/routes.dart';
import 'package:movieapp/core/theme/app_colors.dart';
import 'package:movieapp/core/theme/text_styles.dart';
import 'package:movieapp/features/data/cubit/auth_cubit.dart';

class ProfileLogoutDialog {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: Text('Çıkış Yap', style: AppTextStyles.headline3.copyWith(color: AppColors.white)),
          content: Text(
            'Çıkış yapmak istediğinize emin misiniz?',
            style: AppTextStyles.bodyRegular.copyWith(color: AppColors.white),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('İptal', style: AppTextStyles.bodyRegular.copyWith(color: AppColors.white)),
            ),
            TextButton(
              onPressed: () {
                Navigation.pushReplacementNamed(root: Routes.login);
                context.read<AuthCubit>().logout();
              },
              child: Text('Çıkış Yap', style: AppTextStyles.bodyRegular.copyWith(color: AppColors.primaryColor)),
            ),
          ],
        );
      },
    );
  }
}
