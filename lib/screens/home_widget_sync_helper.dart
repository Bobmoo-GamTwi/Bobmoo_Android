import 'package:bobmoo/collections/meal_collection.dart';
import 'package:bobmoo/models/all_cafeterias_widget_data.dart';
import 'package:bobmoo/models/menu_model.dart';
import 'package:bobmoo/models/meal_widget_data.dart';
import 'package:bobmoo/repositories/meal_repository.dart';
import 'package:bobmoo/services/widget_service.dart';
import 'package:bobmoo/utils/meal_utils.dart';
import 'package:intl/intl.dart';

class HomeWidgetSyncHelper {
  HomeWidgetSyncHelper({required MealRepository repository})
    : _repository = repository;

  final MealRepository _repository;

  Future<int> syncWidgetData({List<Meal>? todayMeals}) async {
    // 1. 오늘 날짜의 메뉴 데이터 가져오기 (인자로 들어오면 재사용)
    final mealsForWidget =
        todayMeals ?? await _repository.getMealsForDate(DateTime.now());

    // 2. 데이터를 시간대별로 그룹화
    final groupedMeals = groupMeals(mealsForWidget);

    // 3. 오늘 운영하는 모든 식당의 고유한 이름과 정보(Hours)를 추출
    final uniqueCafeterias = <String, Hours>{};

    // groupedMeals가 비어있으면 이 반복문은 실행되지 않음 -> 안전함
    for (final mealByCafeteria in groupedMeals.values.expand((list) => list)) {
      uniqueCafeterias[mealByCafeteria.cafeteriaName] = mealByCafeteria.hours;
    }

    // 4. 각 식당별로 MealWidgetData 객체를 생성하여 리스트에 담기
    final allCafeteriasData = <MealWidgetData>[];
    for (final entry in uniqueCafeterias.entries) {
      allCafeteriasData.add(
        MealWidgetData.fromGrouped(
          date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
          cafeteriaName: entry.key,
          grouped: groupedMeals.map((k, v) => MapEntry(k, v)),
          hours: entry.value,
        ),
      );
    }

    // 5. 모든 식당 데이터가 담긴 리스트를 새로운 컨테이너 모델로 감싸기
    final widgetDataContainer = AllCafeteriasWidgetData(
      cafeterias: allCafeteriasData,
    );

    await WidgetService.saveAllCafeteriasWidgetData(widgetDataContainer);
    return allCafeteriasData.length;
  }
}
