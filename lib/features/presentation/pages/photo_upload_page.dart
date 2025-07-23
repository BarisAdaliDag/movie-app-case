import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movieapp/core/utils/snackbar_helper.dart';
import 'package:movieapp/features/data/models/auth/user_model.dart';
import 'package:movieapp/features/presentation/cubit/auth_cubit.dart';
import 'package:movieapp/features/presentation/cubit/auth_state.dart';
import 'package:movieapp/features/presentation/pages/profile_page.dart';
import 'package:movieapp/features/presentation/widgets/custom_button.dart';
import 'package:permission_handler/permission_handler.dart';

class PhotoUploadPage extends StatefulWidget {
  final UserModel user;

  const PhotoUploadPage({super.key, required this.user});

  @override
  State<PhotoUploadPage> createState() => _PhotoUploadPageState();
}

class _PhotoUploadPageState extends State<PhotoUploadPage> {
  File? _selectedImage;
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _pickImageFromGallery() async {
    try {
      // Image picker otomatik olarak izin yönetimini yapar
      final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery, imageQuality: 80);

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
        SnackBarHelper.showSuccess(context, 'Fotoğraf başarıyla seçildi!');
      }
    } catch (e) {
      // İzin reddedildi veya başka bir hata oluştu
      if (e.toString().contains('photo_access_denied') || e.toString().contains('camera_access_denied')) {
        _showPermissionDialog();
      } else {
        SnackBarHelper.showError(context, 'Fotoğraf seçilirken hata oluştu');
      }
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('İzin Gerekli'),
            content: const Text('Galeri erişimi için izin gerekli. Lütfen ayarlardan izni açın.'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('İptal')),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  openAppSettings();
                },
                child: const Text('Ayarlar'),
              ),
            ],
          ),
    );
  }

  void _uploadPhoto() {
    if (_selectedImage != null) {
      context.read<AuthCubit>().uploadProfilePhoto(_selectedImage!);
    }
  }

  void _skipPhotoUpload() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const ProfilePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          // Success - Check if photo was uploaded
          if (state.user?.photoUrl != null && state.user!.photoUrl!.isNotEmpty && !state.isLoading) {
            SnackBarHelper.showSuccess(context, 'Profil fotoğrafı başarıyla yüklendi!');
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const ProfilePage()));
            return;
          }

          // Error - Show SnackBar
          if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
            SnackBarHelper.showError(context, state.errorMessage!);
            context.read<AuthCubit>().clearError();
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  // Header
                  const Text(
                    'Profil Fotoğrafı',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Merhaba ${widget.user.name}! Profil fotoğrafı eklemek ister misin?',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),

                  const SizedBox(height: 48),

                  // Photo Preview
                  GestureDetector(
                    onTap: state.isLoading ? null : _pickImageFromGallery,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: Colors.grey.shade300, width: 2),
                      ),
                      child:
                          state.isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : _selectedImage != null
                              ? ClipRRect(
                                borderRadius: BorderRadius.circular(98),
                                child: Image.file(_selectedImage!, fit: BoxFit.cover),
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
                  if (_selectedImage != null) ...[
                    CustomButton(
                      text: 'Fotoğrafı Yükle',
                      onPressed: _uploadPhoto,
                      isLoading: state.isLoading,
                      backgroundColor: Colors.green,
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Skip Button
                  CustomButton(
                    text: _selectedImage != null ? 'Şimdilik Atla' : 'Devam Et',
                    onPressed: state.isLoading ? null : _skipPhotoUpload,
                    isLoading: false,
                    backgroundColor: Colors.grey.shade600,
                  ),

                  const SizedBox(height: 24),

                  // Select Photo Button (if no image selected)
                  if (_selectedImage == null && !state.isLoading)
                    OutlinedButton.icon(
                      onPressed: _pickImageFromGallery,
                      icon: const Icon(Icons.add_photo_alternate),
                      label: const Text('Fotoğraf Seç'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
