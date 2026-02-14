import 'package:bobmoo/models/meal_widget_data.dart';

/// 여러 식당 정보를 담아 위젯에 전달할 컨테이너 데이터 모델
class AllCafeteriasWidgetData {
  final List<MealWidgetData> cafeterias;

  AllCafeteriasWidgetData({
    required this.cafeterias,
  });

  /// 위젯(Kotlin)에서 파싱할 수 있는 JSON 형태로 변환
  /// 최종 결과: { "cafeterias": [ { cafeteria 1 json }, { cafeteria 2 json } ] }
  Map<String, dynamic> toJson() {
    return {
      'cafeterias': cafeterias.map((data) => data.toJson()).toList(),
    };
  }
}
