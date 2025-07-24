import 'dart:io';

class PhotoUploadState {
  final File? selectedImage;
  final bool isImagePickerOpen;
  final String? imageError;
  final bool canSkip;
  final bool shouldNavigate;
  final bool isUploading;

  const PhotoUploadState({
    this.selectedImage,
    this.isImagePickerOpen = false,
    this.imageError,
    this.canSkip = true,
    this.shouldNavigate = false,
    this.isUploading = false,
  });

  /// Safe getter for isUploading to ensure it's never null
  bool get uploading => isUploading;

  PhotoUploadState copyWith({
    File? selectedImage,
    bool? isImagePickerOpen,
    String? imageError,
    bool? canSkip,
    bool? shouldNavigate,
    bool? isUploading,
    bool clearImage = false,
    bool clearError = false,
  }) {
    return PhotoUploadState(
      selectedImage: clearImage ? null : (selectedImage ?? this.selectedImage),
      isImagePickerOpen: isImagePickerOpen ?? this.isImagePickerOpen,
      imageError: clearError ? null : (imageError ?? this.imageError),
      canSkip: canSkip ?? this.canSkip,
      shouldNavigate: shouldNavigate ?? this.shouldNavigate,
      isUploading: isUploading ?? this.isUploading,
    );
  }

  @override
  String toString() {
    return 'PhotoUploadState(selectedImage: $selectedImage, isImagePickerOpen: $isImagePickerOpen, imageError: $imageError, canSkip: $canSkip, shouldNavigate: $shouldNavigate, isUploading: $isUploading)';
  }
}
