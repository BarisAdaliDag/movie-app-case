import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movieapp/core/getIt/get_It.dart';
import 'package:movieapp/core/theme/app_colors.dart';
import 'package:movieapp/core/theme/text_styles.dart';
import 'package:movieapp/core/utils/snackbar_helper.dart';
import 'package:movieapp/features/data/models/auth/user_model.dart';
import 'package:movieapp/features/data/cubit/auth_cubit.dart';
import 'package:movieapp/features/data/cubit/auth_state.dart';
import 'package:movieapp/features/presentation/photo_upload/cubit/photo_upload_cubit.dart';
import 'package:movieapp/features/presentation/photo_upload/cubit/photo_upload_state.dart';
import 'package:movieapp/features/presentation/profile/profile_page.dart';
import 'package:movieapp/core/widgets/custom_button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PhotoUploadPage extends StatelessWidget {
  final UserModel user;

  const PhotoUploadPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<AuthCubit>()),
        BlocProvider(create: (context) => PhotoUploadCubit(authCubit: getIt<AuthCubit>())),
      ],
      child: _PhotoUploadPageView(user: user),
    );
  }
}

class _PhotoUploadPageView extends StatelessWidget {
  final UserModel user;

  const _PhotoUploadPageView({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.white10Opacity,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.white20Opacity, width: 1),
          ),
          child: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back, color: AppColors.white, size: 20),
          ),
        ),
        title: Text('Profil Detayı', style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, authState) {
          if (authState.errorMessage != null) {
            SnackBarHelper.showError(context, authState.errorMessage!);
            context.read<AuthCubit>().clearError();
          }
        },
        child: BlocListener<PhotoUploadCubit, PhotoUploadState>(
          listener: (context, formState) {
            if (formState.imageError != null) {
              SnackBarHelper.showError(context, formState.imageError!);
              context.read<PhotoUploadCubit>().clearError();
            }
          },
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: BlocBuilder<PhotoUploadCubit, PhotoUploadState>(
                builder: (context, formState) {
                  return BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, authState) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 24),

                          // Title
                          Center(child: Text('Fotoğraflarınızı Yükleyin', style: AppTextStyles.headline3)),
                          const SizedBox(height: 8),

                          // Subtitle
                          Center(
                            child: Text(
                              'Resources out incentivize \nrelaxation floor loss cc.',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.white),
                            ),
                          ),

                          const SizedBox(height: 40),

                          // Photo Upload Area
                          Center(
                            child: GestureDetector(
                              onTap:
                                  authState.isLoading
                                      ? null
                                      : () => context.read<PhotoUploadCubit>().pickImageFromGallery(),
                              child: Container(
                                width: (40).w,
                                height: (40).w,
                                decoration: BoxDecoration(
                                  color: AppColors.white10Opacity,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: AppColors.white20Opacity, width: 1),
                                ),
                                child:
                                    authState.isLoading
                                        ? const Center(child: CircularProgressIndicator(color: AppColors.white))
                                        : formState.selectedImage != null
                                        ? ClipRRect(
                                          borderRadius: BorderRadius.circular(19),
                                          child: Image.file(formState.selectedImage!, fit: BoxFit.cover),
                                        )
                                        : const Center(
                                          child: Icon(Icons.add, size: 48, color: AppColors.textSecondary),
                                        ),
                              ),
                            ),
                          ),

                          const Spacer(),

                          // Continue Button
                          CustomButton(
                            text: 'Devam Et',
                            onPressed:
                                authState.isLoading
                                    ? null
                                    : () {
                                      if (formState.selectedImage != null) {
                                        context.read<PhotoUploadCubit>().uploadPhoto(context);
                                      } else {
                                        context.read<PhotoUploadCubit>().skipPhotoUpload(context);
                                      }
                                    },
                            isLoading: authState.isLoading,
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
