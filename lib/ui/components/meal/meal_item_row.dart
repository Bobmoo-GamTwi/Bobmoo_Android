import 'package:bobmoo/models/menu_model.dart';
import 'package:bobmoo/ui/theme/app_colors.dart';
import 'package:bobmoo/ui/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MealItemRow extends StatelessWidget {
  final MealItem meal;

  const MealItemRow({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. 코스 (A, B, C...)
          Text(
            "${meal.course} ",
            style: AppTypography.caption.m15,
          ),
          // 2. 메뉴 이름
          Expanded(
            // Warp 위젯을 통해 단어 별로 묶은다음에, 잘리게 된다면 다음줄로 넘어가게
            child: Wrap(
              spacing: 0, // 단어 사이 가로 간격
              runSpacing: 0, // 줄 사이 세로 간격
              children: meal.mainMenu
                  .split(' ') // 쉼표로 분리
                  .asMap()
                  .entries
                  .map((entry) {
                    return Text(
                      "${entry.value} ",
                      style: AppTypography.caption.r15,
                    );
                  })
                  .toList(),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 3.h),
            child: Text(
              "${meal.price}원",
              style: AppTypography.button.sb11.copyWith(
                color: AppColors.colorGray3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
