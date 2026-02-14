import 'package:flutter/material.dart';

class AppColors {
  // 인스턴스화 방지 (C++의 static class처럼 사용)
  AppColors._();

  // --- 텍스트 컬러 (Grayscale) ---
  static const Color greyTextColor = Color(0xFF8B8787);
  static const Color grayDividerColor = Color(0xFF797979); // 리스트 구분선

  // --- 상태 표시 컬러 (운영중, 종료 등) ---
  static const Color statusRed = Color(0xFFFF2200); // '운영종료' 뱃지
  static const Color statusBlue = Color(0xFF0064FB); // '운영중' 뱃지
  static const Color statusGray = Color(0xFF797979); // '운영전' 뱃지

  // --- 배경 컬러 ---
  static const Color background = Color(0xFFF5F5F5); // 앱 전체 배경 회색
}
