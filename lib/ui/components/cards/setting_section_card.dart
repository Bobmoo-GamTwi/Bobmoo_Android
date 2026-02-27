import 'package:bobmoo/ui/theme/app_colors.dart';
import 'package:bobmoo/ui/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingSectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const SettingSectionCard({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        color: AppColors.colorWhite,
      ),
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 18.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.caption.sb11.copyWith(
              color: AppColors.colorGray3,
            ),
          ),
          SizedBox(
            height: 8.h,
          ),
          child,
        ],
      ),
    );
  }
}
