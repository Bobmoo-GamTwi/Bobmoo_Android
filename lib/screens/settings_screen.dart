import 'package:bobmoo/constants/app_colors.dart';
import 'package:bobmoo/providers/univ_provider.dart';
import 'package:bobmoo/services/permission_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_widget/home_widget.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with WidgetsBindingObserver {
  // initState에서 권한 상태를 가져오기 위해 Future 사용
  late Future<bool> _permissionFuture;

  /// 설정에서 1x1 위젯에 대표 식당으로 사용 가능한 전체 식당 리스트
  /// TODO: 나중에 enum 같은걸 만들어서 대학별로 식당목록 관리하기
  final List<String> _cafeteriaList = ['생활관식당', '학생식당', '교직원식당'];

  /// 현재 선택된 대표 식당
  String? _selectedCafeteria;

  /// 앱 버전 정보
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    // 앱 라이프사이클 변경 감지를 위해 옵저버 등록
    WidgetsBinding.instance.addObserver(this);

    _permissionFuture = PermissionService.canScheduleExactAlarms();

    // 설정 화면에 진입하면 배너 닫힘 상태를 초기화합니다.
    _resetBannerDismissalStatus();

    _loadSelectedCafeteria();
    _loadAppVersion();
  }

  @override
  void dispose() {
    // 옵저버 해제
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // 시스템 설정에서 돌아왔을 때 (앱이 다시 활성화될 때)
    if (state == AppLifecycleState.resumed) {
      setState(() {
        _permissionFuture = PermissionService.canScheduleExactAlarms();
      });
    }
  }

  /// 앱 버전 정보를 불러옵니다.
  Future<void> _loadAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        // version: pubspec.yaml의 version (예: 1.0.0)
        // buildNumber: 빌드 번호 (예: 1)
        _appVersion = 'v${packageInfo.version}';
      });
    }
  }

  Future<void> _resetBannerDismissalStatus() async {
    final prefs = await SharedPreferences.getInstance();
    // '닫음' 상태를 false로 되돌려서, 홈 화면에서 배너가 다시 보일 수 있도록 함
    await prefs.setBool('permissionBannerDismissed', false);
  }

  /// 화면이 로드될 때 저장된 대표 식당 설정을 불러옵니다.
  Future<void> _loadSelectedCafeteria() async {
    // SharedPreferences 대신 HomeWidget에서 데이터를 직접 읽어옵니다.
    final storedName = await HomeWidget.getWidgetData<String>(
      'selectedCafeteriaName',
      defaultValue: _cafeteriaList.first,
    );
    // mounted 체크 추가
    if (mounted) {
      setState(() {
        _selectedCafeteria = storedName;
      });
    }
  }

  Future<void> _saveSelectedCafeteria(
    String cafeteriaName,
    Color univColor,
  ) async {
    // SharedPreferences 대신 HomeWidget을 사용하여 데이터를 저장합니다.
    await HomeWidget.saveWidgetData<String>(
      'selectedCafeteriaName',
      cafeteriaName,
    );

    setState(() {
      _selectedCafeteria = cafeteriaName;
    });

    // 2x2 위젯과 4x2 위젯 모두에게 업데이트하라는 신호를 보냅니다.
    await HomeWidget.updateWidget(
      qualifiedAndroidName: 'com.hwoo.bobmoo.MealGlanceWidgetReceiver',
    );
    await HomeWidget.updateWidget(
      qualifiedAndroidName: 'com.hwoo.bobmoo.AllCafeteriasGlanceWidgetReceiver',
    );

    // async 함수에서 context를 사용할 때는 항상 mounted 여부를 확인하는 것이 안전합니다.
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '위젯 설정이 변경되었습니다.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: univColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final univColor = context.watch<UnivProvider>().univColor;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70.h,
        backgroundColor: univColor,
        elevation: 4.0,
        shadowColor: Colors.black,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 22.w,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          '설정',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 20.sp * 0.03,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        children: [
          // --- 학교 설정 섹션 (추후 확장 가능) ---
          _buildSectionTitle('학교 설정'),
          SizedBox(height: 12.h),

          // 학교 설정 카드
          _buildSettingsCard(
            onTap: () {
              context.read<UnivProvider>().updateUniversity(null);
              Navigator.pop(context);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '내 학교 : ${context.watch<UnivProvider>().univName}',
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '학교설정',
                      style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: AppColors.greyTextColor,
                      size: 24.w,
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 32.h),

          // --- 위젯 설정 섹션 ---
          _buildSectionTitle('위젯 설정'),
          SizedBox(height: 12.h),

          // 대표 식당 선택 카드
          _buildSettingsCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: univColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        Icons.restaurant_menu,
                        color: univColor,
                        size: 22.w,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '2x2 위젯 대표 식당',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            '기본 위젯에 표시될 식당을 선택하세요',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.greyTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                // 식당 선택 칩들
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: _cafeteriaList.map((cafeteria) {
                    final isSelected = _selectedCafeteria == cafeteria;
                    return GestureDetector(
                      onTap: () => _saveSelectedCafeteria(cafeteria, univColor),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 10.h,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected ? univColor : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: isSelected
                                ? univColor
                                : Colors.grey.shade300,
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          cafeteria,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          SizedBox(height: 16.h),

          // 위젯 실시간 업데이트 카드
          FutureBuilder<bool>(
            future: _permissionFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildSettingsCard(
                  child: Row(
                    children: [
                      SizedBox(
                        width: 20.w,
                        height: 20.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: univColor,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Text(
                        '권한 상태를 확인 중...',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.greyTextColor,
                        ),
                      ),
                    ],
                  ),
                );
              }

              final bool hasPermission = snapshot.data ?? false;

              return _buildSettingsCard(
                onTap: () async {
                  await PermissionService.openAlarmPermissionSettings();
                  setState(() {
                    _permissionFuture =
                        PermissionService.canScheduleExactAlarms();
                  });
                },
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: hasPermission
                            ? Colors.green.withValues(alpha: 0.1)
                            : Colors.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        hasPermission ? Icons.update : Icons.schedule,
                        color: hasPermission ? Colors.green : Colors.orange,
                        size: 22.w,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '위젯 실시간 업데이트',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            hasPermission
                                ? '활성화됨 · 매분 자동 업데이트'
                                : '비활성화됨 · 탭하여 권한 설정',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: hasPermission
                                  ? Colors.green.shade600
                                  : AppColors.greyTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: hasPermission
                            ? Colors.green.withValues(alpha: 0.1)
                            : Colors.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        hasPermission ? 'ON' : 'OFF',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: hasPermission ? Colors.green : Colors.orange,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          SizedBox(height: 32.h),

          // --- 앱 정보 섹션 (추후 확장 가능) ---
          _buildSectionTitle('앱 정보'),
          SizedBox(height: 12.h),

          _buildSettingsCard(
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: univColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.info_outline,
                    color: univColor,
                    size: 22.w,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '밥묵자',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        '인하대학교 학식 정보 앱',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.greyTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  _appVersion,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.greyTextColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 섹션 제목 위젯
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.greyTextColor,
          letterSpacing: 13.sp * 0.02,
        ),
      ),
    );
  }

  /// 설정 카드 위젯
  Widget _buildSettingsCard({
    required Widget child,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16.r),
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: child,
        ),
      ),
    );
  }
}
