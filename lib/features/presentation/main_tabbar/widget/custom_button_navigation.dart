import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movieapp/core/constants/app_constants.dart';
import 'package:movieapp/core/enum/svg_enum.dart';
import 'package:movieapp/core/theme/app_colors.dart';
import 'package:movieapp/core/theme/text_styles.dart';
import 'package:movieapp/core/widgets/svg_widget.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigation({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 71,

          decoration: BoxDecoration(
            //  color: Color(0xff090909),
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                offset: const Offset(0, -4), // üstte shadow
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
          ),
          margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(
                icon: currentIndex == 0 ? Icons.home : Icons.home_outlined,
                label: AppConstants.home,
                index: 0,
                isSelected: currentIndex == 0,
              ),
              _buildNavItem(
                icon: currentIndex == 1 ? Icons.person : Icons.person_outline,
                label: AppConstants.profile,
                index: 1,
                isSelected: currentIndex == 1,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNavItem({required IconData icon, required String label, required int index, required bool isSelected}) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        width: 150,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.white20Opacity, width: 1),
          borderRadius: BorderRadius.circular(25),
          color: Colors.transparent,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.whiteLittleGrey, size: 24),
            const SizedBox(width: 8),
            Text(label, style: AppTextStyles.bottomTabBarStyle.copyWith()),
          ],
        ),
      ),
    );
  }
}
