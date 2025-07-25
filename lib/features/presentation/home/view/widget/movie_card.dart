import 'package:flutter/material.dart';
import 'package:movieapp/core/theme/app_colors.dart';
import 'package:movieapp/core/theme/text_styles.dart';
import 'package:movieapp/features/data/models/movie/movie_model.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MovieCard extends StatelessWidget {
  final MovieModel movie;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback? onTap;

  const MovieCard({super.key, required this.movie, this.onFavoriteToggle, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 80.h, // Tam ekran yüksekliği
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: Stack(
          children: [
            // Background image - tam ekran
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                // movie.images.first,
                movie.poster,
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: double.infinity,
                    width: double.infinity,
                    color: Colors.grey[800],
                    child: const Icon(Icons.movie, size: 64, color: Colors.grey),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: double.infinity,
                    width: double.infinity,
                    color: Colors.grey[800],
                    child: const Center(child: CircularProgressIndicator(color: Colors.red)),
                  );
                },
              ),
            ),

            // Gradient overlay - bottom to top
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.3),
                    Colors.black.withValues(alpha: 0.7),
                    Colors.black.withValues(alpha: 0.9),
                  ],
                  stops: [0.0, 0.4, 0.6, 0.8, 1.0],
                ),
              ),
            ),

            // Favorite heart icon button
            Positioned(
              bottom: 80,
              right: 20,
              child: GestureDetector(
                onTap: onFavoriteToggle,
                child: Container(
                  width: 49,
                  height: 72,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2), // %20 opak siyah
                    borderRadius: BorderRadius.circular(82), // Tam yuvarlak köşe
                    border: Border.all(color: AppColors.white20Opacity, width: 1),
                  ),
                  child: Icon(
                    movie.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: AppColors.whiteLittleGrey,
                    size: 24,
                  ),
                ),
              ),
            ),

            // Movie information at bottom
            Positioned(
              bottom: 0, // Bottom navigation için yer bırakıyoruz
              left: 20,
              right: 20,

              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                    child: const Center(
                      child: Text(
                        'N',
                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12), // Yatay boşluk
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie.title,
                          style:
                              AppTextStyles.headline3.copyWith(fontWeight: FontWeight.bold, color: AppColors.white) ??
                              const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          movie.plot,
                          style: AppTextStyles.bodyLarge.copyWith(color: Colors.white70),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
