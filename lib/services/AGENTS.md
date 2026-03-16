# services/ — 외부 연동 및 백그라운드 서비스

## OVERVIEW

4개 서비스. HTTP API, 배경 동기화, 홈 위젯 브릿지, Firebase Analytics.

## WHERE TO LOOK

| Task | Location | Notes |
|------|----------|-------|
| API 엔드포인트 변경 | `menu_service.dart` | `_baseUrl` 하드코딩. `getMenu(date, schoolNameK)` 단일 메서드 |
| 배경 동기화 로직 | `background_service.dart` | `callbackDispatcher` — WorkManager 콜백. 별도 isolate 실행 |
| 위젯 데이터 저장 | `widget_service.dart` | `HomeWidget.saveWidgetData` → `refreshAllWidgets` |
| 분석 이벤트 추가 | `analytics_service.dart` | 메서드 추가 후 `docs/analytics/event_schema.md` 동기화 |

## CRITICAL RULES

- `background_service.dart`의 `@pragma('vm:entry-point')` **절대 제거 금지** — 배경 isolate 진입점
- `callbackDispatcher`는 최상위 함수. 배경 isolate에서 `Firebase.initializeApp()` + `setupLocator()` 재호출 필수
- `AnalyticsService`는 싱글톤(`instance`) — `_isInitialized` guard로 중복 초기화 방지
- `AnalyticsService._logEvent`에서 null 파라미터 자동 제거, 비표준 타입은 `.toString()` 변환

## CONVENTIONS

- `AnalyticsService` 메서드 시그니처: enum 타입 파라미터 사용 (`MealApiRequestType`, `WidgetSyncResult` 등)
- `_safeLogEvent`로 Firebase 호출 실패 조용히 처리 — 분석 오류가 앱 크래시로 전파되지 않음
- `WidgetService`는 static 메서드만 — 인스턴스 생성 불필요
- `MenuService`는 raw `Exception('Failed to load menu')` throw — `NetworkException` 미사용 (기존 결함)
