import 'package:bobmoo/models/university.dart';
import 'package:bobmoo/providers/univ_provider.dart';
import 'package:bobmoo/ui/components/buttons/primary_button.dart';
import 'package:bobmoo/ui/theme/app_colors.dart';
import 'package:bobmoo/ui/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 220.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 9.w,
            children: [
              SvgPicture.asset(
                'assets/icons/icon_bob.svg',
                width: 63.w,
              ),
              Text(
                "밥묵자",
                style: AppTypography.head.b48,
              ),
            ],
          ),
          SizedBox(height: 28),
          Text(
            "오늘 학식 뭐지?\n홈 화면에서 바로 확인하세요",
            style: AppTypography.caption.r15.copyWith(
              color: AppColors.colorGray3,
            ),
            textAlign: TextAlign.center,
          ),

          Expanded(child: SizedBox()),

          PrimaryButton(
            text: "시작하기",
            onTap: _openSelectSchool,
          ),
          SizedBox(height: 12.h),
          Text(
            "로그인 없이도 바로 확인할 수 있어요",
            style: AppTypography.caption.sb11.copyWith(
              color: AppColors.colorGray3,
            ),
          ),
          SizedBox(height: 45.h),
        ],
      ),
    );
  }

  Future<void> _openSelectSchool() async {
    final University? university = await Navigator.of(
      context,
    ).pushNamed<University?>("/select_school", arguments: false);

    if (!mounted) return;

    if (university != null) {
      context.read<UnivProvider>().updateUniversity(university);
    }
    Navigator.of(context).pushNamedAndRemoveUntil("/home", (route) => false);
  }
}
