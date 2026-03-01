import 'package:bobmoo/models/university.dart';
import 'package:bobmoo/providers/search_provider.dart';
import 'package:bobmoo/ui/components/buttons/primary_button.dart';
import 'package:bobmoo/ui/theme/app_colors.dart';
import 'package:bobmoo/ui/theme/app_shadow.dart';
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
  University? _selectedUniv;

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      // Appbar의 기본 여백 제거
      titleSpacing: 0,
      backgroundColor: AppColors.colorGray4,
      // 온보딩화면 -> false, 설정화면 -> true
      automaticallyImplyLeading: widget.allowBack,
      scrolledUnderElevation: 0,
      title: Padding(
        padding: EdgeInsets.only(left: 27.w, top: 10.h),
        child: Text(
          "학교찾기",
          style: AppTypography.head.b30,
        ),
      ),
      toolbarHeight: 98.h,
    );
  }

  @override
  Widget build(BuildContext context) {
    final univs = context.select((SearchProvider p) => p.filteredItems);

    return PopScope(
      canPop: widget.allowBack,
      child: Scaffold(
        backgroundColor: AppColors.colorGray4,
        appBar: _buildAppBar(),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 23.w),
          child: Column(
            children: [
              _buildSearchField(),
              SizedBox(height: 25.h),

              _buildSearchResult(univs),
              SizedBox(height: 27.h),

              if (_selectedUniv != null) ...[
                PrimaryButton(
                  text: "선택완료",
                  onTap: () {
                    Navigator.of(context).pop(_selectedUniv);
                  },
                ),
                SizedBox(height: 27.h),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Expanded _buildSearchResult(List<University> univs) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 18.h,
          horizontal: 17.w,
        ),
        decoration: BoxDecoration(
          color: AppColors.colorWhite,
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: const [AppShadow.card],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "검색 결과 ${univs.length}",
              style: AppTypography.search.b15,
            ),

            SizedBox(height: 10.h),

            Expanded(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: univs.length,
                itemBuilder: (context, index) {
                  final university = univs[index];

                  return ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 3.w),
                    minTileHeight: 58.h,
                    trailing: _selectedUniv == university
                        ? Icon(Icons.check, size: 25.h)
                        : null,
                    iconColor: AppColors.colorGray3,
                    title: Text(
                      university.schoolNameK,
                      style: AppTypography.search.b17,
                    ),
                    onTap: () {
                      setState(() {
                        _selectedUniv = _selectedUniv == university
                            ? null
                            : university;
                      });
                    },
                  );
                },
                separatorBuilder: (context, index) => Divider(
                  thickness: 1,
                  color: AppColors.colorGray5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: const [AppShadow.card],
      ),
      height: 48.h,
      child: TextField(
        onChanged: (value) =>
            context.read<SearchProvider>().updateKeyword(value),
        autofocus: false,
        style: AppTypography.search.sb15,
        decoration: InputDecoration(
          hintText: "학교를 검색해 주세요",
          hintStyle: AppTypography.search.sb15.copyWith(
            color: AppColors.colorGray3,
          ),
          suffixIcon: Icon(
            Icons.search,
            size: 25.w,
            weight: 2.w,
          ),
          filled: true,
          fillColor: AppColors.colorWhite,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 15.w,
            vertical: 13.h,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.r),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.r),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.r),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
