---
name: linear-github-issue-sync
description: Linear와 GitHub 이슈를 동기화 생성/보정한다. "작업 시작", "작업 준비", "이슈 동기화" 요청에서 동일 제목/본문 유지, 양방향 링크 보장, 한쪽만 존재하는 상태 보완, partial success 명시 보고가 필요할 때 사용.
---

# Linear + GitHub Issue Sync (Bobmoo Android)

작업 시작 단계에서 이슈 시스템이 어긋나지 않도록 양쪽 이슈를 동기화한다.

## When to Use

- "작업 시작", "작업 준비", "이슈 동기화" 요청 시
- Linear 또는 GitHub 한쪽만 존재하는 상태를 보정할 때
- PR 전에 이슈 링크 무결성을 점검할 때

## Reference

- 공통 규칙: [conventions.md](../shared/conventions.md)
- 이슈 템플릿: `.github/ISSUE_TEMPLATE/task.yml`
- 프로젝트 기준: `CLAUDE.md`

## Sync Rules

1. 제목은 `[Tag] 한국어 요약`으로 정규화
2. 본문은 `task.yml` 필수 섹션을 모두 포함
3. Linear 이슈 먼저 생성/확인
4. GitHub 이슈를 동일 제목/본문으로 생성/확인
5. 양방향 링크 보장
   - Linear description에 GitHub URL
   - GitHub body 또는 comment에 Linear URL

## Existing Issue Preparation Flow

입력에 기존 키(`BOB-xxx`)가 포함되면:
1. 해당 Linear 이슈를 재사용
2. 연결된 GitHub 이슈 존재 여부 확인
3. 없으면 GitHub 이슈를 생성
4. 양쪽 링크를 업데이트

## Defaults

- Linear: assignee `me`, state `Todo`, priority/labels/due date 설정
- GitHub: 현재 repo 기준, labels 최소 1개, 가능하면 `@me` assignee

## Failure Handling

- 한쪽 성공/한쪽 실패 시 `partial success`로 명시
- 실패 사유와 재시도 필요 액션을 함께 반환
- 링크가 완성되기 전 브랜치/구현 진행을 권장하지 않는다

## Output Format

항상 반환:
- Linear: identifier, URL, state, assignee, priority, labels, due date
- GitHub: issue number, URL, assignee, labels
- Sync status: `full success` 또는 `partial success` + 실패 사유
