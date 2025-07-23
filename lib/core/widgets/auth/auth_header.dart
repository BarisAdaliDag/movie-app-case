import 'package:flutter/material.dart';
import 'package:movieapp/core/extension/padding_extension.dart';
import 'package:movieapp/core/theme/text_styles.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final TextStyle? titleStyle;
  final double topSpacing;

  const AuthHeader({super.key, required this.title, required this.subtitle, this.titleStyle, this.topSpacing = 24});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: topSpacing),
          Text(title, style: titleStyle ?? AppTextStyles.bodyLarge),
          const SizedBox(height: 8),
          Text(subtitle, textAlign: TextAlign.center, style: AppTextStyles.bodyMedium).symmetricPadding(horizontal: 12),
        ],
      ),
    );
  }
}
