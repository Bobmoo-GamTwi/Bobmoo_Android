---
name: git-master
description: Bobmoo Git 워크플로우를 정규화한다. "브랜치 만들어", "커밋", "PR 올려", "푸시 전 확인" 요청에서 브랜치 `{type}/#{issue}-{slug}`, 커밋 `{tag}({scope}): #{issue} 한국어 설명`, PR `[Tag] 제목`과 템플릿 필수 항목을 검증/보정할 때 사용.
---

# Git Master (Bobmoo Android)

Git 작업에서 `CLAUDE.md`와 GitHub 템플릿 기준을 일관되게 적용한다.

## When to Use

- 브랜치를 새로 만들 때
- 커밋 메시지를 작성하거나 점검할 때
- PR 제목/본문을 작성할 때
- 푸시 전 형식 검사를 할 때

## Reference

- 공통 규칙: [conventions.md](../shared/conventions.md)
- 프로젝트 기준: `CLAUDE.md`
- PR 템플릿: `.github/PULL_REQUEST_TEMPLATE.md`

## Branch Rules

- 형식: `{type}/#{github-issue-number}-{short-description}`
- 허용 type: `feature`, `fix`, `refactor`, `style`, `chore`, `docs`, `hotfix`
- 이슈 번호 없는 브랜치 생성 금지

## Commit Rules

- 형식: `{tag}({scope}): #{issue-number} {Korean description}`
- 예시: `fix(repository): #123 캐시 만료 시 fallback 분기 수정`
- 허용 tag: `feat`, `fix`, `style`, `docs`, `setting`, `add`, `refactor`, `chore`, `hotfix`
- `scope`는 변경 영역을 구체적으로 작성 (`ui`, `provider`, `repository`, `build`, `github` 등)
- 한국어 설명 원칙, 기술 용어만 영어 혼용

## PR Rules

- 제목 형식: `[Tag] 제목`
- 허용 태그: `[Feature]`, `[Fix]`, `[Refactor]`, `[Style]`, `[Chore]`
- 본문은 `.github/PULL_REQUEST_TEMPLATE.md` 구조를 유지한다.
- 관련 이슈 섹션에 아래 두 줄을 모두 포함한다:
  - `Closes #<github-issue-number>`
  - `Closes BOB-<linear-issue-number>`
- 체크리스트 2개 항목을 유지한다.

## Pre-Commit Checklist

커밋 전 반드시 확인:
1. 현재 브랜치명이 브랜치 규칙과 일치하는가
2. 커밋 메시지의 이슈 번호가 브랜치/작업 이슈와 일치하는가
3. 커밋 메시지가 staged 변경 목적과 일치하는가

하나라도 실패하면 커밋을 중단하고 수정안을 먼저 제시한다.

## MUST DO

- GitHub 이슈 번호 없는 브랜치/커밋 금지
- PR 제목 태그 규칙 준수
- PR 본문에서 템플릿 섹션 삭제 금지(선택 섹션 제외)
- 사용자 명시 승인 전 push 금지

## MUST NOT DO

- 임의 브랜치명(`temp`, `test2`, `fix-final`) 사용
- 영어-only 커밋 메시지
- 에이전트/툴 광고성 문구를 커밋 메시지에 삽입
