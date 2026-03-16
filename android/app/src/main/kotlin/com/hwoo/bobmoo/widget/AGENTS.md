# widget/ — Android Glance 홈 위젯

## OVERVIEW

Jetpack Glance 기반 2종 위젯. Flutter → SharedPreferences(`widgetData` JSON) → Kotlin 파싱 → Composable UI.

## STRUCTURE

```
widget/
├── MealGlanceWidget.kt          # 단일 식당 위젯 (대표 식당 or 첫 번째)
├── AllCafeteriasGlanceWidget.kt  # 전체 식당 위젯 (4x2)
├── WidgetUpdateManager.kt        # 중앙 업데이트 스케줄러 (BroadcastReceiver + AlarmManager)
├── RefreshWidgetAction.kt        # 위젯 새로고침 ActionCallback
├── data/                         # JSON 파싱
│   ├── AllCafeteriasDataParser.kt
│   └── MealWidgetDataParser.kt
├── receiver/                     # GlanceAppWidgetReceiver + BootReceiver
│   ├── MealGlanceWidgetReceiver.kt
│   ├── AllCafeteriasGlanceWidgetReceiver.kt
│   └── BootReceiver.kt
├── ui/                           # Glance Composable UI
│   ├── MealWidgetUI.kt
│   ├── AllCafeteriasWidgetUI.kt
│   └── WidgetCommonComponents.kt
└── theme/                        # 위젯 전용 타이포그래피
    ├── WidgetTypography.kt
    └── TypographyTokens.kt       # tool/generate_typography_tokens.dart로 생성
```

## DATA FLOW

```
Flutter WidgetService.saveAllCafeteriasWidgetData()
  → HomeWidget.saveWidgetData("widgetData", JSON)
  → SharedPreferences
  → HomeWidget.updateWidget(qualifiedAndroidName)
  → GlanceWidgetReceiver.onUpdate()
  → GlanceWidget.provideGlance()
  → AllCafeteriasDataParser.parseAllCafeterias(json, now)
  → Composable UI
```

## WHERE TO LOOK

| Task | Location | Notes |
|------|----------|-------|
| 위젯 UI 변경 | `ui/` | Glance Composable. Material 위젯 아님 |
| 데이터 파싱 변경 | `data/` | Flutter JSON 구조 변경 시 반드시 동기화 |
| 업데이트 주기 변경 | `WidgetUpdateManager.kt` | 30분 정기 + 식사 경계(8h/12h/18h) |
| 대표 식당 로직 | `MealGlanceWidget.kt` | `selectedCafeteriaName` SharedPreferences 키 |
| 부팅 시 복원 | `receiver/BootReceiver.kt` | 재부팅 후 AlarmManager 재등록 |
| 타이포 토큰 갱신 | `theme/TypographyTokens.kt` | `dart run tool/generate_typography_tokens.dart`로 재생성 |

## CRITICAL RULES

- `TypographyTokens.kt` 수동 편집 금지 — 코드 생성 스크립트로 갱신도 하지말고 편집할일 있으면 반드시 물어보기!! 직접 수정한값 있기때문에
- `HomeWidgetPlugin.getData(context)` 키 이름은 Flutter 측 `WidgetService`와 반드시 일치
- `MealInfo.empty()`로 데이터 없는 상태 명시적 처리 — null 전달 금지
- Receiver 클래스의 FQCN은 `lib/constants/app_constants.dart`와 `AndroidManifest.xml`에 등록 필수
