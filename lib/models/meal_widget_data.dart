import 'package:bobmoo/models/menu_model.dart';

/// 위젯에 전달할 경량 데이터 모델
class MealWidgetData {
  final String date; // yyyy-MM-dd
  final String cafeteriaName;
  final Hours hours; // "08:00-09:00" 형식 문자열 보존
  final List<MealItem> breakfast; // 아침 코스별 아이템
  final List<MealItem> lunch; // 점심 코스별 아이템
  final List<MealItem> dinner; // 저녁 코스별 아이템

  MealWidgetData({
    required this.date,
    required this.cafeteriaName,
    required this.hours,
    required this.breakfast,
    required this.lunch,
    required this.dinner,
  });

  /// Cafeteria + 날짜에서 위젯 데이터로 변환
  factory MealWidgetData.fromCafeteria({
    required String date,
    required Cafeteria cafeteria,
  }) {
    return MealWidgetData(
      date: date,
      cafeteriaName: cafeteria.name,
      hours: cafeteria.hours,
      breakfast: cafeteria.meals.breakfast,
      lunch: cafeteria.meals.lunch,
      dinner: cafeteria.meals.dinner,
    );
  }

  /// 여러 시간대가 분리되어 있는 `grouped` 구조에서 한 식당명을 기준으로 생성
  /// grouped: {'아침': [MealByCafeteria...], '점심': [...], '저녁': [...]}
  factory MealWidgetData.fromGrouped({
    required String date,
    required String cafeteriaName,
    required Map<String, List<dynamic>> grouped, // MealByCafeteria 유사 구조
    required Hours hours,
  }) {
    List<MealItem> pick(String key) {
      final list = grouped[key] ?? const [];
      final found = list.cast<dynamic>().firstWhere(
        (e) => e != null && (e as dynamic).cafeteriaName == cafeteriaName,
        orElse: () => null,
      );
      if (found == null) return <MealItem>[];
      final meals = (found as dynamic).meals as List<MealItem>;
      return meals;
    }

    return MealWidgetData(
      date: date,
      cafeteriaName: cafeteriaName,
      hours: hours,
      breakfast: pick('아침'),
      lunch: pick('점심'),
      dinner: pick('저녁'),
    );
  }

  Map<String, dynamic> toJson() => {
    'date': date,
    'cafeteriaName': cafeteriaName,
    'hours': {
      'breakfast': hours.breakfast,
      'lunch': hours.lunch,
      'dinner': hours.dinner,
    },
    'meals': {
      'breakfast': breakfast
          .map(
            (e) => {
              'course': e.course,
              'mainMenu': e.mainMenu,
              'price': e.price,
            },
          )
          .toList(),
      'lunch': lunch
          .map(
            (e) => {
              'course': e.course,
              'mainMenu': e.mainMenu,
              'price': e.price,
            },
          )
          .toList(),
      'dinner': dinner
          .map(
            (e) => {
              'course': e.course,
              'mainMenu': e.mainMenu,
              'price': e.price,
            },
          )
          .toList(),
    },
  };
}
