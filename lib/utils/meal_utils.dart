import 'package:bobmoo/collections/meal_collection.dart';
import 'package:bobmoo/collections/restaurant_collection.dart';
import 'package:bobmoo/models/meal_by_cafeteria.dart';
import 'package:bobmoo/models/menu_model.dart';

// 5. 데이터 구조 변환 함수: `List<Meal>` -> `Map<String, List<MealByCafeteria>>`
/// 기존 UI 위젯과 호환시키기 위한 데이터 변환 로직
/// 모든 A, B코스들을 아침, 점심, 저녁으로 분류해서 반환함.
/// 백그라운드에서 사용을 위해 meal_utils.dart로 코드 분리
Map<String, List<MealByCafeteria>> groupMeals(List<Meal> meals) {
  final Map<String, MealByCafeteria> tempMap = {};

  for (var meal in meals) {
    // isarLink를 통해 Restaurant 정보 로드
    final restaurant = meal.restaurant.value;
    if (restaurant == null) continue;

    // 키 생성 (예: "생활관식당_점심")
    final key = '${restaurant.name}_${meal.mealTime.name}';

    // 특정 시간대(점심)을 담을 공간(바구니)가 있는지 확인하고 없으면 빈 바구니를 만듬
    if (!tempMap.containsKey(key)) {
      tempMap[key] = MealByCafeteria(
        cafeteriaName: restaurant.name,
        // MealByCafeteria 모델에 맞게 데이터 채우기
        hours: _createHoursFromRestaurant(restaurant),
        meals: [],
      );
    }
    // MealItem 모델로 변환하여 추가
    tempMap[key]!.meals.add(
      MealItem(course: meal.course, mainMenu: meal.menu, price: meal.price),
    );
  }

  // 최종적으로 시간대별로 그룹화
  final Map<String, List<MealByCafeteria>> grouped = {
    '아침': [],
    '점심': [],
    '저녁': [],
  };
  tempMap.forEach((key, value) {
    if (key.endsWith('breakfast')) grouped['아침']!.add(value);
    if (key.endsWith('lunch')) grouped['점심']!.add(value);
    if (key.endsWith('dinner')) grouped['저녁']!.add(value);
  });

  return grouped;
}

/// Restaurant 객체로부터 Hours 객체를 생성하는 헬퍼 함수
Hours _createHoursFromRestaurant(Restaurant r) {
  return Hours(
    breakfast: r.breakfastHours,
    lunch: r.lunchHours,
    dinner: r.dinnerHours,
  );
}
