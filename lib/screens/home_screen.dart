import 'dart:io';

import 'package:bobmoo/collections/meal_collection.dart';
import 'package:bobmoo/ui/theme/app_colors.dart';
import 'package:bobmoo/locator.dart';
import 'package:bobmoo/models/meal_by_cafeteria.dart';
import 'package:bobmoo/providers/univ_provider.dart';
import 'package:bobmoo/repositories/meal_repository.dart';
import 'package:bobmoo/screens/home_analytics_helper.dart';
import 'package:bobmoo/screens/home_widget_sync_helper.dart';
import 'package:bobmoo/services/analytics_service.dart';
import 'package:bobmoo/ui/theme/app_typography.dart';
import 'package:bobmoo/utils/meal_utils.dart';
import 'package:bobmoo/ui/components/cards/time_grouped_card.dart';
import 'package:bobmoo/utils/hours_parser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final MealRepository _repository = locator<MealRepository>();
  late final HomeWidgetSyncHelper _widgetSyncHelper;
  late Future<List<Meal>> _mealFuture;
  DateTime? _lastWidgetUpdateAt;
  static const Duration _widgetUpdateMinInterval = Duration(seconds: 30);
  bool _isWidgetUpdateInProgress = false;

  /// 선택한 날짜 저장할 상태 변수
  DateTime _selectedDate = DateTime.now();

  static const double _swipeTriggerDistance = 80;
  static const double _maxVisualDragOffset = 90;

  double _horizontalDragOffset = 0;
  bool _isHorizontalDragging = false;
  int _dateTransitionDirection = 1; // 1: 다음날(왼쪽 스와이프), -1: 이전날
  final HomeAnalyticsHelper _analyticsHelper = HomeAnalyticsHelper();

  /// 화면이 처음 나타날 때 데이터 불러오기
  @override
  void initState() {
    super.initState();
    _widgetSyncHelper = HomeWidgetSyncHelper(repository: _repository);
    // 앱 상태를 확인하기 위한 옵저버 할당
    WidgetsBinding.instance.addObserver(this);
    // 앱 시작 시 업데이트 확인
    _checkForUpdate();
    // initState에서는 setState를 호출하지 않고, Future를 직접 할당합니다.
    _mealFuture = _fetchData();
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
    }
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
    final requestContext = _analyticsHelper.consumeMealRequestContext();
    final mealDate = _analyticsHelper.toDateKey(_selectedDate);
    final schoolId = _currentSchoolId;

    try {
      final fetchResult = await _repository.getMealsForDateWithSource(
        _selectedDate,
      );
      final meals = fetchResult.meals;
      final dataSource = _toAnalyticsDataSource(fetchResult.dataSource);

      if (schoolId != null) {
        AnalyticsService.instance.logMealApiRequest(
          schoolId: schoolId,
          mealDate: mealDate,
          requestType: requestContext.requestType,
          changeSource: requestContext.changeSource,
          dataSource: dataSource,
          triggerSource: AnalyticsTriggerSource.foreground,
          result: MealApiResult.success,
        );
        AnalyticsService.instance.logViewMeal(
          schoolId: schoolId,
          mealDate: mealDate,
          dateOffset: _analyticsHelper.dateOffsetFromToday(_selectedDate),
          dataSource: dataSource,
          mealCount: meals.length,
        );
      }

      // 위젯은 "오늘" 데이터만 사용합니다. 오늘 데이터가 있으면 재조회 없이 재사용합니다.
      _updateWidgetOnly(
        todayMeals: _isSameDay(_selectedDate, DateTime.now()) ? meals : null,
      );

      return meals;
    } catch (e) {
      if (e is StaleDataException) {
        if (schoolId != null) {
          AnalyticsService.instance.logMealApiRequest(
            schoolId: schoolId,
            mealDate: mealDate,
            requestType: requestContext.requestType,
            changeSource: requestContext.changeSource,
            dataSource: _toAnalyticsDataSource(e.dataSource),
            triggerSource: AnalyticsTriggerSource.foreground,
            result: MealApiResult.staleData,
          );
          AnalyticsService.instance.logViewMeal(
            schoolId: schoolId,
            mealDate: mealDate,
            dateOffset: _analyticsHelper.dateOffsetFromToday(_selectedDate),
            dataSource: _toAnalyticsDataSource(e.dataSource),
            mealCount: e.staleData.length,
          );
        }
        // 신선도가 떨어진 데이터를 취급하는 경우
        _showStaleDataSnackbar(e);
        // 데이터를 반환하여 화면은 정상적으로 그리도록 함
        return e.staleData;
      } else if (e is SocketException) {
        if (schoolId != null) {
          AnalyticsService.instance.logMealApiRequest(
            schoolId: schoolId,
            mealDate: mealDate,
            requestType: requestContext.requestType,
            changeSource: requestContext.changeSource,
            triggerSource: AnalyticsTriggerSource.foreground,
            result: MealApiResult.networkError,
          );
        }
        // 네트워크 연결이 없는경우
        throw NetworkException();
      }
      if (schoolId != null) {
        AnalyticsService.instance.logMealApiRequest(
          schoolId: schoolId,
          mealDate: mealDate,
          requestType: requestContext.requestType,
          changeSource: requestContext.changeSource,
          triggerSource: AnalyticsTriggerSource.foreground,
          result: MealApiResult.unknownError,
        );
      }
      // 다른 모든 에러는 FutureBuilder로 전달
      rethrow;
    }
  }

  /// 위젯 데이터 업데이트 함수 (오늘날짜)
  Future<void> _updateWidgetOnly({List<Meal>? todayMeals}) async {
    final schoolId = _currentSchoolId;
    if (_isWidgetUpdateInProgress) {
      AnalyticsService.instance.logWidgetSync(
        schoolId: schoolId,
        triggerSource: AnalyticsTriggerSource.foreground,
        result: WidgetSyncResult.skippedInProgress,
      );
      if (kDebugMode) {
        debugPrint('위젯 업데이트 스킵: 이전 작업 진행 중');
      }
      return;
    }

    final nowForDebounce = DateTime.now();
    if (_lastWidgetUpdateAt != null &&
        nowForDebounce.difference(_lastWidgetUpdateAt!) <
            _widgetUpdateMinInterval) {
      AnalyticsService.instance.logWidgetSync(
        schoolId: schoolId,
        triggerSource: AnalyticsTriggerSource.foreground,
        result: WidgetSyncResult.skippedDebounce,
      );
      if (kDebugMode) {
        debugPrint('위젯 업데이트 스킵: 너무 짧은 간격');
      }
      return;
    }
    _lastWidgetUpdateAt = nowForDebounce;
    _isWidgetUpdateInProgress = true;

    try {
      final cafeteriaCount = await _widgetSyncHelper.syncWidgetData(
        todayMeals: todayMeals,
      );
      if (kDebugMode) {
        debugPrint('✅ $cafeteriaCount개 식당 위젯 데이터 업데이트 성공!');
      }

      AnalyticsService.instance.logWidgetSync(
        schoolId: schoolId,
        cafeteriaCount: cafeteriaCount,
        triggerSource: AnalyticsTriggerSource.foreground,
        result: WidgetSyncResult.success,
      );
    } catch (e) {
      AnalyticsService.instance.logWidgetSync(
        schoolId: schoolId,
        triggerSource: AnalyticsTriggerSource.foreground,
        result: WidgetSyncResult.failure,
      );
      // 위젯 업데이트 실패는 조용히 무시
      if (kDebugMode) {
        debugPrint('위젯 업데이트 실패: $e');
      }
    } finally {
      _isWidgetUpdateInProgress = false;
    }
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  int? get _currentSchoolId =>
      context.read<UnivProvider>().selectedUniversity?.schoolId;

  AnalyticsDataSource _toAnalyticsDataSource(MealDataSource dataSource) {
    switch (dataSource) {
      case MealDataSource.dbHit:
        return AnalyticsDataSource.dbHit;
      case MealDataSource.apiFetched:
        return AnalyticsDataSource.apiFetched;
      case MealDataSource.dbStaleFallback:
        return AnalyticsDataSource.dbStaleFallback;
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

  void _retryMeals() {
    _analyticsHelper.setMealRequestContext(
      requestType: MealApiRequestType.retry,
    );
    setState(() {
      _mealFuture = _fetchData();
    });
  }

  void _changeSelectedDateByDays(int days) {
    final previousDate = _selectedDate;
    final nextDate = _selectedDate.add(Duration(days: days));
    _analyticsHelper.setMealRequestContext(
      requestType: MealApiRequestType.dateChange,
      changeSource: AnalyticsChangeSource.swipe,
    );
    _analyticsHelper.logDateChangeIfNeeded(
      schoolId: _currentSchoolId,
      previousDate: previousDate,
      nextDate: nextDate,
      changeSource: AnalyticsChangeSource.swipe,
    );
    _analyticsHelper.resetStateExposureGuards();

    setState(() {
      _dateTransitionDirection = days >= 0 ? 1 : -1;
      _selectedDate = nextDate;
      _mealFuture = _fetchData();
    });
  }

  /// Pull-to-Refresh(당겨서 새로고침)을 위한 새로고침 함수
  Future<void> _refreshMeals() async {
    _analyticsHelper.setMealRequestContext(
      requestType: MealApiRequestType.userPullToRefresh,
    );
    final schoolId = _currentSchoolId;
    final mealDate = _analyticsHelper.toDateKey(_selectedDate);

    setState(() {
      // catchError 내부를 async로 만들어 await를 사용할 수 있게 합니다.
      _mealFuture = _repository
          .forceRefreshMeals(_selectedDate)
          .then((meals) {
            if (schoolId != null) {
              AnalyticsService.instance.logMealApiRequest(
                schoolId: schoolId,
                mealDate: mealDate,
                requestType: MealApiRequestType.userPullToRefresh,
                dataSource: AnalyticsDataSource.apiFetched,
                triggerSource: AnalyticsTriggerSource.foreground,
                result: MealApiResult.success,
              );
              AnalyticsService.instance.logViewMeal(
                schoolId: schoolId,
                mealDate: mealDate,
                dateOffset: _analyticsHelper.dateOffsetFromToday(_selectedDate),
                dataSource: AnalyticsDataSource.apiFetched,
                mealCount: meals.length,
              );
            }
            return meals;
          })
          .catchError((e) async {
            // 1. API 호출이 실패하면 (SocketException 등)
            if (e is SocketException) {
              // 2. 로컬 DB에 저장된 데이터라도 있는지 확인합니다.
              final localData = await _repository.fetchFromDb(_selectedDate);
              if (localData.isNotEmpty) {
                if (schoolId != null) {
                  AnalyticsService.instance.logMealApiRequest(
                    schoolId: schoolId,
                    mealDate: mealDate,
                    requestType: MealApiRequestType.userPullToRefresh,
                    dataSource: AnalyticsDataSource.dbStaleFallback,
                    triggerSource: AnalyticsTriggerSource.foreground,
                    result: MealApiResult.staleData,
                  );
                  AnalyticsService.instance.logViewMeal(
                    schoolId: schoolId,
                    mealDate: mealDate,
                    dateOffset: _analyticsHelper.dateOffsetFromToday(
                      _selectedDate,
                    ),
                    dataSource: AnalyticsDataSource.dbStaleFallback,
                    mealCount: localData.length,
                  );
                }
                // 3a. 로컬 데이터가 있으면, SnackBar를 띄우고 그 데이터를 반환합니다.
                _showStaleDataSnackbar(
                  StaleDataException(
                    localData,
                    message: "새로고침에 실패했습니다. 오프라인 정보를 표시합니다.",
                  ),
                );
                return localData;
              }

              if (schoolId != null) {
                AnalyticsService.instance.logMealApiRequest(
                  schoolId: schoolId,
                  mealDate: mealDate,
                  requestType: MealApiRequestType.userPullToRefresh,
                  triggerSource: AnalyticsTriggerSource.foreground,
                  result: MealApiResult.networkError,
                );
              }
              // 3b. 로컬 데이터조차 없으면 에러 화면을 보여줍니다.
              throw NetworkException();
            }

            if (schoolId != null) {
              AnalyticsService.instance.logMealApiRequest(
                schoolId: schoolId,
                mealDate: mealDate,
                requestType: MealApiRequestType.userPullToRefresh,
                triggerSource: AnalyticsTriggerSource.foreground,
                result: MealApiResult.unknownError,
              );
            }
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
      final previousDate = _selectedDate;
      _analyticsHelper.setMealRequestContext(
        requestType: MealApiRequestType.dateChange,
        changeSource: AnalyticsChangeSource.picker,
      );
      _analyticsHelper.logDateChangeIfNeeded(
        schoolId: _currentSchoolId,
        previousDate: previousDate,
        nextDate: picked,
        changeSource: AnalyticsChangeSource.picker,
      );
      _analyticsHelper.resetStateExposureGuards();

      setState(() {
        _dateTransitionDirection = picked.isAfter(_selectedDate) ? 1 : -1;
        _selectedDate = picked;
        _mealFuture = _fetchData();
      });
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
            onPressed: () {
              final schoolId = _currentSchoolId;
              if (schoolId != null) {
                AnalyticsService.instance.logMealRetryTap(
                  schoolId: schoolId,
                  mealDate: _analyticsHelper.toDateKey(_selectedDate),
                  previousErrorType: _analyticsHelper.errorTypeOf(error),
                );
              }
              _retryMeals();
            }, // 재시도 버튼
            child: const Text("다시 시도"),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppColors.colorWhite,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 아이콘
          SvgPicture.asset(
            'assets/icons/icon_bob.svg',
            width: 60.w,
          ),
          SizedBox(height: 24.h),
          // 제목
          Text(
            '등록된 식단이 없어요',
            style: AppTypography.head.sb18,
          ),
          SizedBox(height: 21.h),
          // 설명
          Text(
            '식단 정보가 등록되지 않았어요.',
            textAlign: TextAlign.center,
            style: AppTypography.search.sb15.copyWith(
              color: AppColors.colorGray3,
            ),
          ),
          SizedBox(
            height: 4.h,
          ),
          Text(
            '잠시 후 다시 확인해주세요.',
            textAlign: TextAlign.center,
            style: AppTypography.search.sb15.copyWith(
              color: AppColors.colorGray3,
            ),
          ),
          SizedBox(height: 118.h),
          // 아래로 당겨 새로고침
          Column(
            children: [
              Icon(
                Icons.arrow_downward,
                color: AppColors.colorGray3,
                size: 32.w,
              ),
              SizedBox(
                height: 7.h,
              ),
              Text(
                "아래로 당겨 새로고침",
                style: AppTypography.button.sb11.copyWith(
                  color: AppColors.colorGray3,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 식단 목록을 보여주는 위젯
  Widget _buildMealList(List<Meal> meals) {
    final groupedMeals = groupMeals(meals);
    final mealTypes = _orderedMealTypesByDynamicHours(groupedMeals);

    return SliverPadding(
      padding: EdgeInsets.symmetric(
        horizontal: 21.w,
        vertical: 23.h,
      ),
      sliver: SliverList.builder(
        itemCount: mealTypes.length,

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
        final currentDateKey = DateFormat('yyyy-MM-dd').format(_selectedDate);
        final beginX = _dateTransitionDirection >= 0 ? 0.22 : -0.22;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onHorizontalDragStart: (_) {
            setState(() {
              _isHorizontalDragging = true;
            });
          },
          onHorizontalDragUpdate: (details) {
            setState(() {
              _horizontalDragOffset = (_horizontalDragOffset + details.delta.dx)
                  .clamp(-_maxVisualDragOffset, _maxVisualDragOffset);
            });
          },
          onHorizontalDragCancel: () {
            setState(() {
              _isHorizontalDragging = false;
              _horizontalDragOffset = 0;
            });
          },
          onHorizontalDragEnd: (_) {
            final dragOffset = _horizontalDragOffset;
            int? dayDelta;

            if (dragOffset.abs() >= _swipeTriggerDistance) {
              dayDelta = dragOffset < 0 ? 1 : -1; // 왼쪽 스와이프=다음 날
            }

            setState(() {
              _isHorizontalDragging = false;
              _horizontalDragOffset = 0;
            });

            if (dayDelta != null) {
              _changeSelectedDateByDays(dayDelta);
            }
          },
          child: AnimatedContainer(
            duration: _isHorizontalDragging
                ? Duration.zero
                : const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            transform: Matrix4.translationValues(_horizontalDragOffset, 0, 0),
            child: ClipRect(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 260),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeOutCubic,
                transitionBuilder: (child, animation) {
                  final isIncoming = child.key == ValueKey(currentDateKey);
                  final slide = isIncoming
                      ? Tween<Offset>(
                          begin: Offset(beginX, 0),
                          end: Offset.zero,
                        ).animate(animation)
                      : Tween<Offset>(
                          begin: Offset.zero,
                          end: Offset(-beginX, 0),
                        ).animate(ReverseAnimation(animation));

                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(position: slide, child: child),
                  );
                },
                child: CustomScrollView(
                  key: ValueKey(currentDateKey),
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  slivers: [
                    CupertinoSliverRefreshControl(
                      onRefresh: _refreshMeals,
                      builder:
                          (
                            context,
                            refreshState,
                            pulledExtent,
                            refreshTriggerPullDistance,
                            refreshIndicatorExtent,
                          ) {
                            return Container(
                              margin: const EdgeInsets.all(20),
                              padding: EdgeInsets.all(33.h),
                              child: CupertinoActivityIndicator(
                                radius: 10.r,
                              ),
                            );
                          },
                    ),
                    // 케이스별로 다른 Sliver 추가
                    // 로딩 중
                    if (snapshot.connectionState == ConnectionState.waiting)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: const Center(child: CircularProgressIndicator()),
                      )
                    // 에러 발생
                    else if (snapshot.hasError)
                      () {
                        _analyticsHelper.logErrorStateIfNeeded(
                          schoolId: _currentSchoolId,
                          selectedDate: _selectedDate,
                          error: snapshot.error!,
                        );
                        return SliverFillRemaining(
                          hasScrollBody: false,
                          child: _buildErrorWidget(snapshot.error!),
                        );
                      }()
                    // 데이터 없을 시 비어있음 표시
                    else if (!snapshot.hasData || snapshot.data!.isEmpty)
                      () {
                        _analyticsHelper.logEmptyStateIfNeeded(
                          schoolId: _currentSchoolId,
                          selectedDate: _selectedDate,
                        );
                        return SliverFillRemaining(
                          hasScrollBody: false,
                          child: _buildEmptyState(),
                        );
                      }()
                    // 데이터 로딩 성공 -> MealList 위젯 생성
                    else
                      _buildMealList(snapshot.data!), // Sliver 직접 추가
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final UnivProvider univProvider = context.watch<UnivProvider>();

    return AppBar(
      toolbarHeight: 140.h,
      backgroundColor: univProvider.univColor,
      shadowColor: Colors.black,
      elevation: 4.0,
      surfaceTintColor: Colors.transparent,
      // 스크롤 할 때 색 바뀌는 효과 제거
      scrolledUnderElevation: 0,
      centerTitle: false,
      // Appbar의 기본 여백 제거
      titleSpacing: 0,
      actionsPadding: EdgeInsets.only(right: 24.w),
      title: Padding(
        padding: EdgeInsets.only(left: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 45.h),
            // 앱의 왼쪽 위
            Text(
              univProvider.univName,
              style: AppTypography.head.b30.copyWith(
                color: AppColors.colorWhite,
              ),
            ),
            SizedBox(height: 9.h),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: AppColors.colorWhite10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(59.r),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 3.h,
                ),
                minimumSize: Size.zero, // 최소 사이즈 제거
                tapTargetSize: MaterialTapTargetSize.shrinkWrap, // 탭 영역을 최소화
              ),
              onPressed: () => _selectDate(context), // 탭하면 _selectDate 함수 호출
              child: Text(
                DateFormat(
                  'yyyy년 MM월 dd일 (E)',
                  'ko_KR',
                ).format(_selectedDate), // 날짜 포맷
                style: AppTypography.caption.sb11.copyWith(
                  color: AppColors.colorWhite,
                ),
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
            Navigator.of(context).pushNamed('/settings');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }
}
