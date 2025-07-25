import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color(0xFF_E50914);
  static const Color secondaryColor = Color(0xFF252836);
  static const Color accentColor = Color(0xFF12CDD9);
  static const Color warning = Color(0xFFFFB800);
  static const Color error = Color(0xFFFF2E2E);
  static const Color success = Color(0xFF22B07D);
  static const Color background = Color(0xFF1F1D2B);
  static const Color surface = Color(0xFF252836);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0x80FFFFFF);
  static const Color grey = Colors.grey;
  static const Color white = Color(0xFFFFFFFF);
  static const Color whiteLittleGrey = Color.fromRGBO(255, 255, 255, 1);
  static const Color white20Opacity = Color.fromRGBO(255, 255, 255, 0.20);

  /// %10 saydam beyaz → CSS: #FFFFFF1A
  static const Color white10Opacity = Color.fromRGBO(255, 255, 255, 0.092);

  /// Background için %10 saydam beyaz
  static const Color backgroundWhite10 = Color(0xFF222222);
  static Color white50 = Color(0x80FFFFFF).withOpacity(0.5);

  static const Color scaffoldBackground = Color(0xFF090909);
  static const Color cardBackground = Color(0xFF242424);

  static const Color textHint = Colors.white38;

  static const List<Color> posterGradient = <Color>[Colors.transparent, Colors.black87];
}
