abstract class ApiConstants {
  // 기본 서버 주소
  // --dart-define=BASE_URL=... 값이 전달되면 해당 값을 사용하고,
  // 전달되지 않으면 defaultValue(로컬 에뮬레이터 주소)를 사용합니다.
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://10.0.2.2:8080',
  );

  // API 버저닝
  static const String apiVersion = "api/v1";

  // 엔드포인트 URL

  /// "$baseUrl$apiVersion/schools"
  static String get schools => "$baseUrl$apiVersion/schools";

  /// "$baseUrl$apiVersion/menu"
  static String get menu => "$baseUrl$apiVersion/menu";
}
