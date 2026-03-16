# lib/ — Dart 앱 코드

## OVERVIEW

Flutter 앱 전체 소스. Clean Architecture 레이어가 폴더로 분리되어 있으나 abstract interface 없이 concrete class 직접 주입.

## DEPENDENCY FLOW

```
Screens → Providers (ChangeNotifier)
Screens → Repository (via GetIt locator)
Providers → Services (직접 HTTP — SearchProvider)
Repository → Services + Isar
Services → External (HTTP, Firebase, HomeWidget)
```

## WHERE TO LOOK

| Task | Location | Notes |
|------|----------|-------|
| DI 등록 순서/대상 변경 | `locator.dart` | SharedPreferences → Isar → MenuService → MealRepository 순 |
| Provider 추가 | `main.dart` MultiProvider | `create: (_) => NewProvider()..init()` 패턴 |
| 새 화면 추가 | `main.dart` `onGenerateRoute` | Glance 위젯 콜백 경로 정규화 switch 유지 |
| 새 모델 추가 | `models/` | API DTO는 `fromJson` factory. 뷰 모델은 별도 파일 |
| SharedPreferences 키 | `repositories/meal_repository.dart`, `providers/univ_provider.dart` | `selectedUniv`, `lastFetchedSchoolNameK`, `widgetData`, `selectedCafeteriaName` |
| 유틸리티 함수 추가 | `utils/` | `meal_utils.dart` (groupMeals), `hours_parser.dart` (운영시간 파싱) |
| UI 컴포넌트 추가 | `ui/components/` | buttons, cards, meal 하위 폴더 |
| 테마/색상/타이포 변경 | `ui/theme/` | `AppColors`, `AppTypography`, `AppShadow` |

## CONVENTIONS

- GetIt `locator`는 전역 변수. 배경 isolate에서도 `setupLocator()` 재호출하여 사용
- Provider는 `init()` 메서드에서 초기 데이터 로드 → `MultiProvider`의 `create`에서 `..init()` 체이닝
- Repository만 캐시/네트워크 판단. Provider/Screen이 직접 Service 호출 금지 (아래 예외 제외)
- `flutter_screenutil` 사용: 크기 `w`/`h`/`r`/`sp` suffix
- 날짜는 항상 `DateUtils.dateOnly()` 정규화 후 비교

## ANTI-PATTERNS

- `SearchProvider`가 `http.get` 직접 호출 — 이미 존재하는 예외. 새 provider에서 반복 금지
- 화면에 비즈니스 로직 직접 작성 금지 — helper/provider로 분리 (→ screens/AGENTS.md 참조)
- `MenuService.getMenu`가 실패 시 generic `Exception` throw — `NetworkException` 미사용
