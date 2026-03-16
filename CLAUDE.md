# CLAUDE.md

이 문서는 Claude Code가 이 저장소에서 작업할 때 따라야 하는 기준입니다.

## 프로젝트 개요

**Bobmoo(밥묵자)** 는 대학 학식 메뉴를 조회하는 Flutter 앱입니다.  
크로스플랫폼 구조를 사용하지만 현재 운영 타깃은 Android입니다.

## 아키텍처

- 아키텍처: Clean Architecture
- 상태관리: Provider
- DI: GetIt

의존 흐름:
```
Screens → Providers → MealRepository → MenuService(HTTP) / Isar(cache)
```

핵심 규칙:
- `lib/locator.dart` 에서 싱글톤 등록 후 앱 시작 전에 초기화
- `MealRepository` 캐시 정책
  - 24시간 이내 + 동일 학교: Isar 캐시 반환
  - 캐시 미스/만료/학교 변경: API 호출 후 Isar 저장
  - 네트워크 실패 + 오래된 캐시 존재: `StaleDataException` 으로 감싼 데이터 반환
  - 네트워크 실패 + 캐시 없음: 에러 전파
- 예외 타입: `NetworkException`, `StaleDataException`
- 데이터 소스 추적: `MealDataSource` (`dbHit`, `apiFetched`, `dbStaleFallback`)
- 백그라운드 동기화: Workmanager 6시간 주기 (`fetchMealDataTask`, 네트워크 필요)
- 홈 위젯 동기화: `HomeWidgetSyncHelper` 사용

## 주요 파일

| 파일 | 용도 |
|------|------|
| `lib/main.dart` | 앱 엔트리, 라우팅, Material 3 테마 |
| `lib/locator.dart` | GetIt DI 설정 |
| `lib/repositories/meal_repository.dart` | 캐시/네트워크 오케스트레이션 핵심 |
| `lib/providers/univ_provider.dart` | 대학 선택 상태 관리(SharedPreferences 저장) |
| `lib/services/menu_service.dart` | `https://bobmoo.site/api/v1/menu` HTTP 클라이언트 |
| `android/app/build.gradle.kts` | flavor(dev/staging/prod), 서명 설정 |

## 이슈/브랜치/커밋/PR 규칙

기본 흐름:
```
Linear 이슈 생성 → GitHub 이슈 생성 → 브랜치 생성 → 구현 → PR → 머지
```

상세 규칙은 `.claude/skills/shared/conventions.md`를 단일 소스로 사용합니다.

- 브랜치/커밋/PR 규칙: `.claude/skills/git-master/SKILL.md`
- Linear 생성 정책: `.claude/skills/linear-issue-policy/SKILL.md`
- Linear/GitHub 동기화: `.claude/skills/linear-github-issue-sync/SKILL.md`
- GitHub 이슈 템플릿: `.github/ISSUE_TEMPLATE/task.yml`
- PR 템플릿: `.github/PULL_REQUEST_TEMPLATE.md`

## 작업 시 주의사항

- Isar 컬렉션(`lib/collections/*.dart`) 수정 후 `build_runner build` 실행하여 `*.g.dart` 생성
- 릴리스 서명에 `android/key.properties` 필요(저장소 미포함)
- 로케일은 `ko_KR` 기준, 날짜 포맷은 `intl` 사용

## Skills

프로젝트 전용 스킬은 `.claude/skills/`를 기준으로 사용합니다.

| Skill | 용도 |
|------|------|
| `git-master` | 브랜치/커밋/PR 규칙 검증 및 작성 가이드 |
| `linear-issue-policy` | Linear 이슈 생성 기본값/형식 강제 |
| `linear-github-issue-sync` | Linear/GitHub 이슈 동기화 및 상호 링크 보장 |
