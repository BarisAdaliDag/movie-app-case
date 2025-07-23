/// Svg enum
enum SvgEnum {
  cancelIcon('cancel-icon'),

  plus('plus');

  const SvgEnum(this.value);

  /// value
  final String value;

  /// svg path
  String get svgPath => 'assets/svg/$value.svg';
}
