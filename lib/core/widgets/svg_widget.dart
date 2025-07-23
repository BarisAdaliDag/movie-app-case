// ignore_for_file: public_member_api_docs, document_ignores, deprecated_member_use, lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgWidget extends StatelessWidget {
  const SvgWidget({
    required this.svgPath,
    super.key,
    this.height = 24,
    this.width = 24,
    this.color,
  });
  final String svgPath;
  final double? height;
  final double? width;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      svgPath,
      height: height,
      width: width,
      color: color,
    );
  }
}

class SvgWidgetNetwork extends StatelessWidget {
  const SvgWidgetNetwork({
    required this.svgPath,
    super.key,
    this.height = 24,
    this.width = 24,
    this.color,
  });
  final String svgPath;
  final double? height;
  final double? width;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.network(
      svgPath,
      height: height,
      width: width,
      color: color,
      fit: BoxFit.cover,
    );
  }
}
