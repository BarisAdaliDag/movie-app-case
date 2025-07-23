import 'package:flutter/material.dart';
import 'package:movieapp/core/theme/app_colors.dart';
import 'package:movieapp/core/theme/text_styles.dart';

class AuthNavigationLink extends StatelessWidget {
  final String text;
  final String linkText;
  final VoidCallback onPressed;

  const AuthNavigationLink({super.key, required this.text, required this.linkText, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(text, style: const TextStyle(color: AppColors.textSecondary)),
          GestureDetector(onTap: onPressed, child: Text(linkText, style: AppTextStyles.bodyMedium)),
        ],
      ),
    );
  }
}
