import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:movieapp/core/theme/app_colors.dart';
import 'package:movieapp/core/theme/text_styles.dart';

// Bottom sheet içeriği örneği
class ExampleBottomSheetContent extends StatelessWidget {
  const ExampleBottomSheetContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          const SizedBox(height: 24),

          Text('Bottom Sheet Title', style: AppTextStyles.headline2.copyWith(color: AppColors.white)),

          const SizedBox(height: 16),

          Text(
            'Bu özel bottom sheet tasarımında üst ve alt kısımda gradient efektleri bulunuyor.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyRegular.copyWith(color: AppColors.textSecondary),
          ),

          const SizedBox(height: 32),

          // Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    side: BorderSide(color: AppColors.primaryColor, width: 1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('İptal', style: AppTextStyles.buttonText.copyWith(color: AppColors.primaryColor)),
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Action
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('Onayla', style: AppTextStyles.buttonText.copyWith(color: AppColors.white)),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
