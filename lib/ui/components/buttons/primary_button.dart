import 'package:bobmoo/ui/theme/app_colors.dart';
import 'package:bobmoo/ui/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 53.h,
      width: double.infinity,
      child: Material(
        color: AppColors.colorBlack,
        borderRadius: BorderRadius.circular(15.r),
        child: InkWell(
          onTap: isLoading ? null : onTap,
          borderRadius: BorderRadius.circular(15.r),
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: 20.w,
                    height: 20.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    text,
                    style: AppTypography.head.b21.copyWith(
                      color: AppColors.colorWhite,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
