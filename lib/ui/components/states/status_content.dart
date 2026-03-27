import 'package:bobmoo/ui/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatusContent extends StatelessWidget {
  const StatusContent({
    super.key,
    required this.icon,
    required this.description,
    this.title,
    this.bottom,
  });

  final Widget icon;
  final String? title;
  final Widget description;
  final Widget? bottom;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        icon,
        SizedBox(height: 24.h),
        if (title != null) ...[
          Text(
            title!,
            textAlign: TextAlign.center,
            style: AppTypography.head.sb18,
          ),
          SizedBox(height: 21.h),
        ],
        description,
        if (bottom != null) ...[
          SizedBox(height: 118.h),
          bottom!,
        ],
      ],
    );
  }
}

