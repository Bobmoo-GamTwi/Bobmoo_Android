import 'dart:convert';

import 'package:bobmoo/models/university.dart';
import 'package:bobmoo/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectSchoolScreen extends StatefulWidget {
  final bool allowBack;

  const SelectSchoolScreen({
    super.key,
    required this.allowBack,
  });

  @override
  State<SelectSchoolScreen> createState() => _SelectSchoolScreenState();
}

class _SelectSchoolScreenState extends State<SelectSchoolScreen> {
  List<University>? univs;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUniversities();
  }

  Future<void> _loadUniversities() async {
    final universities = await loadUniversities();
    if (mounted) {
      setState(() {
        univs = universities;
        _isLoading = false;
      });
    }
  }

  Future<List<University>> loadUniversities() async {
    // universities.json 파일에서 대학목록을 불러옵니다.
    // TODO: 이후에 대학 목록 API와 연동시켜야함.
    final String jsonString = await rootBundle.loadString(
      'assets/data/universities.json',
    );
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => University.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SplashScreen();
    }

    return PopScope(
      canPop: widget.allowBack,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          // Appbar의 기본 여백 제거
          titleSpacing: 0,
          backgroundColor: Colors.white,
          // 온보딩화면 -> false, 설정화면 -> true
          automaticallyImplyLeading: widget.allowBack,
          scrolledUnderElevation: 0,
          title: Padding(
            padding: EdgeInsets.only(left: 36.w),
            child: Text(
              "학교찾기",
              style: TextStyle(
                fontSize: 30.sp,
                fontWeight: FontWeight.w700,
                // 자간 5% (픽셀 계산)
                letterSpacing: 30.sp * 0.05,
                // 행간 170%
                height: 1.7,
              ),
            ),
          ),
          toolbarHeight: 110.h,
        ),
        body: ListView.separated(
          physics: const BouncingScrollPhysics(),
          itemCount: univs?.length ?? 0,
          itemBuilder: (context, index) {
            final university = univs![index];

            return ListTile(
              title: Text(university.name),
              onTap: () {
                Navigator.of(context).pop(university);
              },
            );
          },
          separatorBuilder: (context, index) => Divider(
            thickness: 1.5,
            color: Colors.black.withValues(alpha: 0.3),
          ),
        ),
      ),
    ); //TODO: 학교찾기 구현(학교선택)
  }
}
