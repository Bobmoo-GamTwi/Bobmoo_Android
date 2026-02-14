import 'package:bobmoo/collections/restaurant_collection.dart';
import 'package:isar_community/isar.dart'; // Restaurant 모델 import

part 'meal_collection.g.dart'; // build_runner가 생성할 파일

enum MealTime {
  breakfast,
  lunch,
  dinner,
}

@Collection()
class Meal {
  Id id = Isar.autoIncrement;

  @Index() // 날짜로 데이터를 빠르게 조회하기 위해 인덱스 추가
  late DateTime date;

  @Enumerated(EnumType.ordinal)
  late MealTime mealTime;

  late String course;
  late String menu;
  late int price;

  // 이 식사가 어느 Restaurant에 속하는지에 대한 정보 (정방향 링크)
  final restaurant = IsarLink<Restaurant>();
}
