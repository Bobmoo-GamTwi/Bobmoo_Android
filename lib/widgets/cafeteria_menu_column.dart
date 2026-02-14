import 'package:bobmoo/models/meal_by_cafeteria.dart';
import 'package:bobmoo/models/menu_model.dart';
import 'package:bobmoo/widgets/meal_item_row.dart';
import 'package:bobmoo/widgets/open_status_badge.dart';
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
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                // 자간 5%
                letterSpacing: 18.sp * 0.05,
                // 행간 170%
                height: 1.7,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                _hoursTextForMealType(data.hours, mealType),
                style: TextStyle(
                  fontSize: 9.sp,
                  color: Colors.black54,
                  fontWeight: FontWeight.w600,
                ),
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
        SizedBox(height: 3.h),
        // 식당의 메뉴들
        ...data.meals.map((meal) => MealItemRow(meal: meal)),
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
