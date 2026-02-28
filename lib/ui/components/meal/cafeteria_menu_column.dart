import 'package:bobmoo/models/meal_by_cafeteria.dart';
import 'package:bobmoo/models/menu_model.dart';
import 'package:bobmoo/ui/components/meal/meal_item_row.dart';
import 'package:bobmoo/ui/components/meal/open_status_badge.dart';
import 'package:bobmoo/ui/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CafeteriaMenuColumn extends StatelessWidget {
  final MealByCafeteria data;
  final String mealType;
  final DateTime selectedDate;

  const CafeteriaMenuColumn({
    super.key,
    required this.data,
    required this.mealType,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 식당 이름
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              data.cafeteriaName,
              style: AppTypography.head.sb18,
            ),
            SizedBox(width: 5.w),
            Expanded(
              child: Text(
                _hoursTextForMealType(data.hours, mealType),
                style: AppTypography.caption.sb9,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            OpenStatusBadge(
              hours: data.hours,
              mealType: mealType,
              selectedDate: selectedDate,
            ),
          ],
        ),
        // 식당의 메뉴들
        ListView.builder(
          padding: EdgeInsets.zero,
          // 내용만큼 크기를 줄이도록 설정
          shrinkWrap: true,
          // 스크롤 방지
          physics: const NeverScrollableScrollPhysics(),
          itemCount: data.meals.length,
          itemBuilder: (BuildContext context, int index) {
            // 각 인덱스에 해당하는 식당 메뉴 위젯을 반환
            return Padding(
              padding: EdgeInsets.all(3.w),
              child: MealItemRow(meal: data.meals[index]),
            );
          },
        ),
      ],
    );
  }
}

String _hoursTextForMealType(Hours hours, String mealType) {
  return switch (mealType) {
    '아침' => hours.breakfast.isNotEmpty ? '(${hours.breakfast})' : '',
    '점심' => hours.lunch.isNotEmpty ? '(${hours.lunch})' : '',
    '저녁' => hours.dinner.isNotEmpty ? '(${hours.dinner})' : '',
    // '_' 는 default와 같습니다.
    _ => '', // 아이콘이 없는 경우 빈 공간
  };
}
