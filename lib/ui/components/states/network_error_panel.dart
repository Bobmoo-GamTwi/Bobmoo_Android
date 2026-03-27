import 'package:bobmoo/ui/components/states/status_content.dart';
import 'package:bobmoo/ui/theme/app_colors.dart';
import 'package:bobmoo/ui/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NetworkErrorPanel extends StatelessWidget {
  final String description;
  final VoidCallback? onRetry;
  final IconData icon;
  final String actionLabel;
  final bool showCard;
  final bool showPullToRefreshHint;

  const NetworkErrorPanel({
    super.key,
    required this.description,
    required this.icon,
    required this.actionLabel,
    this.onRetry,
    this.showCard = false,
    this.showPullToRefreshHint = false,
  });

  Widget _buildDescription() {
    final lines = description
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < lines.length; ++i) ...[
          Text(
            lines[i],
            textAlign: TextAlign.center,
            style: AppTypography.search.sb15.copyWith(
              color: AppColors.colorGray3,
            ),
          ),
          if (i != lines.length - 1) SizedBox(height: 4.h),
        ],
      ],
    );
  }

  Widget _buildPullToRefreshHint() {
    return Column(
      children: [
        Icon(
          Icons.arrow_downward,
          color: AppColors.colorGray3,
          size: 32.w,
        ),
        SizedBox(height: 7.h),
        Text(
          "아래로 당겨 새로고침",
          style: AppTypography.button.sb11.copyWith(
            color: AppColors.colorGray3,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final content = StatusContent(
      icon: Icon(
        icon,
        size: 60.w,
        color: AppColors.colorGray3,
      ),
      description: _buildDescription(),
      bottom: onRetry != null
          ? ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: 22.w,
                  vertical: 14.h,
                ),
                minimumSize: Size(140.w, 48.h),
              ),
              child: Text(
                actionLabel,
                style: AppTypography.button.sb12,
              ),
            )
          : (showPullToRefreshHint ? _buildPullToRefreshHint() : null),
    );

    final padded = Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      child: content,
    );

    return Center(
      child: showCard
          ? Container(
              width: double.infinity,
              margin: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: AppColors.colorWhite,
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: padded,
            )
          : padded,
    );
  }
}
