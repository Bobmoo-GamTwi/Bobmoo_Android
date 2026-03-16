# PROJECT KNOWLEDGE BASE

**Generated:** 2026-03-16
**Commit:** a006dc7
**Branch:** chore/#34-setup-claude-code-foundation

## OVERVIEW

Bobmoo(밥묵자) — 대학 학식 메뉴 조회 Flutter 앱. Android 단일 타깃.
Clean Architecture + Provider + GetIt DI. Isar 로컬 캐시, Firebase Analytics, Android Glance 홈 위젯.

## STRUCTURE

```
bobmoo_android/
├── lib/                    # Dart 앱 코드 (→ lib/AGENTS.md)
│   ├── collections/        # Isar 스키마 (→ collections/AGENTS.md)
│   ├── constants/           # 앱 상수 (WorkManager, Widget receiver FQCN)
│   ├── models/              # API DTO + 뷰 모델
│   ├── providers/           # ChangeNotifier 상태관리
│   ├── repositories/        # 캐시/네트워크 오케스트레이션
│   ├── screens/             # 화면 + 헬퍼 (→ screens/AGENTS.md)
│   ├── services/            # HTTP/배경작업/위젯/분석 (→ services/AGENTS.md)
│   ├── ui/                  # 공통 컴포넌트 + 테마
│   └── utils/               # 유틸리티 함수
├── android/.../widget/      # Kotlin Glance 위젯 (→ widget/AGENTS.md)
├── test/                    # flutter_test 유닛/위젯 테스트
├── tool/                    # 코드 생성 스크립트 (README 트리, 타이포 토큰)
├── docs/analytics/          # Firebase 이벤트 스키마 문서
├── .claude/skills/          # AI 에이전트 스킬 (→ 아래 SKILLS 섹션 참조)
└── .github/                 # 이슈/PR 템플릿 (CI 워크플로우 없음)
```

## WHERE TO LOOK

| Task | Location | Notes |
|------|----------|-------|
| 앱 초기화 순서 변경 | `lib/main.dart` | Firebase → Analytics → Locale → GetIt → WorkManager → runApp |
| DI 등록 추가/변경 | `lib/locator.dart` | GetIt 싱글톤. 배경 isolate도 `setupLocator()` 재호출 |
| 캐시 정책 수정 | `lib/repositories/meal_repository.dart` | 24h TTL, 학교 변경 감지, StaleDataException fallback |
| 라우팅 추가 | `lib/main.dart` `onGenerateRoute` | Glance 위젯 콜백 경로 정규화 로직 주의 |
| 위젯 데이터 변경 | `lib/screens/home_widget_sync_helper.dart` → `lib/services/widget_service.dart` | Flutter→Android HomeWidget 브릿지 |
| 배경 동기화 | `lib/services/background_service.dart` | `@pragma('vm:entry-point')` 유지 필수 |
| 분석 이벤트 추가 | `lib/services/analytics_service.dart` + `docs/analytics/event_schema.md` | 스키마 문서와 코드 동기화 |
| Isar 스키마 변경 | `lib/collections/*.dart` → `build_runner build` | `.g.dart` 재생성 필수 |
| Android 위젯 UI | `android/.../widget/ui/` | Jetpack Glance Composable |
| 브랜치/커밋/PR 규칙 | `.claude/skills/shared/conventions.md` | 단일 소스. git-master 스킬 참조 |
| 빌드 flavor 설정 | `android/app/build.gradle.kts` | dev/staging/prod. `key.properties` 필요 |

## CONVENTIONS

컨벤션 단일 소스: `.claude/skills/shared/conventions.md`
- 커밋 메시지, 브랜치, PR 제목, 이슈 제목 형식, 라벨/우선순위 휴리스틱 모두 해당 파일 참조
- 이 섹션에서는 conventions.md에 없는 프로젝트 고유 규칙만 기술

프로젝트 고유 규칙:
- 로케일: `ko_KR` 기준, 날짜 포맷은 `intl` 패키지
- 폰트: Pretendard (기본), NanumSquareRound (보조)
- 테마: Material 3, `AppColors` 중앙 관리, `flutter_screenutil` 반응형

## SKILLS

`.claude/skills/` 디렉토리에 AI 에이전트 스킬이 정의되어 있다. 각 스킬은 특정 워크플로우를 자동화/정규화한다.

| 스킬 | 경로 | 용도 |
|------|------|------|
| `git-master` | `.claude/skills/git-master/SKILL.md` | 브랜치 생성, 커밋, PR 작성 시 네이밍/형식 검증 |
| `linear-issue-policy` | `.claude/skills/linear-issue-policy/SKILL.md` | Linear 이슈 생성 시 필수 필드 누락 방지, 제목 정규화 |
| `linear-github-issue-sync` | `.claude/skills/linear-github-issue-sync/SKILL.md` | Linear↔GitHub 이슈 양방향 동기화, 링크 보장 |
| `shared/conventions` | `.claude/skills/shared/conventions.md` | 위 스킬들이 공통 참조하는 네이밍/태그/형식 규칙 |

스킬 로드: 해당 작업 요청 시 `load_skills=["git-master"]` 등으로 활성화

## ANTI-PATTERNS (THIS PROJECT)

- `SearchProvider`가 HTTP 직접 호출 — Repository 패턴 우회. 새 provider 추가 시 동일 패턴 답습 금지
- 화면에 비즈니스 로직 과다 — `home_screen.dart` (912줄). 새 화면은 로직을 helper/provider로 분리
- Isar `.g.dart` 수동 편집 금지 — `build_runner build`로만 생성
- `@pragma('vm:entry-point')` 제거 금지 — 배경 isolate 진입점 소실
- 릴리스 키 (`key.properties`, `.jks`) 커밋 금지
- 영어-only 커밋 메시지 금지, 에이전트/툴 광고 문구 커밋 메시지 삽입 금지
- debug 빌드도 release signingConfig 사용 중 — debug APK 외부 공유 주의

## COMMANDS

```bash
# 개발
flutter run --flavor dev
flutter run --flavor prod

# 테스트
flutter test
flutter test test/menu_model_test.dart

# 빌드
flutter build apk --flavor prod --release
flutter build appbundle --flavor prod --release

# Isar 코드 생성
dart run build_runner build

# README 트리 갱신
dart run tool/generate_readme_structure.dart

# 타이포 토큰 생성
dart run tool/generate_typography_tokens.dart

# 분석
flutter analyze
```

## NOTES

- CI 워크플로우 없음 — `.github/workflows/` 비어있음. 빌드/테스트 자동화 미구축
- `lib/` 소스에 TODO/FIXME/HACK 마커 없음 — 깨끗한 상태 유지 중
- `android/build.gradle.kts`가 빌드 출력을 `../../build`로 리다이렉트
- `pubspec.yaml`에 `default-flavor: prod` 설정 — flavor 미지정 시 prod 사용
- `analysis_options.yaml`: `trailing_commas: preserve` 설정
- 이벤트 스키마 문서(`docs/analytics/event_schema.md`) v0.8 — 코드와 동기화 상태 확인 필요
