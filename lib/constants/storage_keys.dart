abstract class LocalStorageKeys {
  /// 선택된 대학교 정보 (University JSON String)
  static const String selectedUniv = 'selectedUniv';
}

abstract class WidgetStorageKeys {
  /// 홈 위젯용 전체 식당 식단 JSON
  /// HomeWidget(내부 SharedPreferences) — WidgetService, Glance 위젯
  static const String widgetData = 'widgetData';

  /// 홈 위젯 대표 식당 이름
  /// HomeWidget(내부 SharedPreferences) — SettingsScreen, MealGlanceWidget
  static const String selectedCafeteriaName = 'selectedCafeteriaName';
}
