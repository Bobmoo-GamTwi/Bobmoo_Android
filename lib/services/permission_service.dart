import 'package:flutter/services.dart';

class PermissionService {
  // MainActivity에서 정의한 채널 이름과 동일하게 설정
  static const _platform = MethodChannel('com.hwoo.bobmoo/alarm_permission');

  // 네이티브 코드를 호출하여 권한 상태를 확인하는 함수
  static Future<bool> canScheduleExactAlarms() async {
    final bool? hasPermission = await _platform.invokeMethod(
      'canScheduleExactAlarms',
    );
    return hasPermission ?? false;
  }

  // 네이티브 코드를 호출하여 설정 화면을 여는 함수W
  static Future<void> openAlarmPermissionSettings() async {
    await _platform.invokeMethod('openAlarmPermissionSettings');
  }
}
