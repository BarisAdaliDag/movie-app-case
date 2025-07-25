import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/core/extension/padding_extension.dart';
import 'package:movieapp/core/getIt/get_it.dart';
import 'package:movieapp/core/routes/navigation_helper.dart';
import 'package:movieapp/core/routes/routes.dart';
import 'package:movieapp/core/theme/app_colors.dart';
import 'package:movieapp/core/theme/text_styles.dart';
import 'package:movieapp/core/widgets/custom_app_bar.dart';
import 'package:movieapp/features/data/cubit/auth_cubit.dart';
import 'package:movieapp/features/data/cubit/auth_state.dart';
import 'package:movieapp/core/widgets/custom_button.dart';
import 'package:movieapp/core/widgets/loading_widget.dart';
import 'package:movieapp/features/presentation/photo_upload/view/photo_upload_page.dart';
import 'package:movieapp/features/presentation/profile/widget/limited_offer_badge.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: Text('Logout', style: AppTextStyles.headline3.copyWith(color: AppColors.white)),
          content: Text(
            'Are you sure you want to logout?',
            style: AppTextStyles.bodyRegular.copyWith(color: AppColors.white),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel', style: AppTextStyles.bodyRegular.copyWith(color: AppColors.white)),
            ),
            TextButton(
              onPressed: () {
                Navigation.pushReplacementNamed(root: Routes.login);
                context.read<AuthCubit>().logout();
              },
              child: Text('Logout', style: AppTextStyles.bodyRegular.copyWith(color: AppColors.error)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: CustomAppBar(title: "Profil Detayı", showBackButton: false, actions: [LimitedOfferBadge()]),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (!state.isAuthenticated && !state.isLoading) {
            Navigation.pushReplacementNamed(root: Routes.login);
          }

          if (state.errorMessage != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage!), backgroundColor: AppColors.error));
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const LoadingWidget(message: 'Loading profile...');
          }

          if (state.user == null) {
            return Center(
              child: Text(
                'No user data available',
                style: AppTextStyles.bodyRegular.copyWith(color: AppColors.textSecondary),
              ),
            );
          }

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Header
                  Row(
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
                              state.user!.photoUrl != null && state.user!.photoUrl!.isNotEmpty
                                  ? Image.network(
                                    state.user!.photoUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) => Container(
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
                            Text(state.user!.name, style: AppTextStyles.appBarStyle.copyWith(color: AppColors.white)),
                            const SizedBox(height: 4),
                            Text(
                              'ID: ${state.user!.id}',
                              style: AppTextStyles.bodyRegular.copyWith(color: AppColors.textSecondary),
                            ),
                          ],
                        ).onlyPadding(right: 10),
                      ),

                      // Photo Button
                      GestureDetector(
                        onTap: () => Navigation.push(page: PhotoUploadPage(user: state.user!)),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Fotoğraf Ekle',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Favorite Movies Section
                  Text('Beğendiğim Filmler', style: AppTextStyles.headline3.copyWith(color: AppColors.white)),

                  const SizedBox(height: 16),

                  // Movies Grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: 4, // Demo için 4 film
                    itemBuilder: (context, index) {
                      return _buildMovieCard(index);
                    },
                  ),

                  const SizedBox(height: 32),

                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _logout(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text('Çıkış Yap', style: AppTextStyles.buttonText.copyWith(color: AppColors.white)),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMovieCard(int index) {
    // Demo movie data - gerçek uygulamada favoriler listesinden gelecek
    final movies = [
      {
        'title': 'Aşk, Ekmek, Hayaller',
        'subtitle': 'Adam Yapım',
        'image': 'https://via.placeholder.com/200x300/4A5568/FFFFFF?text=Movie+${index + 1}',
      },
      {
        'title': 'Gece Karanlık',
        'subtitle': 'Fox Studios',
        'image': 'https://via.placeholder.com/200x300/2D3748/FFFFFF?text=Movie+${index + 1}',
      },
      {
        'title': 'Aşk, Ekmek, Hayaller',
        'subtitle': 'Adam Yapım',
        'image': 'https://via.placeholder.com/200x300/4A5568/FFFFFF?text=Movie+${index + 1}',
      },
      {
        'title': 'Gece Karanlık',
        'subtitle': 'Fox Studios',
        'image': 'https://via.placeholder.com/200x300/2D3748/FFFFFF?text=Movie+${index + 1}',
      },
    ];

    final movie = movies[index % movies.length];

    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: AppColors.surface),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Movie Image
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
              child: Container(
                width: double.infinity,
                color: AppColors.cardBackground,
                child: Image.network(
                  movie['image']!,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) => Container(
                        color: AppColors.cardBackground,
                        child: Icon(Icons.movie, size: 40, color: AppColors.textSecondary),
                      ),
                ),
              ),
            ),
          ),

          // Movie Info
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie['title']!,
                  style: AppTextStyles.bodyRegular.copyWith(color: AppColors.white, fontWeight: FontWeight.w600),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  movie['subtitle']!,
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
