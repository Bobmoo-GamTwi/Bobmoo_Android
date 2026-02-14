import 'dart:convert';
import 'package:home_widget/home_widget.dart';
import 'package:bobmoo/models/all_cafeterias_widget_data.dart';

class WidgetService {
  static const String _widgetDataKey = 'widgetData';

  /// 여러 식당 데이터를 JSON으로 저장하고 '모든 식당' 위젯 업데이트 트리거 (신규 4x2 위젯용)
  static Future<void> saveAllCafeteriasWidgetData(
    AllCafeteriasWidgetData data,
  ) async {
    final jsonString = jsonEncode(data.toJson());
    await HomeWidget.saveWidgetData<String>(_widgetDataKey, jsonString);

    // 두 위젯의 Receiver를 모두 호출하여 동시에 업데이트합니다.
    await HomeWidget.updateWidget(
      qualifiedAndroidName: 'com.hwoo.bobmoo.MealGlanceWidgetReceiver',
    );
    await HomeWidget.updateWidget(
      qualifiedAndroidName: 'com.hwoo.bobmoo.AllCafeteriasGlanceWidgetReceiver',
    );
  }
}
