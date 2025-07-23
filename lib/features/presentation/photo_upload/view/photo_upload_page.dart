import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movieapp/core/getIt/get_It.dart';
import 'package:movieapp/core/utils/snackbar_helper.dart';
import 'package:movieapp/features/data/models/auth/user_model.dart';
import 'package:movieapp/features/data/cubit/auth_cubit.dart';
import 'package:movieapp/features/data/cubit/auth_state.dart';
import 'package:movieapp/features/presentation/photo_upload/cubit/photo_upload_cubit.dart';
import 'package:movieapp/features/presentation/photo_upload/cubit/photo_upload_state.dart';
import 'package:movieapp/features/presentation/profile/profile_page.dart';
import 'package:movieapp/core/widgets/custom_button.dart';
import 'package:permission_handler/permission_handler.dart';

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

  Future<void> _uploadPhoto(BuildContext context) async {
    final formCubit = context.read<PhotoUploadCubit>();
    final authCubit = context.read<AuthCubit>();
    final selectedImage = formCubit.getSelectedImage();

    if (selectedImage != null) {
      final success = await authCubit.uploadProfilePhoto(selectedImage);

      if (context.mounted) {
        if (authCubit.state.user?.photoUrl != null) {
          SnackBarHelper.showSuccess(context, 'Profil fotoğrafı başarıyla yüklendi!');
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const ProfilePage()));
        }
      }
    }
  }

  void _skipPhotoUpload(BuildContext context) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const ProfilePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: BlocBuilder<PhotoUploadCubit, PhotoUploadState>(
                builder: (context, formState) {
                  return BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, authState) {
                      return Column(
                        children: [
                          const SizedBox(height: 40),

                          // Header
                          const Text(
                            'Profil Fotoğrafı',
                            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Merhaba ${user.name}! Profil fotoğrafı eklemek ister misin?',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 16, color: Colors.grey),
                          ),

                          const SizedBox(height: 48),

                          // Photo Preview
                          GestureDetector(
                            onTap:
                                authState.isLoading
                                    ? null
                                    : () => context.read<PhotoUploadCubit>().pickImageFromGallery(),
                            child: Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(color: Colors.grey.shade300, width: 2),
                              ),
                              child:
                                  authState.isLoading
                                      ? const Center(child: CircularProgressIndicator())
                                      : formState.selectedImage != null
                                      ? ClipRRect(
                                        borderRadius: BorderRadius.circular(98),
                                        child: Image.file(formState.selectedImage!, fit: BoxFit.cover),
                                      )
                                      : Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.add_a_photo, size: 48, color: Colors.grey.shade600),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Fotoğraf Ekle',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey.shade600,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                            ),
                          ),

                          const SizedBox(height: 32),

                          // Info Text
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.blue.shade200),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.info_outline, color: Colors.blue.shade600, size: 20),
                                const SizedBox(width: 12),
                                const Expanded(
                                  child: Text(
                                    'Profil fotoğrafı eklemek isteğe bağlıdır. Daha sonra da ekleyebilirsin.',
                                    style: TextStyle(fontSize: 14, color: Colors.black87),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 48),

                          // Upload Button
                          if (formState.selectedImage != null) ...[
                            CustomButton(
                              text: 'Fotoğrafı Yükle',
                              onPressed: () => _uploadPhoto(context),
                              isLoading: authState.isLoading,
                              backgroundColor: Colors.green,
                            ),
                            const SizedBox(height: 16),
                          ],

                          // Skip Button
                          CustomButton(
                            text: formState.selectedImage != null ? 'Şimdilik Atla' : 'Devam Et',
                            onPressed: authState.isLoading ? null : () => _skipPhotoUpload(context),
                            isLoading: false,
                            backgroundColor: Colors.grey.shade600,
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
