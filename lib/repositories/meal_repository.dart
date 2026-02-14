import 'package:bobmoo/collections/meal_collection.dart';
import 'package:bobmoo/collections/menu_cache_status.dart';
import 'package:bobmoo/collections/restaurant_collection.dart';
import 'package:bobmoo/models/menu_model.dart';
import 'package:bobmoo/services/menu_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:isar_community/isar.dart';

// --- Custom Exceptions ---
/// 네트워크 오류를 위한 Exception
class NetworkException implements Exception {
  final String message;
  NetworkException({
    this.message = "인터넷 연결을 확인해주세요.",
  });
}

/// API 호출 실패 시 오래된(Stale) 데이터를 전달하기 위한 Exception
class StaleDataException implements Exception {
  final List<Meal> staleData;
  final String message;

  StaleDataException(
    this.staleData, {
    this.message = "오프라인 상태입니다. 마지막으로 저장된 정보를 표시합니다.",
  });
}

class MealRepository {
  final Isar isar;
  final MenuService menuService;

  MealRepository({
    required this.isar,
    required this.menuService,
  });

  /// 핵심 함수: 특정 날짜의 식단 데이터를 가져옴
  Future<List<Meal>> getMealsForDate(DateTime date) async {
    final targetDate = DateUtils.dateOnly(date);

    // 1. 해당 날짜의 캐시 상태 확인
    final cacheStatus = await isar.menuCacheStatuses
        .filter()
        .dateEqualTo(targetDate)
        .findFirst();

    final bool isCacheStale =
        cacheStatus == null ||
        DateTime.now().difference(cacheStatus.lastFetchedAt).inHours >= 24;

    if (isCacheStale) {
      // 2a. 캐시가 없거나 오래되었으면 API 호출
      if (kDebugMode) {
        print("ℹ️ [Cache Miss/Stale] API를 호출하여 데이터를 갱신합니다: $targetDate");
      }
      try {
        return await _fetchFromApiAndSave(targetDate);
      } catch (e) {
        if (kDebugMode) {
          print("🚨 [API Error] API 호출 실패: $e");
        }
        // API 호출 실패 시, DB에 오래된 데이터라도 있는지 확인 후 반환
        final staleData = await fetchFromDb(targetDate);
        if (staleData.isNotEmpty) {
          throw StaleDataException(staleData);
        } else {
          rethrow; // Stale 데이터조차 없으면 에러를 그대로 전달
        }
      }
    } else {
      // 2b. 캐시가 유효하면 DB에서 바로 반환
      if (kDebugMode) {
        print("✅ [Cache Hit] DB에서 신선한 데이터를 가져옵니다: $targetDate");
      }
      return await fetchFromDb(targetDate);
    }
  }

  /// UI에서 Pull-to-Refresh(당겨서 새로고침)를 위한 함수
  Future<List<Meal>> forceRefreshMeals(DateTime date) async {
    final targetDate = DateUtils.dateOnly(date);
    if (kDebugMode) {
      print("🔄 [Force Refresh] 강제로 데이터를 새로고침합니다: $targetDate");
    }
    return await _fetchFromApiAndSave(targetDate);
  }

  // --- Private Helper Methods ---

  /// DB에서 date날짜에 해당하는 데이터 반환
  Future<List<Meal>> fetchFromDb(DateTime date) {
    return isar.meals.filter().dateEqualTo(date).findAll();
  }

  Future<List<Meal>> _fetchFromApiAndSave(DateTime date) async {
    // 1. API에서 데이터 가져오기
    final menuResponse = await menuService.getMenu(date);

    // 2. DB에 저장
    await _saveMenuResponseToDb(menuResponse);

    // 3. DB에 저장된 데이터를 다시 조회하여 반환
    return fetchFromDb(date);
  }

  /// response 응답을 DB에 추가
  Future<void> _saveMenuResponseToDb(MenuResponse response) async {
    final responseDate = DateUtils.dateOnly(DateTime.parse(response.date));
    final bool isToday = responseDate.isAtSameMomentAs(
      DateUtils.dateOnly(DateTime.now()),
    );

    await isar.writeTxn(() async {
      // 1. 해당 날짜의 기존 Meal 데이터 삭제 (중복 방지)
      await isar.meals.filter().dateEqualTo(responseDate).deleteAll();

      final newMeals = <Meal>[];
      for (var cafeteria in response.cafeterias) {
        final restaurant = await _getOrCreateRestaurant(cafeteria, isToday);
        final meals = _createMealsFromCafeteria(
          cafeteria,
          responseDate,
          restaurant,
        );
        newMeals.addAll(meals);
      }

      // 2. 모든 Meal 객체 저장 및 링크 연결
      await _saveMealsAndLinks(newMeals);

      // 3. 캐시 상태 정보 업데이트
      await _updateCacheStatus(responseDate);
    });

    if (kDebugMode) {
      print("💾 DB 저장 완료: $responseDate");
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

    restaurant ??= Restaurant()..name = cafeteria.name;

    // 운영시간 업데이트: 항상 최신 운영시간으로 업데이트
    // (기존 Restaurant가 운영시간이 초기화되지 않은 상태일 수 있으므로)
    restaurant
      ..breakfastHours = cafeteria.hours.breakfast
      ..lunchHours = cafeteria.hours.lunch
      ..dinnerHours = cafeteria.hours.dinner;

    await isar.restaurants.put(restaurant);
    return restaurant;
  }

  /// Cafeteria에서 Meal 객체들 생성
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

  /// Meal() 생성
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
