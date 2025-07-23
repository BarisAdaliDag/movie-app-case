import 'package:flutter/material.dart';
import 'package:movieapp/core/enum/svg_enum.dart';
import 'package:movieapp/core/extension/padding_extension.dart';
import 'package:movieapp/core/theme/app_colors.dart';
import 'package:movieapp/core/widgets/custom_text_field.dart';
import 'package:movieapp/core/widgets/svg_widget.dart';

class AuthPasswordField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final bool obscureText;
  final VoidCallback onToggleVisibility;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;

  const AuthPasswordField({
    super.key,
    required this.hint,
    required this.controller,
    required this.obscureText,
    required this.onToggleVisibility,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      hint: hint,
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      onChanged: onChanged,
      prefixIcon: SvgWidget(svgPath: SvgEnum.unlock.svgPath, color: AppColors.white).allPadding(12),
      suffixIcon:
          obscureText
              ? GestureDetector(
                onTap: onToggleVisibility,
                child: SvgWidget(svgPath: SvgEnum.hide.svgPath, color: AppColors.white).allPadding(12),
              )
              : IconButton(
                icon: Icon(obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                onPressed: onToggleVisibility,
              ),
    );
  }
}
