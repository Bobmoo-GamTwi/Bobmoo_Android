import 'package:bobmoo/constants/app_colors.dart';
import 'package:bobmoo/models/menu_model.dart';
import 'package:flutter/material.dart';
import 'package:bobmoo/utils/hours_parser.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OpenStatusBadge extends StatelessWidget {
  final Hours hours;
  final String mealType; // '아침' | '점심' | '저녁'
  final DateTime now;
  final DateTime selectedDate;

  OpenStatusBadge({
    super.key,
    required this.hours,
    required this.mealType,
    required this.selectedDate,
    DateTime? now,
  }) : now = now ?? DateTime.now();

  @override
  Widget build(BuildContext context) {
    final hoursString = switch (mealType) {
      '아침' => hours.breakfast,
      '점심' => hours.lunch,
      '저녁' => hours.dinner,
      _ => '',
    };

    if (hoursString.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    final status = getStatusForHours(hoursString, now, selectedDate);
    switch (status) {
      case OpenStatus.before:
        return _StatusBadge(
          text: '운영전',
          backgroundColor: AppColors.statusGray,
          textColor: Colors.white,
        );
      case OpenStatus.open:
        return _StatusBadge(
          text: '운영중',
          backgroundColor: AppColors.statusBlue,
          textColor: Colors.white,
        );
      case OpenStatus.after:
        return _StatusBadge(
          text: '운영종료',
          backgroundColor: AppColors.statusRed,
          textColor: Colors.white,
        );
      case OpenStatus.unknown:
        return const SizedBox.shrink();
    }
  }
}

enum OpenStatus { before, open, after, unknown }

class _StatusBadge extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;

  const _StatusBadge({
    required this.text,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 1.5.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w500,
          // 자간 4%
          letterSpacing: 11.sp * 0.04,
          // 행간 21px
          height: 2.0,
          color: textColor,
        ),
      ),
    );
  }
}

/// 주어진 hours 문자열(예: "08:00-09:30", "11:30~14:00", "08:00-09:00/11:30-13:30")을 해석하여 현재 상태를 계산
OpenStatus getStatusForHours(
  String hoursString,
  DateTime now,
  DateTime selectedDate,
) {
  final ranges = parseTimeRanges(
    s: hoursString,
    now: now,
    selectedDate: selectedDate,
  );
  if (ranges.isEmpty) return OpenStatus.unknown;

  ranges.sort((a, b) => a.$1.compareTo(b.$1));

  // 선택된 날짜와 현재 날짜를 비교
  final today = DateTime(now.year, now.month, now.day);
  final selectedDay = DateTime(
    selectedDate.year,
    selectedDate.month,
    selectedDate.day,
  );

  // 과거 날짜인 경우 무조건 운영종료
  if (selectedDay.isBefore(today)) {
    return OpenStatus.after;
  }

  // 미래 날짜인 경우 무조건 운영전
  if (selectedDay.isAfter(today)) {
    return OpenStatus.before;
  }

  // 오늘 날짜인 경우 실제 시간으로 판단
  final selectedDateTime = DateTime(
    selectedDate.year,
    selectedDate.month,
    selectedDate.day,
    now.hour,
    now.minute,
    now.second,
  );

  final isOpen = ranges.any(
    (r) => selectedDateTime.isAfter(r.$1) && selectedDateTime.isBefore(r.$2),
  );
  if (isOpen) return OpenStatus.open;

  final earliestStart = ranges.first.$1;
  if (selectedDateTime.isBefore(earliestStart)) return OpenStatus.before;

  final latestEnd = ranges
      .map((r) => r.$2)
      .reduce((a, b) => a.isAfter(b) ? a : b);
  if (selectedDateTime.isAfter(latestEnd)) return OpenStatus.after;

  // 운영 중, 전, 후가 아닌 모든 경우 (예: 오전/오후 운영 사이의 쉬는 시간)
  // hoursString가 "08:00-09:00/11:30-13:30" 이런식일때
  return OpenStatus.unknown;
}
