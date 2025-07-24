import 'package:flutter/material.dart';
import 'package:movieapp/core/theme/text_styles.dart';
import 'package:movieapp/features/data/models/movie/movie_model.dart';

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
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Movie poster with favorite button
            Stack(
              children: [
                // Movie poster
                ClipRRect(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                  child: Image.network(
                    movie.poster,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        width: double.infinity,
                        color: Colors.grey[800],
                        child: const Icon(Icons.movie, size: 64, color: Colors.grey),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 200,
                        width: double.infinity,
                        color: Colors.grey[800],
                        child: const Center(child: CircularProgressIndicator(color: Colors.red)),
                      );
                    },
                  ),
                ),
                // Favorite heart icon button
                Positioned(
                  top: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: onFavoriteToggle,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                        border: Border.all(color: movie.isFavorite ? Colors.red : Colors.grey, width: 2),
                      ),
                      child: Icon(
                        movie.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: movie.isFavorite ? Colors.red : Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                // Coming soon badge
                if (movie.comingSoon)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(12)),
                      child: const Text(
                        'Yakında',
                        style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
              ],
            ),
            // Movie information
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    movie.title,
                    style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Year and runtime
                  Row(
                    children: [
                      Text(movie.year, style: AppTextStyles.bodySmall.copyWith(color: Colors.grey[400])),
                      const SizedBox(width: 8),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(color: Colors.grey[400], shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 8),
                      Text(movie.runtime, style: AppTextStyles.bodySmall.copyWith(color: Colors.grey[400])),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Genre
                  Text(
                    movie.genre,
                    style: AppTextStyles.bodySmall.copyWith(color: Colors.grey[300]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // IMDB rating
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        movie.imdbRating,
                        style: AppTextStyles.bodySmall.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 4),
                      Text('IMDB', style: AppTextStyles.bodySmall.copyWith(color: Colors.grey[400])),
                    ],
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
