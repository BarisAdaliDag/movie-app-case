import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:movieapp/core/enum/svg_enum.dart';
import 'package:movieapp/core/theme/app_colors.dart';
import 'package:movieapp/core/widgets/svg_widget.dart';

class SocialLoginButtons extends StatelessWidget {
  final VoidCallback? onGooglePressed;
  final VoidCallback? onApplePressed;
  final VoidCallback? onFacebookPressed;

  const SocialLoginButtons({super.key, this.onGooglePressed, this.onApplePressed, this.onFacebookPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _SocialButton(svgPath: SvgEnum.google.svgPath, onPressed: onGooglePressed),
        const Gap(8),
        _SocialButton(svgPath: SvgEnum.apple.svgPath, onPressed: onApplePressed),
        const Gap(8),
        _SocialButton(svgPath: SvgEnum.facebook.svgPath, onPressed: onFacebookPressed),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String svgPath;
  final VoidCallback? onPressed;

  const _SocialButton({required this.svgPath, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 60,
        width: 60,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.white10Opacity,
          border: Border.all(color: AppColors.white20Opacity),
          borderRadius: BorderRadius.circular(18),
        ),
        child: SvgWidget(svgPath: svgPath, color: AppColors.white),
      ),
    );
  }
}
