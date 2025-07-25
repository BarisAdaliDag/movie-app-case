import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:movieapp/core/theme/app_colors.dart';
import 'package:movieapp/core/theme/text_styles.dart';
import 'package:movieapp/features/data/models/movie/movie_model.dart';

class ProfileMovieCard extends StatelessWidget {
  final MovieModel movie;

  const ProfileMovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
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
                child: CachedNetworkImage(
                  imageUrl: movie.images.first,
                  fit: BoxFit.cover,
                  placeholder:
                      (context, url) => Container(
                        color: AppColors.cardBackground,
                        child: Icon(Icons.movie, size: 40, color: AppColors.textSecondary),
                      ),
                  errorWidget:
                      (context, url, error) => Container(
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
