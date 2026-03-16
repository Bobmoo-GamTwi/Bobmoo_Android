# Bobmoo 공통 컨벤션 (Android/Flutter)

이 문서는 `git-master`, `linear-issue-policy`, `linear-github-issue-sync` 스킬이 공통 참조하는 단일 기준입니다.

## Prefix/Tag 매핑

| 의미 | GitHub 이슈 제목 태그 | 브랜치 type | 커밋 tag |
|------|------------------------|-------------|----------|
| 기능 추가 | `[Feature]` | `feature` | `feat` |
| 버그 수정 | `[Fix]` | `fix` | `fix` |
| 구조 개선 | `[Refactor]` | `refactor` | `refactor` |
| 스타일/UI 정리 | `[Style]` | `style` | `style` |
| 운영/잡무 | `[Chore]` | `chore` | `chore` |
| 긴급 수정 | `[Fix]` | `hotfix` | `hotfix` |
| 문서 변경 | `[Chore]` | `docs` | `docs` |

## 네이밍 형식

| 대상 | 형식 | 예시 |
|------|------|------|
| GitHub 이슈 제목 | `[Tag] 한국어 요약` | `[Feature] 홈 화면 식단 카드 UI 개선` |
| 브랜치 | `{type}/#{github-issue-number}-{short-description}` | `chore/#34-setup-claude-code-foundation` |
| 커밋 메시지 | `{tag}({scope}): #{issue-number} {Korean description}` | `chore(github): #34 이슈 템플릿 단일화` |
| PR 제목 | `[Tag] 제목` | `[Fix] 캐시 만료 시 에러 처리 수정` |

## GitHub 이슈 본문 기준 (`task.yml`)

필수 항목:
- `📌 작업 요약`
- `✔️ To-Do (완료 기준)`
- `📱 영향 범위`

선택 항목:
- `📝 작업 페이지 캡처 (선택)`

## PR 본문 기준 (`PULL_REQUEST_TEMPLATE.md`)

필수 항목:
- `## 📌 관련 이슈`
  - `Closes #<github-issue-number>`
  - `Closes BOB-<linear-issue-number>`
- `## ✨ 작업 내용`
- `## ✅ 체크리스트`
  - `PR 제목 규칙 준수`
  - `빌드 테스트 완료`

## Linear 이슈 상태 전이

작업 흐름에 따라 Linear 이슈 상태를 자동 전환한다.

| 트리거 | 상태 변경 |
|--------|-----------|
| 이슈 생성 | → `Todo` |
| 브랜치 생성 / 작업 시작 | → `In Progress` |
| PR 생성 | → `In Review` |
| PR 머지 | → `Done` |

- 상태 변경은 해당 작업을 수행하는 스킬이 자동으로 처리한다
- 사용자가 명시적으로 상태를 지정한 경우 그 값을 우선한다

## Priority 휴리스틱 (Linear)

사용자가 지정하지 않으면:

| 레벨 | 값 | 기준 |
|------|---|------|
| Urgent | 1 | 앱 크래시/배포 차단/데이터 손상 |
| High | 2 | 사용자 영향 큰 장애, 릴리스 임박 |
| Medium | 3 | 일반 기능/개선 (기본값) |
| Low | 4 | 유지보수/정리 |

## 라벨 휴리스틱

GitHub 라벨과 Linear 라벨 모두 이슈/PR 생성 시 최소 1개를 부여한다.

GitHub 사용 가능 라벨: `Feature`, `Bug`, `Improvement`, `Refactor`, `Setting`, `Design`, `Release`

키워드 기반 기본 라벨:
- bug/crash/error/fix → `Bug`
- feature/add/implement → `Feature`
- refactor/cleanup → `Refactor`
- ui/style/theme → `Design`
- setting/config/build/ci/gradle → `Setting`
- 개선/improve → `Improvement`

확신이 낮으면 `Improvement`를 사용한다.
