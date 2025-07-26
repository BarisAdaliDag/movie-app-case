import 'dart:ui';

import 'package:flutter/material.dart';

class CustomBottomSheet extends StatelessWidget {
  final Widget child;

  const CustomBottomSheet({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final gradientSize = screenWidth * 1.5;
    final gradientRadius = gradientSize / 2;

    final gradientX = -screenWidth * 0.25;

    final topGradientY = gradientRadius - 50; // Yarısı gözükecek

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
            child: ClipRRect(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
              child: Container(
                width: gradientSize,
                height: gradientSize,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      const Color.fromRGBO(229, 9, 20, 0.9),
                      const Color.fromRGBO(229, 9, 20, 0.6),
                      const Color.fromRGBO(229, 9, 20, 0.4),
                      Colors.transparent,
                    ],
                    stops: [0.0, 0.3, 0.6, 1.0],
                  ),
                  borderRadius: BorderRadius.circular(gradientRadius),
                ),
              ),
            ),
          ),

          // Üst gradient (top)
          Positioned(
            top: -(topGradientY - 20), // Yarısı gözükecek şekilde
            left: gradientX,
            child: ClipRRect(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
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
