import 'package:flutter/material.dart';
import 'package:movieapp/core/constants/app_assets.dart';
import 'package:movieapp/core/constants/app_constants.dart';
import 'package:movieapp/core/theme/app_colors.dart';
import 'package:movieapp/core/theme/text_styles.dart';

class BonusFeaturesCard extends StatelessWidget {
  const BonusFeaturesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        height: 175,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(AppAssets.paywallBonusBackground), fit: BoxFit.cover),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Title
              Text(
                AppConstants.bonusFeatures,
                style: AppTextStyles.body15MediumCircular.copyWith(color: AppColors.white),
              ),

              const SizedBox(height: 12),

              // Bonus Icons Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildBonusItem(title: AppConstants.premiumAccount, path: AppAssets.diamond),
                  _buildBonusItem(title: AppConstants.moreMatches, path: AppAssets.hearts),
                  _buildBonusItem(title: AppConstants.boost, path: AppAssets.arrowUp),
                  _buildBonusItem(title: AppConstants.moreLikes, path: AppAssets.heart),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBonusItem({required String title, required String path}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Icon container with radial gradient
        Image.asset(path, fit: BoxFit.contain, scale: 2),

        const SizedBox(height: 12),

        // Title
        Text(title, textAlign: TextAlign.center, style: AppTextStyles.bodySmall.copyWith(color: AppColors.white)),
      ],
    );
  }
}
