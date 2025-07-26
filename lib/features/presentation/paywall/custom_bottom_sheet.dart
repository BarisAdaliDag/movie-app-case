import 'dart:ui';

import 'package:flutter/material.dart';

class CustomBottomSheet extends StatelessWidget {
  final Widget child;

  const CustomBottomSheet({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Tasarım oranları
    // Tasarım: device height 844, bottom sheet height 654, gradient diameter 217
    // Oran hesaplaması: 217/844 = 0.257 (gradient'in ekran yüksekliğine oranı)

    final gradientSize = screenHeight * 0.500; // ~217px eşdeğeri
    final gradientRadius = gradientSize / 2;

    // Gradient'lerin X pozisyonu için oran
    // Tasarım: 92.302734375 / 402 (bottom sheet width) = 0.23
    final gradientX = -screenWidth * 0.1;

    // Gradient'lerin Y pozisyonu için oran
    // Üst: -83.7408447265625 / 654 = -0.128
    // Alt: 503.125 / 654 = 0.769
    final topGradientY = gradientRadius - 50; // Yarısı gözükecek
    final bottomGradientY = gradientRadius; // Alt kısımda konumlandır

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        color: const Color.fromRGBO(8, 8, 8, 1),
      ),
      child: Stack(
        children: [
          // Alt gradient (bottom)
          Positioned(
            bottom: -topGradientY, // Yarısı gözükecek şekilde
            left: gradientX,
            child: Container(
              width: gradientSize,
              height: gradientSize,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    const Color.fromRGBO(229, 9, 20, 0.8),
                    const Color.fromRGBO(229, 9, 20, 0.5),
                    const Color.fromRGBO(229, 9, 20, 0.2),
                    Colors.transparent,
                  ],
                  stops: [0.0, 0.3, 0.6, 1.0],
                ),
                borderRadius: BorderRadius.circular(gradientRadius),
              ),
            ),
          ),

          // Üst gradient (top)
          Positioned(
            top: -topGradientY, // Yarısı gözükecek şekilde
            left: gradientX,
            child: Container(
              width: gradientSize,
              height: gradientSize,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    const Color.fromRGBO(229, 9, 20, 0.8),
                    const Color.fromRGBO(229, 9, 20, 0.5),
                    const Color.fromRGBO(229, 9, 20, 0.2),
                    Colors.transparent,
                  ],
                  stops: [0.0, 0.3, 0.6, 1.0],
                ),
                borderRadius: BorderRadius.circular(gradientRadius),
              ),
            ),
          ),

          // Content container with blur effect
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
              color: const Color.fromRGBO(8, 8, 8, 0.7),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.1),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                      bottomLeft: Radius.circular(32),
                      bottomRight: Radius.circular(32),
                    ),
                  ),
                  child: child,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
