import 'package:flutter/foundation.dart';

abstract class AppLogger {
  /// 디버그 모드에서만 실행되는 디버그 로그
  static void d(String message) {
    if (kDebugMode) {
      debugPrint(message);
    }
  }

  /// 에러 전용 로그 (필요시 추가)
  static void e(String message, [dynamic error]) {
    if (kDebugMode) {
      debugPrint('❌ [ERROR] $message ${error ?? ''}');
    }
  }
}
