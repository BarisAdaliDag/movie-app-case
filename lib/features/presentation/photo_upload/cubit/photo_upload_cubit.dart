import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
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
      emit(state.copyWith(isImagePickerOpen: true, clearError: true));

      final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery, imageQuality: 80);

      if (image != null) {
        emit(state.copyWith(selectedImage: File(image.path), isImagePickerOpen: false));
      } else {
        emit(state.copyWith(isImagePickerOpen: false));
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

  Future<void> uploadPhoto() async {
    if (state.selectedImage != null) {
      final result = await authCubit.uploadProfilePhoto(state.selectedImage!);
    }
  }

  void setCanSkip(bool canSkip) {
    emit(state.copyWith(canSkip: canSkip));
  }
}
