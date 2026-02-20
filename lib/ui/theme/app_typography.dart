import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

double _letterSpacing(double fontSize, double percent) =>
    (fontSize * percent).sp;

class AppTypography {
  static const head = _Head();
  static const caption = _Caption();
  static const button = _Button();
  static const search = _Search();
}

class _Head {
  const _Head();

  TextStyle get b48 => TextStyle(
    fontSize: 48.sp,
    letterSpacing: _letterSpacing(48, 0.04),
    fontWeight: FontWeight.w700,
  );

  TextStyle get b30 => TextStyle(
    fontSize: 30.sp,
    letterSpacing: _letterSpacing(30, 0.04),
    fontWeight: FontWeight.w700,
  );

  TextStyle get b21 => TextStyle(
    fontSize: 21.sp,
    letterSpacing: _letterSpacing(21, 0.05),
    fontWeight: FontWeight.w700,
  );

  TextStyle get sb18 => TextStyle(
    fontSize: 18.sp,
    letterSpacing: _letterSpacing(18, 0.05),
    fontWeight: FontWeight.w600,
  );
}

class _Caption {
  const _Caption();

  TextStyle get m15 => TextStyle(
    fontSize: 15.sp,
    letterSpacing: _letterSpacing(15, 0.02),
    fontWeight: FontWeight.w500,
  );

  TextStyle get r15 => TextStyle(
    fontSize: 15.sp,
    letterSpacing: _letterSpacing(15, 0.02),
    fontWeight: FontWeight.w400,
  );

  TextStyle get sb11 => TextStyle(
    fontSize: 11.sp,
    letterSpacing: _letterSpacing(11, 0.02),
    fontWeight: FontWeight.w600,
  );

  TextStyle get sb9 => TextStyle(
    fontSize: 9.sp,
    letterSpacing: _letterSpacing(9, 0.02),
    fontWeight: FontWeight.w600,
  );
}

class _Button {
  const _Button();

  TextStyle get sb12 => TextStyle(
    fontSize: 12.sp,
    letterSpacing: _letterSpacing(12, 0.02),
    fontWeight: FontWeight.w600,
  );

  TextStyle get sb11 => TextStyle(
    fontSize: 11.sp,
    letterSpacing: _letterSpacing(11, 0.04),
    fontWeight: FontWeight.w600,
  );
}

class _Search {
  const _Search();

  TextStyle get b17 => TextStyle(
    fontSize: 17.sp,
    letterSpacing: _letterSpacing(17, 0.04),
    fontWeight: FontWeight.w700,
  );

  TextStyle get b15 => TextStyle(
    fontSize: 15.sp,
    letterSpacing: _letterSpacing(15, 0.02),
    fontWeight: FontWeight.w700,
  );

  TextStyle get sb15 => TextStyle(
    fontSize: 15.sp,
    letterSpacing: _letterSpacing(15, 0.02),
    fontWeight: FontWeight.w600,
  );

  TextStyle get sb12 => TextStyle(
    fontSize: 12.sp,
    letterSpacing: _letterSpacing(12, 0.02),
    fontWeight: FontWeight.w600,
  );
}
