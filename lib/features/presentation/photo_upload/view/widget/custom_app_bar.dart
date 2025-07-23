import 'package:flutter/material.dart';
import 'package:movieapp/core/theme/app_colors.dart';
import 'package:movieapp/core/theme/text_styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final bool showBackButton;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onBackPressed,
    this.showBackButton = true,
    this.actions,
    this.backgroundColor = Colors.transparent,
    this.foregroundColor = AppColors.white,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      leading:
          showBackButton
              ? Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.white10Opacity,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppColors.white20Opacity, width: 1),
                ),
                child: IconButton(
                  onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
                  icon: Icon(Icons.arrow_back, color: foregroundColor, size: 20),
                ),
              )
              : null,
      title: Text(title, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600, color: foregroundColor)),
      centerTitle: true,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
