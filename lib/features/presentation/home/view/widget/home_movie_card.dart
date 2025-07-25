import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:movieapp/core/enum/svg_enum.dart';
import 'package:movieapp/core/extension/padding_extension.dart';
import 'package:movieapp/core/theme/app_colors.dart';
import 'package:movieapp/core/theme/text_styles.dart';
import 'package:movieapp/core/widgets/svg_widget.dart';
import 'package:movieapp/features/data/models/movie/movie_model.dart';

class HomeMovieCard extends StatelessWidget {
  final MovieModel movie;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback? onTap;

  const HomeMovieCard({super.key, required this.movie, this.onFavoriteToggle, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            // Background image - tam ekran
            ClipRRect(
              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
              child: CachedNetworkImage(
                // movie.images.first,
                imageUrl: movie.images.first,
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder:
                    (context, url) => Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.grey[800],
                      child: const Center(child: CircularProgressIndicator(color: Colors.red)),
                    ),
                errorWidget:
                    (context, url, error) => Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.grey[800],
                      child: const Icon(Icons.movie, size: 64, color: Colors.grey),
                    ),
              ),
            ),

            // Gradient overlay - bottom to top
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
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
                  SvgWidget(svgPath: SvgEnum.homeN.svgPath, width: 40, height: 40).onlyPadding(top: 8),
                  const SizedBox(width: 12), // Yatay boşluk
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie.title,
                          style: AppTextStyles.headline3.copyWith(fontWeight: FontWeight.bold, color: AppColors.white),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        // const SizedBox(height: 4),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final baseStyle = AppTextStyles.bodyRegular.copyWith(color: Colors.white70);
                            final readMoreStyle = AppTextStyles.bodyRegular.copyWith(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.bold,
                            );

                            // Test metni ile kaç karakter sığdığını hesapla
                            final testSpan = TextSpan(text: movie.plot, style: baseStyle);
                            final testPainter = TextPainter(
                              text: testSpan,
                              textDirection: TextDirection.ltr,
                              maxLines: 2,
                            );
                            testPainter.layout(maxWidth: constraints.maxWidth);

                            if (testPainter.didExceedMaxLines) {
                              // Metin 2 satıra sığmıyor, kısaltıp "Daha Fazlası" ekle

                              // "Daha Fazlası" için yer hesapla
                              final readMorePainter = TextPainter(
                                text: TextSpan(text: " Daha Fazlası", style: readMoreStyle),
                                textDirection: TextDirection.ltr,
                              );
                              readMorePainter.layout();

                              // İkinci satır için kullanılabilir genişlik
                              final availableWidth = constraints.maxWidth - readMorePainter.width;

                              // Kısaltılmış metni hesapla
                              String truncatedText = movie.plot;
                              TextPainter painter;

                              do {
                                truncatedText = truncatedText.substring(0, truncatedText.length - 1);
                                painter = TextPainter(
                                  text: TextSpan(text: truncatedText, style: baseStyle),
                                  textDirection: TextDirection.ltr,
                                  maxLines: 2,
                                );
                                painter.layout(maxWidth: availableWidth);
                              } while (painter.didExceedMaxLines && truncatedText.isNotEmpty);

                              // Son kelimeyi tam tut
                              final words = truncatedText.split(' ');
                              if (words.length > 1) {
                                words.removeLast();
                                truncatedText = words.join(' ');
                              }

                              return RichText(
                                text: TextSpan(
                                  style: baseStyle,
                                  children: [
                                    TextSpan(text: truncatedText),
                                    TextSpan(
                                      text: " ...Daha Fazlası",
                                      style: readMoreStyle.copyWith(color: AppColors.white),
                                    ),
                                  ],
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              );
                            } else {
                              // Metin 2 satıra sığıyor, normal göster
                              return Text(movie.plot, style: baseStyle, maxLines: 2, overflow: TextOverflow.ellipsis);
                            }
                          },
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
