import 'package:bobmoo/collections/meal_collection.dart';
import 'package:isar_community/isar.dart';

part 'restaurant_collection.g.dart'; // build_runner가 생성할 파일

@Collection()
class Restaurant {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true) // 식당 이름은 고유해야 함. 중복 시 덮어쓰기
  late String name;

  late String breakfastHours;
  late String lunchHours;
  late String dinnerHours;

  // Meal collection에서 이 Restaurant을 참조할 때 사용될 역링크
  // 이 식당에 속한 모든 Meal 데이터를 참조할 수 있음
  @Backlink(to: "restaurant")
  final meals = IsarLinks<Meal>();
}
