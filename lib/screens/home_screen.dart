import 'dart:io';

import 'package:bobmoo/collections/meal_collection.dart';
import 'package:bobmoo/constants/app_colors.dart';
import 'package:bobmoo/locator.dart';
import 'package:bobmoo/models/all_cafeterias_widget_data.dart';
import 'package:bobmoo/models/meal_by_cafeteria.dart';
import 'package:bobmoo/models/menu_model.dart';
import 'package:bobmoo/providers/univ_provider.dart';
import 'package:bobmoo/repositories/meal_repository.dart';
import 'package:bobmoo/models/meal_widget_data.dart';
import 'package:bobmoo/screens/settings_screen.dart';
import 'package:bobmoo/services/permission_service.dart';
import 'package:bobmoo/services/widget_service.dart';
import 'package:bobmoo/utils/meal_utils.dart';
import 'package:bobmoo/widgets/time_grouped_card.dart';
import 'package:bobmoo/utils/hours_parser.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final MealRepository _repository = locator<MealRepository>();
  late Future<List<Meal>> _mealFuture;

  /// 선택한 날짜 저장할 상태 변수
  DateTime _selectedDate = DateTime.now();
  // 배너 표시 여부를 제어할 상태 변수
  bool _showPermissionBanner = false;
  // 사용자가 배너를 닫았는지 여부를 저장할 변수
  bool _bannerDismissed = false;

  /// 화면이 처음 나타날 때 데이터 불러오기
  @override
  void initState() {
    super.initState();
    // 앱 상태를 확인하기 위한 옵저버 할당
    WidgetsBinding.instance.addObserver(this);
    // 앱 시작 시 업데이트 확인
    _checkForUpdate();
    // initState에서는 setState를 호출하지 않고, Future를 직접 할당합니다.
    _mealFuture = _fetchData();

    // 앱 시작 시에도 위젯 업데이트
    _updateWidgetOnly();

    // 앱 시작 시 권한 확인
    _checkPermissionAndShowBanner();
  }

  /// 위젯이 영구적으로 제거될때 호출
  @override
  void dispose() {
    // 옵저버 제거
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// 앱의 생명주기 상태 변화를 감지하는 콜백 함수
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // 앱이 포그라운드로 돌아올 때마다 위젯 업데이트
    if (state == AppLifecycleState.resumed) {
      _updateWidgetOnly();

      // 앱이 다시 활성화될 때마다 권한 확인
      _checkPermissionAndShowBanner();
    }
  }

  /// 권한을 확인하고 배너 표시 여부를 결정하는 함수
  Future<void> _checkPermissionAndShowBanner() async {
    // SharedPreferences에서 '닫음' 상태를 먼저 읽어옴
    final prefs = await SharedPreferences.getInstance();
    _bannerDismissed = prefs.getBool('permissionBannerDismissed') ?? false;

    final hasPermission = await PermissionService.canScheduleExactAlarms();
    if (mounted) {
      // 위젯이 화면에 있을 때만 setState 호출
      setState(() {
        _showPermissionBanner = !hasPermission && !_bannerDismissed;
      });
    }
  }

  // 배너 닫기 버튼을 눌렀을 때 실행될 함수
  Future<void> _dismissPermissionBanner() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('permissionBannerDismissed', true);
    setState(() {
      _showPermissionBanner = false;
    });
  }

  /// 인앱 업데이트를 확인하고, 가능하면 유연한 업데이트를 시작하는 함수
  Future<void> _checkForUpdate() async {
    try {
      // 1. 업데이트가 사용 가능한지 확인합니다.
      final AppUpdateInfo updateInfo = await InAppUpdate.checkForUpdate();

      // 2. 업데이트가 있고, 유연한 업데이트(FLEXIBLE)가 허용되는 경우
      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable &&
          updateInfo.flexibleUpdateAllowed) {
        // 3. 유연한 업데이트를 시작합니다.
        await InAppUpdate.startFlexibleUpdate();

        // 4. 다운로드가 완료되면 사용자에게 설치를 요청합니다.
        //    SnackBar나 다른 UI 요소를 사용하여 알릴 수 있습니다.
        await InAppUpdate.completeFlexibleUpdate()
            .then((_) {
              // 이곳에 업데이트 완료 후 처리할 로직을 추가할 수 있습니다.
              if (kDebugMode) {
                print("업데이트가 완료되었습니다.");
              }
            })
            .catchError((e) {
              if (kDebugMode) {
                print(e.toString());
              }
            });
      }
    } catch (e) {
      // 오류 처리
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  /// 데이터 로딩의 비동기 로직 함수
  ///
  /// Repository에게 식단 데이터를 요청한다.
  Future<List<Meal>> _fetchData() async {
    try {
      final meals = await _repository.getMealsForDate(_selectedDate);

      // 데이터 로딩 시에도 조건부 위젯 업데이트
      _updateWidgetOnly();

      return meals;
    } catch (e) {
      if (e is StaleDataException) {
        // 신선도가 떨어진 데이터를 취급하는 경우
        _showStaleDataSnackbar(e);
        // 데이터를 반환하여 화면은 정상적으로 그리도록 함
        return e.staleData;
      } else if (e is SocketException) {
        // 네트워크 연결이 없는경우
        throw NetworkException();
      }
      // 다른 모든 에러는 FutureBuilder로 전달
      rethrow;
    }
  }

  /// 위젯 데이터 업데이트 함수 (오늘날짜)
  Future<void> _updateWidgetOnly() async {
    // 오늘 날짜인 경우에만 위젯 업데이트
    try {
      final today = DateTime.now();
      // 1. 오늘 날짜의 메뉴 데이터 가져오기
      final todayMeals = await _repository.getMealsForDate(today);

      // 2. 데이터를 시간대별로 그룹화
      final groupedMeals = groupMeals(todayMeals);

      // 3. 오늘 운영하는 모든 식당의 고유한 이름과 정보(Hours)를 추출
      final Map<String, Hours> uniqueCafeterias = {};

      // groupedMeals가 비어있으면 이 반복문은 실행되지 않음 -> 안전함
      groupedMeals.values.expand((list) => list).forEach((mealByCafeteria) {
        uniqueCafeterias[mealByCafeteria.cafeteriaName] = mealByCafeteria.hours;
      });

      // 4. 각 식당별로 MealWidgetData 객체를 생성하여 리스트에 담기
      final List<MealWidgetData> allCafeteriasData = [];
      for (var entry in uniqueCafeterias.entries) {
        final cafeteriaName = entry.key;
        final hours = entry.value;

        // 기존 fromGrouped 팩토리 생성자를 완벽하게 재사용
        final widgetData = MealWidgetData.fromGrouped(
          date: DateFormat('yyyy-MM-dd').format(today),
          cafeteriaName: cafeteriaName,
          grouped: groupedMeals.map((k, v) => MapEntry(k, v)),
          hours: hours,
        );
        allCafeteriasData.add(widgetData);
      }

      // [핵심]
      // 데이터가 없으면 allCafeteriasData는 빈 리스트 []가 됩니다.
      // 이 빈 리스트를 그대로 저장하면, 위젯은 데이터를 찾지 못합니다.

      // 5. 모든 식당 데이터가 담긴 리스트를 새로운 컨테이너 모델로 감싸기
      final widgetDataContainer = AllCafeteriasWidgetData(
        cafeterias: allCafeteriasData,
      );

      if (kDebugMode) {
        debugPrint('✅ ${allCafeteriasData.length}개 식당 위젯 데이터 업데이트 성공!');
      }

      // 6. 새로운 서비스 함수를 호출하여 통합된 데이터를 저장
      await WidgetService.saveAllCafeteriasWidgetData(widgetDataContainer);
    } catch (e) {
      // 위젯 업데이트 실패는 조용히 무시
      if (kDebugMode) {
        debugPrint('위젯 업데이트 실패: $e');
      }
    }
  }

  /// StaleDataException 발생 시 SnackBar를 띄우는 헬퍼 함수
  void _showStaleDataSnackbar(StaleDataException e) {
    // SnackBar는 build가 완료된 후에 띄워야 하므로 addPostFrameCallback 사용
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // 위젯이 화면에 아직 있는지 확인
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.message,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
  }

  void _loadMeals() {
    setState(() {
      _mealFuture = _fetchData();
    });
  }

  /// Pull-to-Refresh(당겨서 새로고침)을 위한 새로고침 함수
  Future<void> _refreshMeals() async {
    setState(() {
      // catchError 내부를 async로 만들어 await를 사용할 수 있게 합니다.
      _mealFuture = _repository.forceRefreshMeals(_selectedDate).catchError((
        e,
      ) async {
        // 1. API 호출이 실패하면 (SocketException 등)
        if (e is SocketException) {
          // 2. 로컬 DB에 저장된 데이터라도 있는지 확인합니다.
          final localData = await _repository.fetchFromDb(_selectedDate);
          if (localData.isNotEmpty) {
            // 3a. 로컬 데이터가 있으면, SnackBar를 띄우고 그 데이터를 반환합니다.
            _showStaleDataSnackbar(
              StaleDataException(
                localData,
                message: "새로고침에 실패했습니다. 오프라인 정보를 표시합니다.",
              ),
            );
            return localData;
          }
        }
        // 3b. 로컬 데이터조차 없거나 다른 종류의 에러이면, 에러 화면을 보여줍니다.
        throw NetworkException();
      });
    });
  }

  /// 날짜 선택 함수
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      _selectedDate = picked;
      _loadMeals(); // 새 날짜로 데이터 로드
    }
  }

  /// 선택된 날짜의 운영시간(Hours)을 사용해 동적 경계를 계산한 뒤 섹션 순서를 반환합니다.
  ///
  /// 기준:
  /// - now < 아침 종료최대 → [아침, 점심, 저녁]
  /// - 아침 종료최대 ≤ now < 점심 종료최대 → [점심, 저녁, 아침]
  /// - 그 외 → [저녁, 아침, 점심]
  List<String> _orderedMealTypesByDynamicHours(
    Map<String, List<MealByCafeteria>> groupedMeals,
  ) {
    final now = DateTime.now();

    /// 가장 늦은 종료시간을 저장할 변수 선언
    DateTime? breakfastMaxEnd, lunchMaxEnd, dinnerMaxEnd;

    final allCafeterias = groupedMeals.values.expand((list) => list);

    // 모든 식당의 운영시간을 순회하며 가장 늦은 종료시간 찾기
    for (final cafeteria in allCafeterias) {
      final bEnd = _latestEndFromHoursString(cafeteria.hours.breakfast, now);
      if (bEnd != null) {
        breakfastMaxEnd =
            (breakfastMaxEnd == null || bEnd.isAfter(breakfastMaxEnd))
            ? bEnd
            : breakfastMaxEnd;
      }
      final lEnd = _latestEndFromHoursString(cafeteria.hours.lunch, now);
      if (lEnd != null) {
        lunchMaxEnd = (lunchMaxEnd == null || lEnd.isAfter(lunchMaxEnd))
            ? lEnd
            : lunchMaxEnd;
      }
      final dEnd = _latestEndFromHoursString(cafeteria.hours.dinner, now);
      if (dEnd != null) {
        dinnerMaxEnd = (dinnerMaxEnd == null || dEnd.isAfter(dinnerMaxEnd))
            ? dEnd
            : dinnerMaxEnd;
      }
    }

    List<String> desiredOrder;
    if (breakfastMaxEnd != null && now.isBefore(breakfastMaxEnd)) {
      desiredOrder = ['아침', '점심', '저녁'];
    } else if (lunchMaxEnd != null && now.isBefore(lunchMaxEnd)) {
      desiredOrder = ['점심', '저녁', '아침'];
    } else if (dinnerMaxEnd != null && now.isBefore(dinnerMaxEnd)) {
      desiredOrder = ['저녁', '아침', '점심'];
    } else {
      // 모든 저녁 식당의 운영이 종료된 이후에는 다음 날 아침을 우선으로 보여줍니다.
      desiredOrder = ['아침', '점심', '저녁'];
    }

    final existingTypes = groupedMeals.keys
        .where((k) => groupedMeals[k]!.isNotEmpty)
        .toList();

    final ordered = <String>[];
    // desiredOrder에 있는 순서대로 먼저 정렬 한다.
    for (final t in desiredOrder) {
      if (existingTypes.contains(t)) ordered.add(t);
    }
    // desiredOrder에 포함되지 않았지만
    // existingTypes(실제 존재하는 시간대 ex. 간식)에는 있었던
    // 나머지 시간대들을 이어서 붙인다.
    for (final t in existingTypes) {
      if (!ordered.contains(t)) ordered.add(t);
    }
    return ordered;
  }

  /// Hours 문자열을 파싱하여 가장 늦은 종료 시각을 구합니다.
  DateTime? _latestEndFromHoursString(String s, DateTime now) {
    if (s.trim().isEmpty) return null;
    final ranges = parseTimeRanges(s: s, now: now);
    if (ranges.isEmpty) return null;
    return ranges.map((r) => r.$2).reduce((a, b) => a.isAfter(b) ? a : b);
  }

  /// 에러 상황에 맞는 위젯을 생성하는 함수
  Widget _buildErrorWidget(Object error) {
    String message;
    IconData icon;

    // 에러 확인
    if (error is NetworkException) {
      message = "인터넷 연결을 확인해주세요.";
      icon = Icons.wifi_off_rounded;
    } else {
      message = "알 수 없는 오류가 발생했습니다.";
      icon = Icons.error_outline_rounded;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 60, color: Colors.grey),
          const SizedBox(height: 16),
          Text(message),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => setState(() {
              _loadMeals();
            }), // 재시도 버튼
            child: const Text("다시 시도"),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final Color univColor = context.watch<UnivProvider>().univColor;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 아이콘
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: univColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.restaurant_menu,
                size: 48.w,
                color: univColor,
              ),
            ),
            SizedBox(height: 24.h),
            // 제목
            Text(
              '등록된 식단이 없어요',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8.h),
            // 설명
            Text(
              '아직 오늘의 메뉴가 등록되지 않았습니다.\n잠시 후 다시 확인해주세요.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.greyTextColor,
                height: 1.5,
              ),
            ),
            SizedBox(height: 24.h),
            // 새로고침 버튼
            TextButton(
              onPressed: () => setState(() {
                _refreshMeals();
              }),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: univColor,
                padding: EdgeInsets.symmetric(
                  horizontal: 24.w,
                  vertical: 12.h,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.r),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.refresh, size: 18.w),
                  SizedBox(width: 8.w),
                  Text(
                    '새로고침',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 식단 목록을 보여주는 위젯
  Widget _buildMealList(List<Meal> meals) {
    final groupedMeals = groupMeals(meals);
    final mealTypes = _orderedMealTypesByDynamicHours(groupedMeals);

    return RefreshIndicator(
      onRefresh: _refreshMeals, // 당겨서 새로고침 기능 연결
      child: ListView.builder(
        itemCount: mealTypes.length,
        padding: EdgeInsets.symmetric(
          horizontal: 21.w,
          vertical: 23.h,
        ),
        itemBuilder: (context, index) {
          final mealType = mealTypes[index];
          final mealsByCafeteria = groupedMeals[mealType];

          if (mealsByCafeteria == null || mealsByCafeteria.isEmpty) {
            return const SizedBox.shrink();
          }
          return Padding(
            padding: EdgeInsets.only(bottom: 25.h),
            child: TimeGroupedCard(
              title: mealType,
              mealData: mealsByCafeteria,
              selectedDate: _selectedDate,
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody() {
    return FutureBuilder<List<Meal>>(
      future: _mealFuture,
      builder: (context, snapshot) {
        // 로딩 중
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        // 에러 발생
        if (snapshot.hasError) {
          return _buildErrorWidget(snapshot.error!);
        }
        // 데이터 없을 시 비어있음 표시
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildEmptyState();
        }

        // 데이터 로딩 성공 -> MealList 위젯 생성
        return _buildMealList(snapshot.data!);
      },
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final String univName = context.watch<UnivProvider>().univName;

    return AppBar(
      toolbarHeight: 103.h,
      backgroundColor: Theme.of(context).colorScheme.primary,
      shadowColor: Colors.black,
      elevation: 4.0,
      surfaceTintColor: Colors.transparent,
      // 스크롤 할 때 색 바뀌는 효과 제거
      scrolledUnderElevation: 0,
      centerTitle: false,
      // Appbar의 기본 여백 제거
      titleSpacing: 0,
      actionsPadding: EdgeInsets.only(right: 26.w),
      title: Padding(
        padding: EdgeInsets.only(left: 26.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            // 앱의 왼쪽 위
            Text(
              univName,
              style: TextStyle(
                color: Colors.white,
                // 자간 5% (픽셀 계산)
                letterSpacing: 30.sp * 0.05,
                // 행간 170%
                height: 1.7,
                fontWeight: FontWeight.w700,
                fontSize: 30.sp,
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.white.withValues(alpha: 0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(59.r),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 7.w,
                  vertical: 2.h,
                ),
                minimumSize: Size.zero, // 최소 사이즈 제거
                tapTargetSize: MaterialTapTargetSize.shrinkWrap, // 탭 영역을 최소화
              ),
              onPressed: () => _selectDate(context), // 탭하면 _selectDate 함수 호출
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    DateFormat(
                      'yyyy년 MM월 dd일 (E)',
                      'ko_KR',
                    ).format(_selectedDate), // 날짜 포맷
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 13.h,
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.menu,
            size: 33.w,
            color: Colors.white,
          ), // 설정 아이콘
          // iconSize: 33.w,
          tooltip: '설정', // 풍선 도움말
          onPressed: () {
            Navigator.of(context)
                .push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const SettingsScreen(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                          const begin = Offset(1.0, 0.0); // 오른쪽에서 시작
                          const end = Offset.zero; // 원래 위치로 이동
                          const curve = Curves.ease; // 부드러운 전환 효과

                          var tween = Tween(
                            begin: begin,
                            end: end,
                          ).chain(CurveTween(curve: curve));
                          var offsetAnimation = animation.drive(tween);

                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                  ),
                )
                .then((_) {
                  // 설정 화면에서 돌아왔을 때 배너 상태 다시 체크
                  _checkPermissionAndShowBanner();
                });
          },
          padding: EdgeInsets.zero, // 내부 패딩 제거
          constraints: const BoxConstraints(), // 최소 크기 제한(48px) 제거
          style: IconButton.styleFrom(
            tapTargetSize:
                MaterialTapTargetSize.shrinkWrap, // 3. 터치 영역을 내용물에 딱 맞춤
          ),
        ),
      ],
    );
  }

  Widget _buildPermissionBanner() {
    final Color univColor = context.watch<UnivProvider>().univColor;

    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        margin: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 12.h,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // 아이콘
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.notifications_active,
                color: Colors.orange,
                size: 24.w,
              ),
            ),
            SizedBox(width: 12.w),
            // 텍스트
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '위젯 권한 필요',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    '실시간 업데이트를 위해 권한을 허용해주세요',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: AppColors.greyTextColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            // 설정 버튼
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: univColor,
                padding: EdgeInsets.symmetric(
                  horizontal: 14.w,
                  vertical: 8.h,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: () async {
                await PermissionService.openAlarmPermissionSettings();
              },
              child: Text(
                '설정',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(width: 8.w),
            // 닫기 버튼
            GestureDetector(
              onTap: _dismissPermissionBanner,
              child: Icon(
                Icons.close,
                color: AppColors.greyTextColor,
                size: 20.w,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _showPermissionBanner
          ? _buildPermissionBanner()
          : null,
    );
  }
}
