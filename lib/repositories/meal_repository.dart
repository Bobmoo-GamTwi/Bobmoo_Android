import 'dart:convert';

import 'package:bobmoo/collections/meal_collection.dart';
import 'package:bobmoo/collections/menu_cache_status.dart';
import 'package:bobmoo/collections/restaurant_collection.dart';
import 'package:bobmoo/constants/storage_keys.dart';
import 'package:bobmoo/models/menu_model.dart';
import 'package:bobmoo/services/menu_service.dart';
import 'package:bobmoo/utils/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:isar_community/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// API 호출 실패 시 로컬 DB에 남아있는 과거 식단([staleData])을 UI로 전달하기 위한 예외 클래스입니다.
class StaleDataException implements Exception {
  /// 오프라인 상태에서 임시로 보여줄 과거 식단 데이터
  final List<Meal> staleData;

  /// 사용자에게 보여줄 안내 메시지
  final String message;

  /// 예외 발생의 원인이 된 원본 에러 (네트워크 오류, 서버 에러 등)
  final dynamic originalError;

  const StaleDataException(
    this.staleData, {
    this.message = "오프라인 상태입니다. 마지막으로 저장된 정보를 표시합니다.",
    this.originalError,
  });

  @override
  String toString() =>
      'StaleDataException: $message (개수: ${staleData.length}건, 원인: $originalError)';
}

enum MealDataSource {
  dbHit,
  apiFetched,
  dbStaleFallback,
}

class MealFetchResult {
  final List<Meal> meals;
  final MealDataSource dataSource;

  MealFetchResult({
    required this.meals,
    required this.dataSource,
  });
}

class MealRepository {
  final Isar isar;
  final MenuService menuService;
  final SharedPreferences prefs;
  static const String _fallbackSchoolNameK = '인하대학교';

  MealRepository({
    required this.isar,
    required this.menuService,
    required this.prefs,
  });

  /// 핵심 함수: 특정 날짜의 식단 데이터를 가져옴
  Future<List<Meal>> getMealsForDate(DateTime date) async {
    return await _fetchMealsWithPolicy(date);
  }

  /// UI에서 Pull-to-Refresh(당겨서 새로고침)를 위한 함수
  Future<List<Meal>> forceRefreshMeals(DateTime date) async {
    return _fetchMealsWithPolicy(date, forceRefresh: true);
  }

  /// 캐시 정책(Cache-First / Stale-While-Revalidate)에 따라 로컬 DB 또는 원격 API에서 식단 데이터([Meal])를 조회합니다.
  ///
  /// **동작 흐름 및 정책:**
  /// 1. **캐시 유효성 검사**: [targetDate]의 캐시 기록([MenuCacheStatus])을 확인하여 24시간 경과 여부 또는 [forceRefresh] 플래그를 체크합니다.
  /// 2. **Cache Miss / Stale**:
  ///    - API를 호출하여 최신 식단을 가져온 뒤 DB에 저장하고 반환합니다.
  ///    - **Fallback 전략**: API 호출 실패 시 로컬 DB에 과거 데이터가 남아있다면 [StaleDataException]에 담아 throw하여 UI에서 경고 메시지와 함께 기존 데이터를 보여줄 수 있게 합니다.
  ///    - 과거 데이터조차 없으면 원본 에러를 그대로 상위로 전달([rethrow])합니다.
  /// 3. **Cache Hit**:
  ///    - 24시간 이내의 유효한 캐시가 존재하면 API 호출 없이 로컬 DB([fetchFromDb])에서 즉시 반환합니다.
  ///
  /// Throws:
  /// - [StaleDataException]: API 실패 시 로컬 DB의 오래된 식단 데이터를 담아 예외 발생
  /// - [Exception]: API 실패 시 로컬 DB에도 데이터가 전혀 없는 경우 원본 예외 전달
  Future<List<Meal>> _fetchMealsWithPolicy(
    DateTime date, {
    bool forceRefresh = false,
  }) async {
    final targetDate = DateUtils.dateOnly(date);
    final schoolNameK = _resolveSchoolNameK();

    // 1. 해당 날짜의 캐시 상태 확인
    final cacheStatus = await isar.menuCacheStatuses
        .filter()
        .dateEqualTo(targetDate)
        .findFirst();

    final bool isCacheStale =
        cacheStatus == null ||
        DateTime.now().difference(cacheStatus.lastFetchedAt).inHours >= 24;
    final shouldFetchFromApi = forceRefresh || isCacheStale;

    if (shouldFetchFromApi) {
      // 2a. 캐시가 없거나 오래되었으면 API 호출
      AppLogger.d(
        "API 데이터 갱신 요청 (Cache Miss/Stale/Force) - 날짜: $targetDate, 학교: $schoolNameK",
        tag: "CACHE",
      );
      try {
        final meals = await _fetchFromApiAndSave(
          targetDate,
          schoolNameK: schoolNameK,
        );
        return meals;
      } catch (e, stackTrace) {
        AppLogger.e("API 호출 실패", error: e, stackTrace: stackTrace, tag: "API");

        // API 호출 실패 시, DB에 오래된 데이터라도 있는지 확인 후 반환
        final staleData = await fetchFromDb(targetDate);
        if (staleData.isNotEmpty) {
          throw StaleDataException(staleData, originalError: e);
        } else {
          rethrow; // Stale 데이터조차 없으면 에러를 그대로 전달
        }
      }
    } else {
      // 2b. 캐시가 유효하면 DB에서 바로 반환
      AppLogger.i(
        "DB에서 유효한 캐시 데이터를 불러왔습니다 (Cache Hit) - 날짜: $targetDate",
        tag: "CACHE",
      );

      return await fetchFromDb(targetDate);
    }
  }

  /// 특정 날짜([date])의 식단([Meal]) 목록을 Isar DB에서 조회하여 반환합니다.
  ///
  /// Isar DB의 지연 로딩(Lazy Loading) 특성으로 인해 [meal.restaurant.value]가
  /// 비어있는 상태를 방지하고자, [Future.wait]를 통해 연결된 식당 정보([Restaurant])를
  /// 병렬로 미리 로드(Pre-fetch)한 뒤 완성된 엔티티 리스트를 반환합니다.
  ///
  /// 상위 도메인 로직([groupMeals] 등)에서 [Restaurant] 객체에 접근할 때 발생할 수 있는
  /// 널(Null) 참조 에러를 방지하는 역할을 합니다.
  Future<List<Meal>> fetchFromDb(DateTime date) async {
    final meals = await isar.meals.filter().dateEqualTo(date).findAll();

    // groupMeals()에서 restaurant.value를 바로 참조하므로 링크를 미리 로드합니다.
    await Future.wait(meals.map((meal) => meal.restaurant.load()));

    return meals;
  }

  /// 원격 API에서 특정 날짜([date]) 및 학교([schoolNameK])의 식단 정보를 조회하여 DB에 저장한 뒤 반환합니다.
  ///
  /// API 응답 데이터를 메모리 상에서 직접 반환하지 않고, DB 저장 후 [fetchFromDb]를 통해
  /// 다시 조회하는 **단일 진실 출처(Single Source of Truth)** 패턴을 따릅니다.
  ///
  /// 이를 통해 Isar 고유 ID 및 식당 관계([IsarLink])가 완전히 로드된
  /// 안정적인 [Meal] 엔티티 리스트를 반환합니다.
  Future<List<Meal>> _fetchFromApiAndSave(
    DateTime date, {
    required String schoolNameK,
  }) async {
    // 1. API에서 데이터 가져오기
    final menuResponse = await menuService.getMenu(
      date,
      schoolNameK: schoolNameK,
    );

    // 2. DB에 저장
    await _saveMenuResponseToDb(menuResponse);

    // 3. DB에 저장된 데이터를 다시 조회하여 반환
    return fetchFromDb(date);
  }

  /// [LocalStorageKeys.selectedUniv]에서 학교 정보를 읽어와 한글 학교명([schoolNameK])을 반환합니다.
  ///
  /// 파싱 오류, 데이터 부재 등의 예외 상황에서도 API 호출이 차단되지 않도록
  /// 기본값([_fallbackSchoolNameK]) 반환을 보장합니다.
  String _resolveSchoolNameK() {
    try {
      final jsonString = prefs.getString(LocalStorageKeys.selectedUniv);
      if (jsonString == null || jsonString.isEmpty) {
        return _fallbackSchoolNameK;
      }

      final decoded = jsonDecode(jsonString);
      if (decoded is! Map<String, dynamic>) {
        return _fallbackSchoolNameK;
      }

      final schoolNameK = decoded['schoolNameK'];
      if (schoolNameK is String && schoolNameK.isNotEmpty) {
        return schoolNameK;
      }
    } catch (_) {
      // 파싱 실패 시에는 기본 학교로 폴백하여 API 호출 실패를 방지합니다.
    }

    return _fallbackSchoolNameK;
  }

  /// 학교 변경 시 호출: 기존 식단/캐시를 일괄 무효화합니다.
  Future<void> onSchoolChanged() async {
    await _clearAllMealCaches();
  }

  /// Isar DB에 저장된 모든 식단([Meal]), 캐시 상태([MenuCacheStatus]), 식당([Restaurant]) 데이터를 일괄 삭제하여 초기화합니다.
  ///
  /// 학교 변경 시 이전 학교 데이터 잔재(식당 이름 충돌 등)를 깨끗이 청소하거나,
  /// 사용자가 전체 캐시 리셋을 요청할 때 호출합니다.
  /// 데이터 정합성을 위해 단일 트랜잭션 내에서 일괄 처리됩니다.
  Future<void> _clearAllMealCaches() async {
    await isar.writeTxn(() async {
      await isar.meals.clear();
      await isar.menuCacheStatuses.clear();
      await isar.restaurants.clear();
    });
  }

  /// response 응답을 DB에 추가
  Future<void> _saveMenuResponseToDb(MenuResponse response) async {
    final responseDate = DateUtils.dateOnly(DateTime.parse(response.date));
    final bool isToday = responseDate.isAtSameMomentAs(
      DateUtils.dateOnly(DateTime.now()),
    );
    bool isEmptyResponse = false;

    await isar.writeTxn(() async {
      final newMeals = <Meal>[];

      // API 응답에 포함된 식당(Cafeteria DTO) 목록을 순회하며 DB 저장용 데이터를 생성합니다.
      for (var cafeteria in response.schools.cafeterias) {
        // 1. DB에서 식당을 조회/생성하고, 오늘 날짜인 경우 최신 운영시간으로 DB를 갱신합니다.
        final restaurant = await _getOrCreateRestaurant(cafeteria, isToday);

        // 2. 식당 정보와 날짜, API 데이터를 조합하여 Isar DB 저장용 Meal 엔티티 목록을 변환합니다.
        final meals = _createMealsFromCafeteria(
          cafeteria,
          responseDate,
          restaurant,
        );

        // 3. 추후 DB 일괄 저장(Bulk Insert)을 위해 변환된 Meal 객체들을 리스트에 누적합니다.
        newMeals.addAll(meals);
      }

      // Empty 응답은 성공 캐시로 저장하지 않습니다.
      // 기존 Meal 데이터는 유지하고, cacheStatus만 제거해 다음 진입 시 API를 다시 호출하게 합니다.
      if (newMeals.isEmpty) {
        isEmptyResponse = true;
        await isar.menuCacheStatuses
            .filter()
            .dateEqualTo(responseDate)
            .deleteAll();
        return;
      }

      // 1. 해당 날짜의 기존 Meal 데이터 삭제 (중복 방지)
      await isar.meals.filter().dateEqualTo(responseDate).deleteAll();

      // 2. 모든 Meal 객체 저장 및 링크 연결
      await _saveMealsAndLinks(newMeals);

      // 3. 캐시 상태 정보 업데이트
      await _updateCacheStatus(responseDate);
    });

    if (isEmptyResponse) {
      AppLogger.d("⚠️ [Empty Response] 캐시 갱신 없이 유지: $responseDate");
    } else {
      AppLogger.d("💾 DB 저장 완료: $responseDate");
    }
  }

  /// Restaurant 조회/생성/업데이트
  Future<Restaurant> _getOrCreateRestaurant(
    Cafeteria cafeteria,
    bool isToday,
  ) async {
    Restaurant? restaurant = await isar.restaurants
        .where()
        .nameEqualTo(cafeteria.name)
        .findFirst();

    // restaurant가 null이면 우항 실행: Restaurant 객체 생성 후 name 설정하여 대입
    // (null이 아니면 우항을 전혀 실행하지 않고 기존 값을 유지함)
    restaurant ??= Restaurant()..name = cafeteria.name;

    // 2. 운영시간 초기화 판단 조건:
    //   '운영시간 데이터가 비어있는 경우("")' OR '오늘 식단 데이터인 경우'
    final bool hasNoHours = restaurant.breakfastHours.isEmpty;

    if (isToday || hasNoHours) {
      restaurant
        ..breakfastHours = cafeteria.hours.breakfast
        ..lunchHours = cafeteria.hours.lunch
        ..dinnerHours = cafeteria.hours.dinner;

      await isar.restaurants.put(restaurant);
    }

    return restaurant;
  }

  /// 서버 API 응답 모델([Cafeteria]) 데이터를 파싱하여 Isar DB 저장용 [Meal] 엔티티 리스트로 변환합니다.
  ///
  /// 아침, 점심, 저녁별 식단 아이템([MealItem])을 순회하며 날짜, 식사 시간, 연결된 [Restaurant] 정보를 결합합니다.
  List<Meal> _createMealsFromCafeteria(
    Cafeteria cafeteria,
    DateTime date,
    Restaurant restaurant,
  ) {
    final meals = <Meal>[];

    for (var item in cafeteria.meals.breakfast) {
      meals.add(
        _createMeal(
          item,
          date,
          MealTime.breakfast,
          restaurant,
        ),
      );
    }

    for (var item in cafeteria.meals.lunch) {
      meals.add(
        _createMeal(
          item,
          date,
          MealTime.lunch,
          restaurant,
        ),
      );
    }

    for (var item in cafeteria.meals.dinner) {
      meals.add(
        _createMeal(
          item,
          date,
          MealTime.dinner,
          restaurant,
        ),
      );
    }

    return meals;
  }

  /// Meal 객체들 저장 및 링크 연결
  Future<void> _saveMealsAndLinks(List<Meal> meals) async {
    await isar.meals.putAll(meals);
    for (var meal in meals) {
      await meal.restaurant.save();
    }
  }

  /// 캐시 상태 정보 업데이트
  Future<void> _updateCacheStatus(DateTime date) async {
    final newCacheStatus = MenuCacheStatus()
      ..date = date
      ..lastFetchedAt = DateTime.now();
    await isar.menuCacheStatuses.put(newCacheStatus);
  }

  /// [MealItem] 데이터와 메타정보(날짜, 식사 시간, 식당)를 조합하여 Isar DB 저장용 [Meal] 엔티티를 생성합니다.
  ///
  /// [Restaurant] 단방향 링크([IsarLink])를 [restaurant.value]에 연결하여 반환합니다.
  Meal _createMeal(
    MealItem item,
    DateTime date,
    MealTime time,
    Restaurant restaurant,
  ) {
    return Meal()
      ..date = date
      ..mealTime = time
      ..course = item.course
      ..menu = item.mainMenu
      ..price = item.price
      ..restaurant.value = restaurant;
  }
}
