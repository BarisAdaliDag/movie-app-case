import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movieapp/core/enum/svg_enum.dart';
import 'package:movieapp/core/extension/padding_extension.dart';
import 'package:movieapp/core/theme/app_colors.dart';
import 'package:movieapp/core/theme/text_styles.dart';
import 'package:movieapp/core/widgets/svg_widget.dart';

class LimitedOfferBadge extends StatelessWidget {
  const LimitedOfferBadge({super.key, this.onTap});
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 105,
        height: 33,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(53), color: AppColors.primaryColor),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // İkon container
              Center(child: SvgWidget(svgPath: SvgEnum.gem.svgPath)),

              // İkon ile metin arası boşluk
              // Metin
              Text('Sınırlı Teklif', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ).onlyPadding(right: 20),
    );
  }
}
