// 1. 최상위 응답 모델
class MenuResponse {
  final String date;
  final String school;
  final List<Cafeteria> cafeterias;

  MenuResponse({
    required this.date,
    required this.school,
    required this.cafeterias,
  });

  factory MenuResponse.fromJson(Map<String, dynamic> json) {
    // 'cafeterias' 배열을 Cafeteria 객체 리스트로 변환
    var cafeteriaList = (json['cafeterias'] as List)
        .map((item) => Cafeteria.fromJson(item))
        .toList();

    return MenuResponse(
      date: json['date'],
      school: json['school'],
      cafeterias: cafeteriaList,
    );
  }
}

// 2. 식당 모델
class Cafeteria {
  final String name;
  final Hours hours;
  final Meals meals;

  Cafeteria({
    required this.name,
    required this.hours,
    required this.meals,
  });

  factory Cafeteria.fromJson(Map<String, dynamic> json) {
    return Cafeteria(
      name: json['name'],
      // 자식 모델의 fromJson을 재귀적으로 호출
      hours: Hours.fromJson(json['hours']),
      meals: Meals.fromJson(json['meals']),
    );
  }
}

// 3. 운영 시간 모델
class Hours {
  final String breakfast;
  final String lunch;
  final String dinner;

  Hours({
    required this.breakfast,
    required this.lunch,
    required this.dinner,
  });

  factory Hours.fromJson(Map<String, dynamic> json) {
    return Hours(
      breakfast: json['breakfast'],
      lunch: json['lunch'],
      dinner: json['dinner'],
    );
  }
}

// 4a. 식사 모델
class Meals {
  final List<MealItem> breakfast;
  final List<MealItem> lunch;
  final List<MealItem> dinner;

  Meals({
    required this.breakfast,
    required this.lunch,
    required this.dinner,
  });

  factory Meals.fromJson(Map<String, dynamic> json) {
    // json['breakfast']는 List<dynamic> 타입이므로, 각 항목을 MealItem.fromJson으로 변환
    var breakfastList = (json['breakfast'] as List? ?? [])
        .map((item) => MealItem.fromJson(item))
        .toList();
    var lunchList = (json['lunch'] as List? ?? [])
        .map((item) => MealItem.fromJson(item))
        .toList();
    var dinnerList = (json['dinner'] as List? ?? [])
        .map((item) => MealItem.fromJson(item))
        .toList();

    return Meals(
      breakfast: breakfastList,
      lunch: lunchList,
      dinner: dinnerList,
    );
  }
}

// 4b. 개별 메뉴 아이템 모델
/// course: A코스, B코스 등
///
/// mainMenu: 메뉴들
///
/// price: 가격
class MealItem {
  final String course;
  final String mainMenu;
  final int price;

  MealItem({
    required this.course,
    required this.mainMenu,
    required this.price,
  });

  factory MealItem.fromJson(Map<String, dynamic> json) {
    return MealItem(
      course: json['course'],
      mainMenu: json['mainMenu'],
      price: json['price'],
    );
  }
}
