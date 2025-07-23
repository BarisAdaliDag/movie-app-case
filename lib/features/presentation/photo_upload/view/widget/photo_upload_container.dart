import 'dart:io';
import 'package:flutter/material.dart';
import 'package:movieapp/core/theme/app_colors.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PhotoUploadContainer extends StatelessWidget {
  final File? selectedImage;
  final VoidCallback? onTap;
  final bool isLoading;
  final double? width;
  final double? height;
  final Widget? placeholder;
  final BorderRadius? borderRadius;

  const PhotoUploadContainer({
    super.key,
    this.selectedImage,
    this.onTap,
    this.isLoading = false,
    this.width,
    this.height,
    this.placeholder,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final containerWidth = width ?? 40.w;
    final containerHeight = height ?? 40.w;
    final radius = borderRadius ?? BorderRadius.circular(20);

    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: containerWidth,
        height: containerHeight,
        decoration: BoxDecoration(
          color: AppColors.white10Opacity,
          borderRadius: radius,
          border: Border.all(color: AppColors.white20Opacity, width: 1),
        ),
        child: _buildContent(radius),
      ),
    );
  }

  Widget _buildContent(BorderRadius radius) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.white));
    }

    if (selectedImage != null) {
      return ClipRRect(borderRadius: BorderRadius.circular(19), child: Image.file(selectedImage!, fit: BoxFit.cover));
    }

    return placeholder ?? const Center(child: Icon(Icons.add, size: 48, color: AppColors.textSecondary));
  }
}
