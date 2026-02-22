import 'package:flutter/material.dart';

class AppShadow {
  AppShadow._(); // 인스턴스화 방지

  static const BoxShadow card = BoxShadow(
    color: Color(0x40000000), // 불투명도 25%
    offset: Offset(0, 4),
    blurRadius: 4,
    spreadRadius: 0,
  );
}
