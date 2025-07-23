import 'package:flutter/material.dart';
import 'package:movieapp/core/theme/app_colors.dart';
import 'package:movieapp/core/theme/text_styles.dart';

class PageHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final double spacing;
  final CrossAxisAlignment alignment;
  final TextAlign textAlign;

  const PageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.titleStyle,
    this.subtitleStyle,
    this.spacing = 8.0,
    this.alignment = CrossAxisAlignment.center,
    this.textAlign = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(title, textAlign: textAlign, style: titleStyle ?? AppTextStyles.headline3),
        if (subtitle != null) ...[
          SizedBox(height: spacing),
          Text(
            subtitle!,
            textAlign: textAlign,
            style: subtitleStyle ?? AppTextStyles.bodyMedium.copyWith(color: AppColors.white),
          ),
        ],
      ],
    );
  }
}
