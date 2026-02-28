import 'dart:convert';
import 'package:bobmoo/constants/app_constants.dart';
import 'package:home_widget/home_widget.dart';
import 'package:bobmoo/models/all_cafeterias_widget_data.dart';
import 'package:flutter/services.dart';

class WidgetService {
  static const String _widgetDataKey = 'widgetData';
  static const MethodChannel _platform = MethodChannel(widgetControlChannelName);

  static Future<void> refreshAllWidgets() async {
    await HomeWidget.updateWidget(
      qualifiedAndroidName: mealWidgetReceiverClassName,
    );
    await HomeWidget.updateWidget(
      qualifiedAndroidName: allCafeteriasWidgetReceiverClassName,
    );

    // Native scheduler에도 즉시 갱신 신호를 전달합니다.
    await _platform.invokeMethod(refreshWidgetsNowMethod);
  }

  /// 여러 식당 데이터를 JSON으로 저장하고 '모든 식당' 위젯 업데이트 트리거 (신규 4x2 위젯용)
  static Future<void> saveAllCafeteriasWidgetData(
    AllCafeteriasWidgetData data,
  ) async {
    final jsonString = jsonEncode(data.toJson());
    await HomeWidget.saveWidgetData<String>(_widgetDataKey, jsonString);
    await refreshAllWidgets();
  }
}
