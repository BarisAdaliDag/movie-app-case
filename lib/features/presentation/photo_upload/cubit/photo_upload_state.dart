import 'dart:io';

class PhotoUploadState {
  final File? selectedImage;
  final bool isImagePickerOpen;
  final String? imageError;
  final bool canSkip;
  final bool shouldNavigate;

  const PhotoUploadState({
    this.selectedImage,
    this.isImagePickerOpen = false,
    this.imageError,
    this.canSkip = true,
    this.shouldNavigate = false,
  });

  PhotoUploadState copyWith({
    File? selectedImage,
    bool? isImagePickerOpen,
    String? imageError,
    bool? canSkip,
    bool? shouldNavigate,
    bool clearImage = false,
    bool clearError = false,
  }) {
    return PhotoUploadState(
      selectedImage: clearImage ? null : (selectedImage ?? this.selectedImage),
      isImagePickerOpen: isImagePickerOpen ?? this.isImagePickerOpen,
      imageError: clearError ? null : (imageError ?? this.imageError),
      canSkip: canSkip ?? this.canSkip,
      shouldNavigate: shouldNavigate ?? this.shouldNavigate,
    );
  }
}
