# BobMoo Firebase Analytics 이벤트 스키마

## 1) 문서 메타

- 문서 목적: BobMoo 앱의 Firebase Analytics 이벤트 수집 규칙과 이벤트 스키마를 표준화한다.
- 문서 버전: `v0.3`
- 작성일: `2026-03-01`
- 오너: 밥묵자 안드로이드 개발팀
- 상태: 초안 (Draft)
- 변경 이력:
  - `v0.3` (`2026-03-01`): `env` 공용 파라미터(dev/prod) 추가, 앱 시작 시 default event parameter 설정 규칙 추가
  - `v0.2` (`2026-03-01`): `date_change` 확장(`change_source`, `days_delta`), 추가 이벤트 6종 보강, 중복 발화 가드 규칙 추가
  - `v0.1` (`2026-03-01`): 초기 이벤트 스키마 초안 작성

## 2) 목표

- 사용자 행동 데이터를 바탕으로 기능 사용률을 분석한다.
- `screen_view` 기반 퍼널 분석이 가능하도록 라우팅/스크린 명칭을 통일한다.
- 학교 선택/변경, 식단 조회, 위젯 상호작용 패턴을 계량화한다.

## 3) 전역 규칙

### 3.1 이벤트/파라미터 네이밍

- 이벤트명: `snake_case` 사용 (`select_school`, `view_meal`).
- 파라미터명: `snake_case` 사용 (`school_id`, `entry_point`).
- 스크린명: `<feature>_screen` 규칙 사용 (`home_screen`, `select_school_screen`).

### 3.2 데이터 타입 규칙

- `school_id`는 API에서 내려오는 `University.schoolId` 값을 그대로 사용한다.
- 현재 앱 모델 기준 `school_id` 타입은 `int`다.
- 날짜는 `yyyy-MM-dd` 문자열로 통일한다.
- 불리언은 `true/false`로 저장한다.

### 3.3 식별자 및 개인정보(PII) 규칙

- `school_id`는 클라이언트에서 임의 생성/변환하지 않는다.
- 학교명 원문(`schoolName`, `schoolNameK`)은 이벤트 파라미터로 전송하지 않는다.
- 사용자 직접 식별 가능한 정보(이메일, 전화번호, 실명)는 전송하지 않는다.

### 3.4 수집 방식 규칙

- `screen_view`는 `FirebaseAnalyticsObserver`로 자동 수집하는 것을 기본으로 한다.
- 자동 수집이 누락되는 사용자 액션(버튼 탭, 조회 시도, 결과 상태)은 커스텀 이벤트로 보완한다.
- 앱 시작 시 `setDefaultEventParameters`를 통해 `env`를 공용 파라미터로 주입한다.
  - 값 규칙: `prod`(release 빌드), `dev`(debug/profile 빌드)

### 3.5 발화 규칙(중복 방지)

- 상태 노출 이벤트(`meal_empty_state_view`, `meal_error_state_view`)는 화면 리빌드마다 발화하지 않는다.
- 동일 컨텍스트 기준으로 화면 진입당 1회만 발화한다.
  - `meal_empty_state_view`: `school_id + meal_date`
  - `meal_error_state_view`: `school_id + meal_date + error_type`
- 날짜가 변경되면 중복 방지 키를 초기화하고 새 날짜 컨텍스트에서 다시 발화할 수 있다.

## 4) 라우트-스크린 매핑 표준

현재 `main.dart` 라우트 기준:

| route_name | screen_name | 비고 |
|---|---|---|
| `/` | `app_gate_screen` | 시작 진입 및 분기 판단 |
| `/onboarding` | `onboarding_screen` | 초기 온보딩 |
| `/select_school` | `select_school_screen` | 학교 선택 |
| `/home` | `home_screen` | 메인 식단 화면 |
| `/settings` | `settings_screen` | 설정 화면 |

## 5) 공통 파라미터

아래 파라미터는 화면 문맥이 있는 이벤트에 공통으로 넣는다.

| param | type | required | 설명 |
|---|---|---|---|
| `screen_name` | string | N | 이벤트 발생 시점 화면명 (화면 문맥이 있을 때) |
| `route_name` | string | N | 라우트명 (`/home` 등) |
| `app_version` | string | N | 앱 버전 |
| `env` | string | Y | 실행 환경 (`prod` / `dev`) |

안드로이드 단일 플랫폼 운영 기준으로 `platform` 공통 파라미터는 현재 사용하지 않는다.
멀티 플랫폼(iOS/Web) 확장 시 재도입을 검토한다.

## 6) 이벤트 카탈로그 (v0.3)

### 6.1 `screen_view`

- 목적: 화면 전환 기반 퍼널 분석
- 수집 방식: 자동 (`FirebaseAnalyticsObserver`)
- 참고:
  - `FirebaseAnalyticsObserver.nameExtractor`를 사용해 라우트명을 스키마 표준 `screen_name`으로 매핑한다.
    - 예: `/home` -> `home_screen`, `/select_school` -> `select_school_screen`
  - 자동 수집 이벤트는 GA4 기본 필드(`screen_name`, `screen_class`)를 우선 사용한다.
  - `route_name`은 자동 `screen_view`의 필수 필드가 아니며, 필요 시 별도 커스텀 이벤트에서 사용한다.

### 6.2 `app_gate_decision`

- 목적: 앱 시작 시 진입 분기 비율 확인 (`home` vs `onboarding`)
- 트리거: `AppGate`에서 초기 분기 결정 시점
- 파라미터
  - `target_route` (string, required) - `/home` 또는 `/onboarding`
  - `has_selected_school` (bool, required)

### 6.3 `select_school`

- 목적: 학교 선택 완료율/진입경로 분석
- 트리거: 학교 선택 화면에서 "선택완료" 탭 후 확정 시점
- 파라미터
  - `school_id` (int, required) - `University.schoolId`
  - `entry_point` (string, required) - `onboarding` / `settings`
  - `is_first_select` (bool, required)

### 6.4 `change_school`

- 목적: 기존 사용자 학교 변경 빈도 분석
- 트리거: 기존 선택 학교가 있는 상태에서 다른 학교로 변경 확정 시점
- 파라미터
  - `previous_school_id` (int, required)
  - `new_school_id` (int, required)
  - `entry_point` (string, required) - 기본 `settings`

### 6.5 `view_meal`

- 목적: 식단 조회 패턴(날짜/오프셋) 분석
- 트리거: 식단 데이터 로딩 성공 후 화면 렌더 가능한 시점
- 파라미터
  - `school_id` (int, required)
  - `meal_date` (string, required) - `yyyy-MM-dd`
  - `date_offset` (int, required) - 오늘 기준 일수 차이 (`0`, `-1`, `+1`)
  - `meal_count` (int, optional) - 조회된 식단 개수

### 6.6 `meal_api_request`

- 목적: 날짜별 식단 API 요청량/실패율 분석
- 트리거: 식단 API 요청 직후
- 파라미터
  - `school_id` (int, required)
  - `meal_date` (string, required)
  - `request_type` (string, required) - `initial_load` / `user_pull_to_refresh` / `date_change`
  - `change_source` (string, optional) - `request_type=date_change`일 때만, `swipe` / `picker`
  - `result` (string, required) - `success` / `network_error` / `stale_data` / `unknown_error`

### 6.7 `widget_sync`

- 목적: 위젯 데이터 동기화 성공/실패 패턴 분석
- 트리거: 위젯 저장 작업 완료 시점
- 파라미터
  - `school_id` (int, optional) - 선택 학교가 있을 때만
  - `cafeteria_count` (int, optional)
  - `result` (string, required) - `success` / `failure` / `skipped_in_progress` / `skipped_debounce`

### 6.8 `school_list_load_result`

- 목적: 학교 목록 로딩 성능/실패가 선택 퍼널 이탈에 미치는 영향 분석
- 트리거: 학교 목록 초기 로딩 완료 시점
- 파라미터
  - `result` (string, required) - `success` / `failure`
  - `school_count` (int, optional) - `result=success`일 때만
  - `load_time_ms` (int, optional)
  - `screen_name` (string, required) - 기본 `select_school_screen`

### 6.9 `school_search_result_tap`

- 목적: 학교 검색 UX 품질(검색 결과 순위별 선택 패턴) 분석
- 트리거: 검색 결과 리스트에서 학교 항목 탭 시점
- 파라미터
  - `school_id` (int, required)
  - `result_rank` (int, required) - 검색 결과 내 1-based 순위
  - `entry_point` (string, required) - `onboarding` / `settings`
  - `screen_name` (string, required) - `select_school_screen`

### 6.10 `date_change`

- 목적: 오늘 외 날짜 탐색 수요와 탐색 패턴 분석
- 트리거: 날짜 변경 액션 이후 실제 `meal_date`가 이전과 달라진 경우에만 발화
- 파라미터
  - `school_id` (int, required)
  - `previous_date` (string, required) - 변경 전 날짜 `yyyy-MM-dd`
  - `meal_date` (string, required) - 변경 후 날짜 `yyyy-MM-dd`
  - `date_offset` (int, required) - 변경 후 날짜의 오늘 기준 일수 차이
  - `change_source` (string, required) - `swipe` / `picker`
  - `days_delta` (int, required) - `meal_date - previous_date` 일수 차이 (예: `-1`, `+1`)

### 6.11 `meal_empty_state_view`

- 목적: 식단 데이터 공백 노출 빈도 분석
- 트리거: 식단 화면에서 빈 상태 UI가 최초 노출되는 시점 (동일 `school_id + meal_date` 기준 1회)
- 파라미터
  - `school_id` (int, required)
  - `meal_date` (string, required)
  - `date_offset` (int, required)
  - `screen_name` (string, required) - `home_screen`

### 6.12 `meal_error_state_view`

- 목적: 사용자 체감 오류율(네트워크/기타) 분석
- 트리거: 식단 화면에서 에러 UI가 최초 노출되는 시점 (동일 `school_id + meal_date + error_type` 기준 1회)
- 파라미터
  - `school_id` (int, required)
  - `meal_date` (string, required)
  - `date_offset` (int, required)
  - `error_type` (string, required) - `network_error` / `unknown_error`

### 6.13 `meal_retry_tap`

- 목적: 오류 노출 이후 재시도 행동과 복구 의지 분석
- 트리거: 에러 상태에서 "다시 시도" 버튼 탭 시점
- 파라미터
  - `school_id` (int, required)
  - `meal_date` (string, required)
  - `previous_error_type` (string, required) - `network_error` / `unknown_error`
  - `screen_name` (string, required) - `home_screen`

## 7) 이벤트별 분석 질문

- `app_gate_decision`: 첫 진입 사용자가 온보딩으로 얼마나 이동하는가?
- `select_school`: 학교 선택 완료율은 얼마이며 어디서 이탈하는가?
- `change_school`: 학교 변경은 얼마나 자주 발생하는가?
- `view_meal`: 어떤 날짜/요일 조회가 많은가?
- `meal_api_request`: 실패가 특정 날짜/요청 유형에 집중되는가?
- `widget_sync`: 위젯 동기화 실패/스킵 비율은 어느 정도인가?
- `school_list_load_result`: 학교 목록 로딩 실패/지연이 선택 이탈에 영향을 주는가?
- `school_search_result_tap`: 검색 결과 상단 노출이 실제 선택으로 이어지는가?
- `date_change`: 사용자는 오늘 외 날짜를 얼마나 자주 탐색하는가?
- `meal_empty_state_view`: 특정 학교/날짜에서 빈 데이터 노출이 반복되는가?
- `meal_error_state_view`: 사용자 체감 에러가 어떤 유형으로 집중되는가?
- `meal_retry_tap`: 에러 이후 재시도 전환률은 어느 정도인가?

## 8) 구현 체크리스트

- [ ] `FirebaseAnalyticsObserver` 연결 및 `screen_view` 검증
- [ ] `AppGate` 분기 이벤트 추가 (`app_gate_decision`)
- [ ] 학교 선택/변경 이벤트 추가 (`select_school`, `change_school`)
- [ ] 식단 조회/요청 이벤트 추가 (`view_meal`, `meal_api_request`)
- [ ] 위젯 동기화 이벤트 추가 (`widget_sync`)
- [ ] 학교 목록/검색 상호작용 이벤트 추가 (`school_list_load_result`, `school_search_result_tap`)
- [ ] 날짜 변경 및 상태 노출 이벤트 추가 (`date_change`, `meal_empty_state_view`, `meal_error_state_view`, `meal_retry_tap`)
- [ ] DebugView에서 이벤트명/파라미터 유입 확인

## 9) 운영 메모

- 이벤트 스키마 변경 시 문서 버전을 올리고 변경 이력을 남긴다.
- 기존 파라미터 이름 변경 대신 신규 파라미터 추가를 우선 검토한다.
- 대시보드/쿼리는 본 문서의 이벤트명/파라미터명을 단일 소스로 사용한다.
