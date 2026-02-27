import 'package:bobmoo/ui/components/cards/setting_section_card.dart';
import 'package:bobmoo/ui/theme/app_colors.dart';
import 'package:bobmoo/models/university.dart';
import 'package:bobmoo/providers/univ_provider.dart';
import 'package:bobmoo/services/permission_service.dart';
import 'package:bobmoo/ui/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
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
  // initState에서 권한 상태를 가져오기 위해 Future 사용 // TODO: 삭제 예정
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

    // TODO: 삭제 예정
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

  // TODO: 삭제 예정
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

  // TODO: 삭제 예정
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
        backgroundColor: AppColors.colorBlack,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 19.w, vertical: 30.h),
        children: [
          SettingSectionCard(
            title: "학교 설정",
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _openSelectSchool,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          context.watch<UnivProvider>().univName,
                          style: AppTypography.caption.m15,
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: AppColors.colorGray3,
                          size: 20.w,
                        ),
                      ],
                    ),
                    SizedBox(height: 3.h),
                    Divider(
                      height: 1.h,
                      thickness: 1.h,
                      color: AppColors.colorGray5,
                    ),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(height: 20.h),

          // 대표 식당 선택 카드
          SettingSectionCard(
            title: "위젯 설정",
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '기본 위젯에 표시될 식당을 선택하세요',
                            style: AppTypography.caption.m15,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                // 식당 선택 칩들
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: _cafeteriaList.map((cafeteria) {
                    final isSelected = _selectedCafeteria == cafeteria;
                    return GestureDetector(
                      onTap: () => _saveSelectedCafeteria(cafeteria),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 10.h,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.colorBlack
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        child: Text(
                          cafeteria,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: isSelected
                                ? AppColors.colorWhite
                                : AppColors.colorBlack,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          SizedBox(height: 20.h),

          // // 위젯 실시간 업데이트 카드
          // FutureBuilder<bool>(
          //   future: _permissionFuture,
          //   builder: (context, snapshot) {
          //     if (snapshot.connectionState == ConnectionState.waiting) {
          //       return _buildSettingsCard(
          //         child: Row(
          //           children: [
          //             SizedBox(
          //               width: 20.w,
          //               height: 20.w,
          //               child: CircularProgressIndicator(
          //                 strokeWidth: 2,
          //                 color: univColor,
          //               ),
          //             ),
          //             SizedBox(width: 16.w),
          //             Text(
          //               '권한 상태를 확인 중...',
          //               style: TextStyle(
          //                 fontSize: 14.sp,
          //                 color: AppColors.greyTextColor,
          //               ),
          //             ),
          //           ],
          //         ),
          //       );
          //     }

          //     final bool hasPermission = snapshot.data ?? false;

          //     return _buildSettingsCard(
          //       onTap: () async {
          //         await PermissionService.openAlarmPermissionSettings();
          //         setState(() {
          //           _permissionFuture =
          //               PermissionService.canScheduleExactAlarms();
          //         });
          //       },
          //       child: Row(
          //         children: [
          //           Container(
          //             padding: EdgeInsets.all(8.w),
          //             decoration: BoxDecoration(
          //               color: hasPermission
          //                   ? Colors.green.withValues(alpha: 0.1)
          //                   : Colors.orange.withValues(alpha: 0.1),
          //               borderRadius: BorderRadius.circular(8.r),
          //             ),
          //             child: Icon(
          //               hasPermission ? Icons.update : Icons.schedule,
          //               color: hasPermission ? Colors.green : Colors.orange,
          //               size: 22.w,
          //             ),
          //           ),
          //           SizedBox(width: 12.w),
          //           Expanded(
          //             child: Column(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: [
          //                 Text(
          //                   '위젯 실시간 업데이트',
          //                   style: TextStyle(
          //                     fontSize: 16.sp,
          //                     fontWeight: FontWeight.w600,
          //                     color: Colors.black87,
          //                   ),
          //                 ),
          //                 SizedBox(height: 2.h),
          //                 Text(
          //                   hasPermission
          //                       ? '활성화됨 · 매분 자동 업데이트'
          //                       : '비활성화됨 · 탭하여 권한 설정',
          //                   style: TextStyle(
          //                     fontSize: 12.sp,
          //                     color: hasPermission
          //                         ? Colors.green.shade600
          //                         : AppColors.greyTextColor,
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ),
          //           Container(
          //             padding: EdgeInsets.symmetric(
          //               horizontal: 10.w,
          //               vertical: 4.h,
          //             ),
          //             decoration: BoxDecoration(
          //               color: hasPermission
          //                   ? Colors.green.withValues(alpha: 0.1)
          //                   : Colors.orange.withValues(alpha: 0.1),
          //               borderRadius: BorderRadius.circular(12.r),
          //             ),
          //             child: Text(
          //               hasPermission ? 'ON' : 'OFF',
          //               style: TextStyle(
          //                 fontSize: 12.sp,
          //                 fontWeight: FontWeight.w700,
          //                 color: hasPermission ? Colors.green : Colors.orange,
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //     );
          //   },
          // ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              color: AppColors.colorWhite,
            ),
            padding: EdgeInsets.symmetric(vertical: 13.h, horizontal: 10.w),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/icon_bob.svg',
                  width: 35.w,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '밥묵자',
                        style: AppTypography.caption.m15,
                      ),
                    ],
                  ),
                ),
                Text(
                  _appVersion,
                  style: AppTypography.caption.sb11.copyWith(
                    color: AppColors.colorGray3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      toolbarHeight: 111.h,
      backgroundColor: AppColors.colorWhite,
      automaticallyImplyLeading: false, // 기본 leading 끄기
      title: null,
      flexibleSpace: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 60.h, left: 10.w, right: 10.w),
          child: SizedBox(
            height: 56.h,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Leading
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      color: AppColors.colorGray3,
                      size: 26.w,
                      weight: 2,
                    ),
                  ),
                ),

                // Title
                Text(
                  "설정",
                  style: AppTypography.head.b21,
                ),
              ],
            ),
          ),
        ),
      ),

      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(
          height: 1.h,
          thickness: 1.h,
          color: AppColors.colorGray5,
        ),
      ),
    );
  }
}
