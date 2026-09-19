import 'package:flutter/foundation.dart';

abstract class AppLogger {
  /// 개발 로직 확인용 디버그 로그
  static void d(String message, {String? tag}) {
    _log('🐛 [DEBUG]', message, tag: tag);
  }

  /// 주요 비즈니스 이벤트 및 상태 안내 로그
  static void i(String message, {String? tag}) {
    _log('ℹ️ [INFO]', message, tag: tag);
  }

  /// 경고 로그 (예외 상황이지만 앱 실행엔 문제가 없는 경우)
  static void w(String message, {String? tag}) {
    _log('⚠️ [WARN]', message, tag: tag);
  }

  /// 에러 전용 로그 (Exception / Error 처리)
  static void e(
    String message, {
    dynamic error,
    StackTrace? stackTrace,
    String? tag,
  }) {
    _log(
      '❌ [ERROR]',
      message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// 내부 공통 로깅 출력 함수
  static void _log(
    String levelPrefix,
    String message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    if (!kDebugMode) return;

    final tagStr = tag != null ? ' [$tag]' : '';
    final errorStr = error != null ? ' | Details: $error' : '';

    debugPrint('$levelPrefix$tagStr $message$errorStr');

    if (stackTrace != null) {
      debugPrint('📜 [StackTrace]\n$stackTrace');
    }
  }
}
