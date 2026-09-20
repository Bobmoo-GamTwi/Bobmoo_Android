import 'dart:convert';

import 'package:bobmoo/collections/meal_collection.dart';
import 'package:bobmoo/constants/app_constants.dart';
import 'package:bobmoo/constants/storage_keys.dart';
import 'package:bobmoo/locator.dart';
import 'package:bobmoo/models/all_cafeterias_widget_data.dart';
import 'package:bobmoo/models/meal_widget_data.dart';
import 'package:bobmoo/models/menu_model.dart';
import 'package:bobmoo/models/university.dart';
import 'package:bobmoo/repositories/meal_repository.dart';
import 'package:bobmoo/utils/app_logger.dart';
import 'package:bobmoo/utils/meal_utils.dart';
import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WidgetUpdateService {
  /// 위젯 실행 중복 방지
  static bool _isWidgetUpdateInProgress = false;

  // 위젯 갱신 로직
  static Future<void> updateWidget() async {
    if (_isWidgetUpdateInProgress) {
      AppLogger.d("위젯 업데이트 스킵: 기존 업데이트 처리 중", tag: "WIDGET");
      return;
    }

    try {
      _isWidgetUpdateInProgress = true;

      final repository = locator<MealRepository>();
      final prefs = locator<SharedPreferences>();

      University? targetUniv;
      // 1. SharedPreferences에서 선택한 학교 정보 가져오기
      final jsonString = prefs.getString(LocalStorageKeys.selectedUniv);
      if (jsonString != null) {
        targetUniv = University.fromJson(jsonDecode(jsonString));
      }

      // 선택된 학교가 없으면 종료
      if (targetUniv == null) {
        AppLogger.w("선택한 학교가 없어 위젯 업데이트를 스킵합니다.", tag: "WIDGET");
        return;
      }

      // 1. 날짜에 해당하는 식단 가져오기
      final mealsForWidget = await repository.getMealsForDate(DateTime.now());

      // 오늘 식단이 비어있으면 종료
      if (mealsForWidget.isEmpty) {
        AppLogger.w("오늘 식단이 비어있어 위젯 업데이트를 스킵합니다.", tag: "WIDGET");
        return;
      }

      // 2. 식단을 위젯 데이터에 저장할 수 있게 가공하기
      final widgetDatacontainer = _buildWidgetData(mealsForWidget);

      await _saveAllCafeteriasWidgetData(widgetDatacontainer);

      AppLogger.i(
        "${widgetDatacontainer.cafeterias.length}개 식당 위젯 데이터 업데이트 성공!",
        tag: "WIDGET",
      );
    } catch (e, stackTrace) {
      AppLogger.e(
        "위젯 업데이트 에러",
        error: e,
        stackTrace: stackTrace,
        tag: "WIDGET",
      );
    } finally {
      _isWidgetUpdateInProgress = false;
    }
  }

  static AllCafeteriasWidgetData _buildWidgetData(List<Meal> meals) {
    // 데이터를 시간대별로 그룹화
    final groupedMeals = groupMeals(meals);

    // 오늘 운영하는 모든 식당의 고유한 이름과 정보(Hours)를 추출
    final uniqueCafeterias = <String, Hours>{};

    // groupedMeals를 순회하며 key: 식당 value: 운영시간 을 정리함.
    for (final mealByCafeteria in groupedMeals.values.expand((list) => list)) {
      uniqueCafeterias[mealByCafeteria.cafeteriaName] = mealByCafeteria.hours;
    }

    // 각 식당별로 MealWidgetData 객체를 생성하여 리스트에 담기
    final allCafeteriasData = <MealWidgetData>[];
    for (final entry in uniqueCafeterias.entries) {
      allCafeteriasData.add(
        MealWidgetData.fromGrouped(
          date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
          cafeteriaName: entry.key,
          grouped: Map.of(groupedMeals),
          hours: entry.value,
        ),
      );
    }

    return AllCafeteriasWidgetData(cafeterias: allCafeteriasData);
  }

  static Future<void> _saveAllCafeteriasWidgetData(
    AllCafeteriasWidgetData data,
  ) async {
    final jsonString = jsonEncode(data.toJson());
    await HomeWidget.saveWidgetData<String>(
      WidgetStorageKeys.widgetData,
      jsonString,
    );
    await _refreshAllWidgets();
  }

  static Future<void> _refreshAllWidgets() async {
    await HomeWidget.updateWidget(
      qualifiedAndroidName: mealWidgetReceiverClassName,
    );
    await HomeWidget.updateWidget(
      qualifiedAndroidName: allCafeteriasWidgetReceiverClassName,
    );
  }
}
