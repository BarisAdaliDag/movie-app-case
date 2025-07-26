import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movieapp/core/constants/app_assets.dart';
import 'package:movieapp/core/theme/app_colors.dart';
import 'package:movieapp/core/theme/text_styles.dart';

class PaywallSelectionContainer extends StatelessWidget {
  const PaywallSelectionContainer({
    super.key,
    required this.index,
    required this.discountPercentage,
    required this.originaljetons,
    required this.currentjetons,
    required this.price,
    this.isSelected = false,
    required this.onTap,
  });
  final int index;
  final String discountPercentage;
  final String originaljetons;
  final String currentjetons;
  final String price;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Image.asset(
            isSelected ? AppAssets.paywallSelected : AppAssets.paywallUnselected,
            fit: BoxFit.cover,
            width: 110,
            height: 230,
          ),
          // Buraya text'leri ekleyebilirsiniz
          Positioned(top: 2, left: 40, child: Text('+$discountPercentage', style: AppTextStyles.bodySmall.copyWith())),
          Positioned(
            top: 60,
            left: 0,
            child: SizedBox(
              width: 110,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    originaljetons,
                    style: AppTextStyles.body15MediumCircular.copyWith(decoration: TextDecoration.lineThrough),
                  ),
                  Gap(4),
                  Text(
                    currentjetons,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      color: AppColors.textPrimary,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      height: 1,
                    ),
                  ),
                  Gap(4),
                  Text('Jeton', style: AppTextStyles.body15MediumCircular.copyWith()),
                  Gap(40),
                  Text(
                    '₺$price',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      height: 1,
                    ),
                  ),
                  Text('Başına haftalık', style: AppTextStyles.bodySmall.copyWith()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
