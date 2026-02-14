import 'package:bobmoo/constants/app_colors.dart';
import 'package:bobmoo/models/menu_model.dart';
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
            style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500),
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
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    );
                  })
                  .toList(),
            ),
          ),
          Padding(
            padding: EdgeInsets.zero,
            child: Text(
              "${meal.price}원",
              style: TextStyle(
                fontSize: 11.sp,
                fontFamily: 'NanumSquareRound',
                fontWeight: FontWeight.w700,
                color: AppColors.greyTextColor,
                // 자간 5%
                letterSpacing: 11.sp * 0.02,
                // 행간 21px
                height: 2.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
