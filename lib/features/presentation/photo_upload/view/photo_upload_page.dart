import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/core/getIt/get_It.dart';
import 'package:movieapp/core/routes/navigation_helper.dart';
import 'package:movieapp/core/routes/routes.dart';
import 'package:movieapp/core/widgets/custom_button.dart';
import 'package:movieapp/features/data/models/auth/user_model.dart';
import 'package:movieapp/features/data/cubit/auth_cubit.dart';
import 'package:movieapp/features/data/cubit/auth_state.dart';
import 'package:movieapp/features/presentation/main/main_page.dart';
import 'package:movieapp/features/presentation/photo_upload/cubit/photo_upload_cubit.dart';
import 'package:movieapp/features/presentation/photo_upload/cubit/photo_upload_state.dart';
import 'package:movieapp/features/presentation/photo_upload/view/widget/common_widgets.dart';

class PhotoUploadPage extends StatelessWidget {
  final UserModel user;
  final bool showBackButton;

  const PhotoUploadPage({super.key, required this.user, this.showBackButton = true});

  @override
  Widget build(BuildContext context) {
    final authCubit = getIt<AuthCubit>();

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: authCubit),
        BlocProvider(create: (context) => PhotoUploadCubit(authCubit: authCubit)),
      ],
      child: _PhotoUploadPageView(user: user, showBackButton: showBackButton),
    );
  }
}

class _PhotoUploadPageView extends StatefulWidget {
  final UserModel user;
  final bool showBackButton;

  const _PhotoUploadPageView({required this.user, this.showBackButton = true});

  @override
  State<_PhotoUploadPageView> createState() => _PhotoUploadPageViewState();
}

class _PhotoUploadPageViewState extends State<_PhotoUploadPageView> {
  Future<void> _handleContinue() async {
    final result = await context.read<PhotoUploadCubit>().uploadPhoto(context, shouldPop: widget.showBackButton);

    // // If navigating from profile and success, pop with success indicator
    if (widget.showBackButton && mounted) {
      if (result == true) {
        context.read<AuthCubit>().getProfile();
        Navigation.ofPop();
      }
    } else {
      Navigation.pushAndRemoveAll(page: MainPage(initialIndex: 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget scaffold = Scaffold(
      appBar: CustomAppBar(
        title: 'Profil Detayı',
        showBackButton: widget.showBackButton,
        onBackPressed:
            widget.showBackButton
                ? () {
                  Navigation.ofPop();
                }
                : null,
      ),
      body: _buildBody(context),
    );

    if (!widget.showBackButton) {
      return PopScope(canPop: false, child: scaffold);
    }

    return scaffold;
  }

  Widget _buildBody(BuildContext context) {
    return ErrorBlocListener<AuthCubit, AuthState>(
      errorExtractor: (state) => state.errorMessage,
      clearErrorAction: (state) => () => context.read<AuthCubit>().clearError(),
      child: ErrorBlocListener<PhotoUploadCubit, PhotoUploadState>(
        errorExtractor: (state) => state.imageError,
        clearErrorAction: (state) => () => context.read<PhotoUploadCubit>().clearError(),
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

                        // Header
                        Center(
                          child: const PageHeader(
                            title: 'Fotoğraflarınızı Yükleyin',
                            subtitle: 'Resources out incentivize \nrelaxation floor loss cc.',
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Photo Upload Area
                        Center(
                          child: PhotoUploadContainer(
                            selectedImage: formState.selectedImage,
                            isLoading: formState.uploading || authState.isLoading,
                            onTap:
                                (formState.uploading || authState.isLoading)
                                    ? null
                                    : () => context.read<PhotoUploadCubit>().pickImageFromGallery(),
                          ),
                        ),

                        const Spacer(),

                        // Continue Button
                        CustomButton(
                          text: 'Devam Et',
                          onPressed: (authState.isLoading || formState.uploading) ? null : () => _handleContinue(),
                          isLoading: authState.isLoading || formState.uploading,
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
    );
  }
}
