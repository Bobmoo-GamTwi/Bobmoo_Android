// 데이터를 편하게 다루기 위한 작은 헬퍼 클래스
import 'package:bobmoo/models/menu_model.dart';

class MealByCafeteria {
  final String cafeteriaName;
  final Hours hours;
  final List<MealItem> meals;

  MealByCafeteria({
    required this.cafeteriaName,
    required this.hours,
    required this.meals,
  });
}
