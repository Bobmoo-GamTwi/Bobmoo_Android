# collections/ — Isar 로컬 DB 스키마

## OVERVIEW

3개 컬렉션 + 3개 `.g.dart` 생성 파일. `isar_community` 패키지 사용.

## SCHEMA

| Collection | 역할 | 인덱스 | 링크 |
|---|---|---|---|
| `Meal` | 날짜별 식단 항목 | `@Index()` on `date` | `IsarLink<Restaurant>` (정방향) |
| `Restaurant` | 식당 정보 + 운영시간 | `@Index(unique: true, replace: true)` on `name` | `@Backlink` `IsarLinks<Meal>` (역방향) |
| `MenuCacheStatus` | 날짜별 캐시 TTL 추적 | `@Index(unique: true, replace: true)` on `date` | 없음 |

- `MenuCacheStatus.accessor`: `"menuCacheStatuses"` (복수형 명시)
- `MealTime` enum: `@Enumerated(EnumType.ordinal)` — ordinal 순서 변경 금지

## CRITICAL RULES

- `.g.dart` 파일 수동 편집 **절대 금지** — `dart run build_runner build`로만 재생성
- 스키마 필드 추가/삭제/타입 변경 후 반드시 `build_runner build` 실행
- `Meal` 조회 후 `meal.restaurant.load()` 호출 필수 — 링크는 lazy load
- `Restaurant`의 `unique: true, replace: true` — 동일 이름 식당 자동 덮어쓰기
- `Id id = Isar.autoIncrement` 패턴 유지
