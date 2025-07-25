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
import 'package:movieapp/core/widgets/loading_widget.dart';
import 'package:movieapp/features/data/models/movie/movie_model.dart';
import 'package:movieapp/features/presentation/photo_upload/view/photo_upload_page.dart';
import 'package:movieapp/features/presentation/profile/cubit/profile_cubit.dart';
import 'package:movieapp/features/presentation/profile/cubit/profile_state.dart';
import 'package:movieapp/features/presentation/profile/widget/limited_offer_badge.dart';
import 'package:movieapp/features/presentation/profile/widget/movie_shimmer_card.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProfileCubit>()..loadFavoriteMovies(),
      child: const _ProfilePageContent(),
    );
  }
}

class _ProfilePageContent extends StatelessWidget {
  const _ProfilePageContent();

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
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, authState) {
          if (authState.isLoading) {
            return const LoadingWidget(message: 'Loading profile...');
          }

          if (!authState.isAuthenticated) {
            Future.microtask(() => Navigation.pushReplacementNamed(root: Routes.login));
            return Container();
          }

          if (authState.user == null) {
            return Center(
              child: Text(
                'No user data available',
                style: AppTextStyles.bodyRegular.copyWith(color: AppColors.textSecondary),
              ),
            );
          }

          return BlocConsumer<ProfileCubit, ProfileState>(
            listener: (context, profileState) {
              if (profileState.hasError) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(profileState.error!), backgroundColor: AppColors.error));
                context.read<ProfileCubit>().clearError();
              }
            },
            builder: (context, profileState) {
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
                                  authState.user!.photoUrl != null && authState.user!.photoUrl!.isNotEmpty
                                      ? Image.network(
                                        authState.user!.photoUrl!,
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
                                Text(
                                  authState.user!.name,
                                  style: AppTextStyles.appBarStyle.copyWith(color: AppColors.white),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'ID: ${authState.user!.id}',
                                  style: AppTextStyles.bodyRegular.copyWith(color: AppColors.textSecondary),
                                ),
                              ],
                            ).onlyPadding(right: 10),
                          ),

                          // Photo Button
                          GestureDetector(
                            onTap: () => Navigation.push(page: PhotoUploadPage(user: authState.user!)),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Fotoğraf Ekle',
                                style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // Favorite Movies Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Beğendiğim Filmler',
                            style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Movies Grid
                      if (profileState.isLoading)
                        // Loading shimmer cards
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.6,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: 4,
                          itemBuilder: (context, index) => const MovieShimmerCard(),
                        )
                      else if (profileState.isEmpty)
                        // Empty state
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              children: [
                                Icon(Icons.favorite_border, size: 48, color: AppColors.textSecondary),
                                const SizedBox(height: 16),
                                Text(
                                  'Henüz favori film eklememişsiniz',
                                  style: AppTextStyles.bodyRegular.copyWith(color: AppColors.textSecondary),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        // Actual movies grid
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.55,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: profileState.favoriteMovies.length,
                          itemBuilder: (context, index) {
                            return _buildMovieCard(profileState.favoriteMovies[index], context);
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
          );
        },
      ),
    );
  }

  Widget _buildMovieCard(MovieModel movie, BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Movie Image
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              child: SizedBox(
                width: double.infinity,
                child: Image.network(
                  movie.images.first,
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
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.white, fontWeight: FontWeight.w500),
                  maxLines: 2,

                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  movie.genre,
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                // Extra spacing to maintain consistent card height
                if (movie.title.length < 25) // Approximate check for single line
                  const SizedBox(height: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
