import 'package:flutter/material.dart';
import 'package:movieapp/core/theme/app_colors.dart';
import 'package:movieapp/core/theme/text_styles.dart';
import 'package:movieapp/features/data/models/movie/movie_model.dart';
import 'package:movieapp/features/presentation/profile/cubit/profile_state.dart';
import 'package:movieapp/features/presentation/profile/widget/movie_shimmer_card.dart';
import 'package:movieapp/features/presentation/profile/widget/profile_movie_card.dart';

class ProfileMoviesGridWidget extends StatelessWidget {
  final ProfileState profileState;

  const ProfileMoviesGridWidget({super.key, required this.profileState});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text('Beğendiğim Filmler', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700))],
        ),

        const SizedBox(height: 16),

        // Movies Grid Content
        if (profileState.isLoading)
          _buildLoadingGrid()
        else if (profileState.isEmpty)
          _buildEmptyState()
        else
          _buildMoviesGrid(profileState.favoriteMovies),
      ],
    );
  }

  Widget _buildLoadingGrid() {
    return GridView.builder(
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
    );
  }

  Widget _buildEmptyState() {
    return Center(
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
    );
  }

  Widget _buildMoviesGrid(List<MovieModel> movies) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.55,
        crossAxisSpacing: 12,
        mainAxisSpacing: 16,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        return ProfileMovieCard(movie: movies[index]);
      },
    );
  }
}
