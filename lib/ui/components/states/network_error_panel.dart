import 'package:bobmoo/ui/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NetworkErrorPanel extends StatelessWidget {
  final String description;
  final VoidCallback? onRetry;
  final IconData icon;
  final String actionLabel;

  const NetworkErrorPanel({
    super.key,
    required this.description,
    this.onRetry,
    this.icon = Icons.wifi_off_rounded,
    this.actionLabel = "다시 한 번 찔러보기",
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/icon_bob.svg',
              width: 64.w,
            ),
            SizedBox(height: 14.h),
            Text(
              description,
              textAlign: TextAlign.center,
              style: AppTypography.search.sb15,
            ),
            if (onRetry != null) ...[
              SizedBox(height: 18.h),
              ElevatedButton(
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
              ),
            ],
          ],
        ),
      ),
    );
  }
}
