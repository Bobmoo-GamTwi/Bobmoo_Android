import 'package:flutter/material.dart';

class AppColors {
  // 인스턴스화 방지 (C++의 static class처럼 사용)
  AppColors._();

  static const Color primaryNeutral = Color(0x0061656f);

  // --- 텍스트 컬러 (Grayscale) ---
  static const Color greyTextColor = Color(0xFF8B8787);
  static const Color grayDividerColor = Color(0xFF797979); // 리스트 구분선

  // --- 상태 표시 컬러 (운영중, 종료 등) ---
  static const Color statusRed = Color(0xFFFF2200); // '운영종료' 뱃지
  static const Color statusBlue = Color(0xFF0064FB); // '운영중' 뱃지
  static const Color statusGray = Color(0xFF797979); // '운영전' 뱃지

  // --- 배경 컬러 ---
  static const Color background = Color(0xFFF5F5F5); // 앱 전체 배경 회색

  // --- Figma 컬러 ---
  static const Color colorRed = Color(0xFFFF2200);
  static const Color colorBlue = Color(0xFF0064FB);

  static const Color colorGray1 = Color(0xFFEBEBEB);
  static const Color colorGray2 = Color(0xFFD9D9D9);
  static const Color colorGray3 = Color(0xFF61656F);
  static const Color colorGray4 = Color(0xFFF5F5F5);
  static const Color colorGray5 = Color(0xFF8F8F8F);
  static const Color colorBlack = Color(0xFF000000);
  static const Color colorWhite = Color(0xFFFFFFFF);
  static const Color colorWhite10 = Color(0x1AFFFFFF); // 10% 투명도
}
