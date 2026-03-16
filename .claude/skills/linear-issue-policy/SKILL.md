---
name: linear-issue-policy
description: Linear 이슈 생성 정책을 강제한다. "Linear 이슈 만들어줘", "작업 준비", "티켓 정리" 요청에서 assignee/state/priority/labels/due date를 누락 없이 채우고 제목을 `[Tag] 한국어 요약`으로 정규화할 때 사용.
---

# Linear Issue Policy (Bobmoo Android)

Linear 이슈를 생성할 때 필수 필드를 빠뜨리지 않고 팀 규칙으로 정규화한다.

## When to Use

- "Linear 이슈 만들어줘", "작업 준비해줘" 요청 시
- 기존 요청 내용을 이슈 형태로 정리할 때
- 제목/우선순위/라벨이 모호한 이슈를 보정할 때

## Reference

- 공통 규칙: [conventions.md](../shared/conventions.md)
- 프로젝트 기준: `CLAUDE.md`

## Required Policy

Linear 이슈 생성 시 기본값:
1. **Assignee**: `me`
2. **State**: `Todo` (없으면 가장 근접한 planned state)
3. **Priority**: 명시 없으면 휴리스틱으로 1~4 추론 (기본 3)
4. **Labels**: 최소 1개
5. **Due Date**: 사용자 지정 또는 오늘

## Title Rule

- 형식: `[Tag] 한국어 요약`
- 허용 태그: `[Feature]`, `[Fix]`, `[Refactor]`, `[Style]`, `[Chore]`
- 사용자가 형식 없이 전달하면 규칙에 맞게 정규화한다.

## Description Rule

본문은 GitHub `task.yml` 구조를 기준으로 작성한다:
- `📌 작업 요약` (필수)
- `✔️ To-Do (완료 기준)` (필수)
- `📱 영향 범위` (필수)
- `📝 작업 페이지 캡처 (선택)`

## Execution Checklist

1. 대상 팀/프로젝트 식별
2. 현재 사용자 확인 후 assignee 설정
3. `Todo` 상태 조회
4. 우선순위/라벨/due date 계산
5. 제목 정규화
6. 이슈 생성 후 identifier/URL 반환

## Output Format

항상 아래를 반환:
- Identifier / URL
- Team / State / Assignee
- Priority / Labels / Due date
- 제목 정규화 여부

## Guardrails

- Assignee를 비우지 않는다 (명시적 미할당 요청 제외)
- Priority/Labels/Due date 누락 금지
- `Backlog` 고정 금지
- 기존 키(`BOB-123`)가 주어지면 새 이슈를 만들기 전에 재사용 가능성 먼저 확인
