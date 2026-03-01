import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bobmoo/ui/theme/app_colors.dart';
import 'package:bobmoo/ui/theme/app_typography_tokens.g.dart';

double _letterSpacing(double fontSize, double percent) =>
    (fontSize * percent).sp;

AppTypographyToken _token(String key) {
  final token = kAppTypographyTokens[key];
  if (token == null) {
    throw ArgumentError('Unknown typography token: $key');
  }
  return token;
}

TextStyle _textStyleFromToken({
  required String key,
  Color color = AppColors.colorBlack,
}) {
  final token = _token(key);
  return TextStyle(
    fontSize: token.fontSize.sp,
    letterSpacing: _letterSpacing(token.fontSize, token.letterSpacingPercent),
    fontWeight: token.fontWeight,
    color: color,
  );
}

class AppTypography {
  // 인스턴스화 방지
  AppTypography._();

  static const head = _Head();
  static const caption = _Caption();
  static const button = _Button();
  static const search = _Search();
  static const widget = _Widget();
}

class _Head {
  const _Head();

  TextStyle get b48 => _textStyleFromToken(key: 'head.b48');

  TextStyle get b30 => _textStyleFromToken(key: 'head.b30');

  TextStyle get b21 => _textStyleFromToken(key: 'head.b21');

  TextStyle get sb18 => _textStyleFromToken(key: 'head.sb18');
}

class _Caption {
  const _Caption();

  TextStyle get m15 => _textStyleFromToken(key: 'caption.m15');

  TextStyle get r15 => _textStyleFromToken(key: 'caption.r15');

  TextStyle get sb11 => _textStyleFromToken(key: 'caption.sb11');

  TextStyle get sb9 => _textStyleFromToken(key: 'caption.sb9');
}

class _Button {
  const _Button();

  TextStyle get sb12 => _textStyleFromToken(key: 'button.sb12');

  TextStyle get sb11 => _textStyleFromToken(key: 'button.sb11');
}

class _Search {
  const _Search();

  TextStyle get b17 => _textStyleFromToken(key: 'search.b17');

  TextStyle get b15 => _textStyleFromToken(key: 'search.b15');

  TextStyle get sb15 => _textStyleFromToken(key: 'search.sb15');

  TextStyle get sb12 => _textStyleFromToken(key: 'search.sb12');
}

class _Widget {
  const _Widget();

  TextStyle get sb14 => _textStyleFromToken(key: 'widget.sb14');

  TextStyle get sb12 => _textStyleFromToken(key: 'widget.sb12');

  TextStyle get sb7 => _textStyleFromToken(key: 'widget.sb7');

  TextStyle get m11 => _textStyleFromToken(key: 'widget.m11');

  TextStyle get r11 => _textStyleFromToken(key: 'widget.r11');
}
