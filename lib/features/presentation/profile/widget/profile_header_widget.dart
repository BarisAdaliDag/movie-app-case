import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:movieapp/core/extension/padding_extension.dart';
import 'package:movieapp/core/routes/navigation_helper.dart';
import 'package:movieapp/core/theme/app_colors.dart';
import 'package:movieapp/core/theme/text_styles.dart';
import 'package:movieapp/features/data/models/auth/user_model.dart';
import 'package:movieapp/features/presentation/photo_upload/view/photo_upload_page.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final UserModel user;

  const ProfileHeaderWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Avatar
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: AppColors.white20Opacity, width: 2),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child:
                user.photoUrl != null && user.photoUrl!.isNotEmpty
                    ? CachedNetworkImage(
                      imageUrl: user.photoUrl!,
                      fit: BoxFit.cover,
                      placeholder:
                          (context, url) => Container(
                            color: AppColors.surface,
                            child: Icon(Icons.person, size: 40, color: AppColors.textSecondary),
                          ),
                      errorWidget:
                          (context, url, error) => Container(
                            color: AppColors.surface,
                            child: Icon(Icons.person, size: 40, color: AppColors.textSecondary),
                          ),
                    )
                    : Container(
                      color: AppColors.surface,
                      child: Icon(Icons.person, size: 40, color: AppColors.textSecondary),
                    ),
          ),
        ),

        const SizedBox(width: 16),

        // User Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user.name, style: AppTextStyles.appBarStyle.copyWith(color: AppColors.white)),
              const SizedBox(height: 4),
              Text('ID: ${user.id}', style: AppTextStyles.bodyRegular.copyWith(color: AppColors.textSecondary)),
            ],
          ).onlyPadding(right: 10),
        ),

        // Photo Button
        GestureDetector(
          onTap: () => Navigation.push(page: PhotoUploadPage(user: user)),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(color: AppColors.primaryColor, borderRadius: BorderRadius.circular(8)),
            child: Text('Fotoğraf Ekle', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w700)),
          ),
        ),
      ],
    );
  }
}
