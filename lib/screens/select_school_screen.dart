import 'package:bobmoo/providers/search_provider.dart';
import 'package:bobmoo/ui/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

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
  @override
  Widget build(BuildContext context) {
    final univs = context.watch<SearchProvider>().filteredItems;

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
        body: Column(
          children: [
            TextField(
              onChanged: (value) =>
                  context.read<SearchProvider>().updateKeyword(value),
              decoration: InputDecoration(
                hintText: "학교를 검색하세요",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              autofocus: true,
            ),
            Expanded(
              child: univs.isEmpty
                  ? Center(
                      child: Text("검색 결과가 없습니다"),
                    )
                  : ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemCount: univs.length,
                      itemBuilder: (context, index) {
                        final university = univs[index];

                        return ListTile(
                          title: Text(
                            university.name,
                            style: AppTypography.search.b17,
                          ),
                          onTap: () {
                            Navigator.of(context).pop(university);
                          },
                        );
                      },
                      separatorBuilder: (context, index) => Divider(
                        thickness: 1,
                        color: Colors.black.withValues(alpha: 0.3),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
