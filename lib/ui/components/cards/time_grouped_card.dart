import 'package:bobmoo/ui/theme/app_colors.dart';
import 'package:bobmoo/models/meal_by_cafeteria.dart';
import 'package:bobmoo/ui/theme/app_typography.dart';
import 'package:bobmoo/ui/components/meal/cafeteria_menu_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class TimeGroupedCard extends StatelessWidget {
  final String title;
  final List<MealByCafeteria> mealData;
  final DateTime selectedDate;

  const TimeGroupedCard({
    super.key,
    required this.title,
    required this.mealData,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.black.withValues(alpha: 0.5),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(13.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 섹션 제목 (예: "점심")
            Text(
              title,
              style: AppTypography.head.b21,
            ),
            // 각 식당별 메뉴 목록
            ListView.separated(
              padding: EdgeInsets.zero,
              // 내용만큼 크기를 줄이도록 설정
              shrinkWrap: true,
              // 스크롤 방지
              physics: const NeverScrollableScrollPhysics(),
              itemCount: mealData.length,
              itemBuilder: (BuildContext context, int index) {
                // 각 인덱스에 해당하는 식당 메뉴 위젯을 반환
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 3.w),
                  child: CafeteriaMenuColumn(
                    data: mealData[index],
                    mealType: title,
                    selectedDate: selectedDate,
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                // 각 아이템 사이에 들어갈 구분선 위젯을 반환
                // thickness를 정수로 고정해야 소수 픽셀으로 인한 렌더링 불일치 방지
                return Divider(
                  height: 1,
                  thickness: 2,
                  color: AppColors.colorGray5,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// 아이콘을 결정하는 함수
// ignore: unused_element
Widget _getIconForMeal(String title) {
  // => 를 사용해 바로 위젯을 반환합니다.
  final icon = switch (title) {
    '아침' => SvgPicture.asset(
      'assets/icons/wb_twilight.svg',
      width: 24,
      height: 24,
    ),
    '점심' => const Icon(Icons.wb_sunny_outlined, size: 24),
    '저녁' => const Icon(Icons.dark_mode_outlined, size: 24),
    // '_' 는 default와 같습니다.
    _ => const SizedBox.shrink(), // 아이콘이 없는 경우 빈 공간
  };

  return Padding(
    padding: const EdgeInsets.only(right: 4.0),
    child: icon,
  );
}
