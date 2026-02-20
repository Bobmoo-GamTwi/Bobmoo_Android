import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bobmoo/ui/theme/app_colors.dart';

double _letterSpacing(double fontSize, double percent) =>
    (fontSize * percent).sp;

TextStyle _textStyle({
  required double fontSize,
  required double letterSpacingPercent,
  required FontWeight fontWeight,
  Color color = AppColors.colorBlack,
}) => TextStyle(
  fontSize: fontSize.sp,
  letterSpacing: _letterSpacing(fontSize, letterSpacingPercent),
  fontWeight: fontWeight,
  color: color,
);

class AppTypography {
  static const head = _Head();
  static const caption = _Caption();
  static const button = _Button();
  static const search = _Search();
}

class _Head {
  const _Head();

  TextStyle get b48 => _textStyle(
    fontSize: 48,
    letterSpacingPercent: 0.04,
    fontWeight: FontWeight.w700,
  );

  TextStyle get b30 => _textStyle(
    fontSize: 30,
    letterSpacingPercent: 0.04,
    fontWeight: FontWeight.w700,
  );

  TextStyle get b21 => _textStyle(
    fontSize: 21,
    letterSpacingPercent: 0.05,
    fontWeight: FontWeight.w700,
  );

  TextStyle get sb18 => _textStyle(
    fontSize: 18,
    letterSpacingPercent: 0.05,
    fontWeight: FontWeight.w600,
  );
}

class _Caption {
  const _Caption();

  TextStyle get m15 => _textStyle(
    fontSize: 15,
    letterSpacingPercent: 0.02,
    fontWeight: FontWeight.w500,
  );

  TextStyle get r15 => _textStyle(
    fontSize: 15,
    letterSpacingPercent: 0.02,
    fontWeight: FontWeight.w400,
  );

  TextStyle get sb11 => _textStyle(
    fontSize: 11,
    letterSpacingPercent: 0.02,
    fontWeight: FontWeight.w600,
  );

  TextStyle get sb9 => _textStyle(
    fontSize: 9,
    letterSpacingPercent: 0.02,
    fontWeight: FontWeight.w600,
  );
}

class _Button {
  const _Button();

  TextStyle get sb12 => _textStyle(
    fontSize: 12,
    letterSpacingPercent: 0.02,
    fontWeight: FontWeight.w600,
  );

  TextStyle get sb11 => _textStyle(
    fontSize: 11,
    letterSpacingPercent: 0.04,
    fontWeight: FontWeight.w600,
  );
}

class _Search {
  const _Search();

  TextStyle get b17 => _textStyle(
    fontSize: 17,
    letterSpacingPercent: 0.04,
    fontWeight: FontWeight.w700,
  );

  TextStyle get b15 => _textStyle(
    fontSize: 15,
    letterSpacingPercent: 0.02,
    fontWeight: FontWeight.w700,
  );

  TextStyle get sb15 => _textStyle(
    fontSize: 15,
    letterSpacingPercent: 0.02,
    fontWeight: FontWeight.w600,
  );

  TextStyle get sb12 => _textStyle(
    fontSize: 12,
    letterSpacingPercent: 0.02,
    fontWeight: FontWeight.w600,
  );
}
