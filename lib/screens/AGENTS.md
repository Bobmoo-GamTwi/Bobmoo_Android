# screens/ — 앱 화면 및 화면 보조 로직

## OVERVIEW

9개 파일. 화면(Screen/Gate) + 화면별 헬퍼(analytics, widget sync). 라우팅은 `main.dart` `onGenerateRoute`에서 관리.

## NAVIGATION FLOW

```
AppGate (/) → [학교 선택 여부 판단]
  ├── OnboardingScreen (/onboarding) → SelectSchoolScreen (/select_school)
  └── HomeScreen (/home) → SettingsScreen (/settings)
                          → SelectSchoolScreen (/select_school, allowBack=true)
```

- `AppGate`: 스플래시(1초) → `UnivProvider.isInitialized` 대기 → 자동 리다이렉트
- `SplashScreen`, `LoadingScreen`: AppGate 내부 전용. 독립 라우트 없음

## WHERE TO LOOK

| Task | Location | Notes |
|------|----------|-------|
| 화면 진입 분기 변경 | `app_gate.dart` | `_tryRedirect()` — 학교 선택 여부로 분기 |
| 식단 데이터 로딩 | `home_screen.dart` `_fetchData()` | `MealRepository.getMealsForDateWithSource` 사용 |
| 날짜 변경 (스와이프/피커) | `home_screen.dart` `_changeSelectedDateByDays`, `_selectDate` | analytics context 설정 → setState |
| 위젯 동기화 트리거 | `home_widget_sync_helper.dart` | `syncWidgetData()` — 오늘 데이터를 위젯용 JSON 변환 후 저장 |
| 분석 이벤트 중복 방지 | `home_analytics_helper.dart` | `_lastEmptyStateKey`, `_loggedErrorStateKeys`로 guard |
| Pull-to-Refresh | `home_screen.dart` `_refreshMeals()` | `forceRefreshMeals` → 실패 시 DB fallback |
| 인앱 업데이트 | `home_screen.dart` `_checkForUpdate()` | `InAppUpdate` flexible update |

## ANTI-PATTERNS

- `home_screen.dart` 912줄 — 위젯 업데이트, 분석 로그, 스와이프, 날짜 피커 등 과다 로직. 새 화면은 이 구조 답습 금지
- `_updateWidgetOnly`는 debounce(30초) + in-progress guard 포함 — 호출 순서 변경 시 주의
- 운영시간 기반 식사 순서 로직(`_orderedMealTypesByDynamicHours`)이 화면에 직접 존재 — 유틸로 분리 가능하나 현재 미분리
