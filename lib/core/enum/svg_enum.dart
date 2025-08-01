/// Svg enum
enum SvgEnum {
  message('message'),
  unlock('unlock'),
  hide('hide'),
  google('google'),
  apple('apple'),
  facebook('facebook'),
  gradientBottom('gradientBottom'),
  homeN('homeN'),
  addUser('addUser'),
  gem('gem'),
  paywallBackground('paywall_background'),

  plus('plus');

  const SvgEnum(this.value);

  /// value
  final String value;

  /// svg path
  String get svgPath => 'assets/svg/$value.svg';
}
