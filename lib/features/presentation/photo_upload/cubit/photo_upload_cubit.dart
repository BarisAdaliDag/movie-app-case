import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movieapp/core/routes/navigation_helper.dart';
import 'package:movieapp/core/routes/routes.dart';
import 'package:movieapp/core/utils/snackbar_helper.dart';
import 'package:movieapp/features/data/cubit/auth_cubit.dart';
import 'photo_upload_state.dart';

class PhotoUploadCubit extends Cubit<PhotoUploadState> {
  final ImagePicker _imagePicker = ImagePicker();
  final AuthCubit authCubit;

  PhotoUploadCubit({required this.authCubit}) : super(const PhotoUploadState());

  void clearError() {
    emit(state.copyWith(clearError: true));
  }

  void clearImage() {
    emit(state.copyWith(clearImage: true));
  }

  Future<void> pickImageFromGallery() async {
    try {
      emit(state.copyWith(isImagePickerOpen: true, clearError: true, isUploading: true));

      final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery, imageQuality: 80);

      if (image != null) {
        emit(state.copyWith(selectedImage: File(image.path), isImagePickerOpen: false, isUploading: false));
      } else {
        emit(state.copyWith(isImagePickerOpen: false, isUploading: false));
      }
    } catch (e) {
      String errorMessage = 'Fotoğraf seçilirken hata oluştu';

      if (e.toString().contains('photo_access_denied') || e.toString().contains('camera_access_denied')) {
        errorMessage = 'permission_denied';
      }

      emit(state.copyWith(isImagePickerOpen: false, imageError: errorMessage));
    }
  }

  File? getSelectedImage() {
    return state.selectedImage;
  }

  Future<bool> uploadPhoto(BuildContext context, {bool shouldPop = false}) async {
    if (state.selectedImage != null) {
      // Set uploading state to true
      emit(state.copyWith(isUploading: true, clearError: true));

      final result = await authCubit.uploadProfilePhoto(state.selectedImage!);

      // Set uploading state to false
      emit(state.copyWith(isUploading: false));

      if (context.mounted) {
        if (result == true && authCubit.state.user?.photoUrl != null) {
          SnackBarHelper.showSuccess(context, 'Profil fotoğrafı başarıyla yüklendi!');
          authCubit.getProfile(); // Refresh user profile

          return true;
        } else {
          print(authCubit.state.errorMessage);

          // Hata mesajını kontrol et
          String errorMessage = 'Something went wrong';
          if (authCubit.state.errorMessage != null && authCubit.state.errorMessage!.contains('413')) {
            errorMessage = 'The image size is too large. Please select a smaller image.';
          }

          SnackBarHelper.showError(context, errorMessage);
          return false;
        }
      }
    }
    return false;
  }

  Future<bool> skipPhotoUpload(BuildContext context, {bool shouldPop = false}) async {
    if (context.mounted) {
      if (shouldPop) {
        Navigation.ofPop();
      } else {
        Navigation.pushReplacementNamed(root: Routes.profile);
      }
      return true;
    }
    return false;
  }

  void setCanSkip(bool canSkip) {
    emit(state.copyWith(canSkip: canSkip));
  }
}
