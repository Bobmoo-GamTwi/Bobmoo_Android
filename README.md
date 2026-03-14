# <p align="center"> 밥묵자 </p>
  
<p align="center">  
  <img width="120" height="120" alt="Group 17" src="https://github.com/user-attachments/assets/5ddb2665-ab6f-4519-87c3-3c215afaa193" />
</p>  

<p align="center">
  <b>대학교 급식 정보를 한눈에</b><br/>
  학교 설정부터 위젯까지, 대학교 학식 관리앱
</p>

<br>

## 🍚 Bobmoo 서비스 소개
> 어제, 오늘, 내일 급식을 한눈에! 원하는 학교의 학생식당·교직원식당·생활관식당 메뉴를 실시간으로 확인하고, 위젯으로 더욱 편리하게

<br>

## ✨ 주요 기능
- 🔍 **학교 검색 및 설정** - 원하는 대학교를 검색하고 선택
- 📅 **3일치 급식 조회** - 어제/오늘/내일 식단을 스와이프로 빠르게 확인
- 🏪 **다중 식당 지원** - 학생식당, 교직원식당, 생활관식당 정보 제공
- ⏰ **운영 시간 및 상태** - 실시간 운영 상태 표시 (운영중/종료임박/종료)
- 🍽️ **코스별 메뉴** - A/B/C 코스별 상세 메뉴 정보
- 📱 **홈 위젯** - 홈화면에서 바로 보는 오늘의 급식
- ⚙️ **위젯 식당 설정** - 위젯에 표시할 기본 식당 선택 가능

<br>

## 🍎 Android Developer
| 안현우<br/>[@hwoo7449](https://github.com/hwoo7449) |
| :---: |
| <p align="center"><img src="https://avatars.githubusercontent.com/u/37904408?v=4" width="200"/></p> |
| `홈` `검색` `설정` `위젯` |


<br>

## 🛠 Tech Stack

| 기술/도구 | 선정 이유 |
|---|---|
| Flutter (Material 3) | 단일 코드베이스로 빠르게 기능을 실험하고, 일관된 UI/UX를 안정적으로 제공하기 위해 선택 |
| Provider | 학내 선택, 검색, 화면 갱신 같은 상태 변화를 단순한 구조로 관리해 개발 생산성과 가독성 확보 |
| GetIt (DI) | `Service`-`Repository` 의존성을 분리해 구조를 명확히 하고, 기능 추가/교체 시 영향 범위를 최소화 |
| Repository Pattern | UI와 데이터 접근(API, 로컬 캐시)을 분리해 유지보수성을 높이고 확장 가능한 아키텍처 구축 |
| HTTP | 식단/학교 목록 API를 가볍고 명확하게 연동해 네트워크 레이어 복잡도를 낮춤 |
| Isar | 오프라인 캐시와 빠른 조회 성능을 확보해 네트워크 상태와 무관한 안정적인 식단 조회 경험 제공 |
| SharedPreferences | 선택 학교, 위젯 기본값 등 사용자 설정을 영속화해 재실행 시에도 끊김 없는 UX 제공 |
| Workmanager (Android) | 주기적 백그라운드 동기화로 앱을 열지 않아도 최신 식단 데이터를 유지 |
| HomeWidget + Android Glance | Flutter-Android 브릿지 기반 위젯 연동으로 홈 화면에서 즉시 식단 확인 가능 |
| In-App Update (Android) | 유연 업데이트 적용으로 사용자 이탈 없이 최신 기능/수정사항을 빠르게 배포 |
| Firebase Analytics | 조회/변경/오류/동기화 이벤트를 데이터로 추적해 기능 개선 의사결정을 정량화 |

<br>

## 📱 Screenshots
| 스플래시 | 온보딩 | 학교검색 |
|:---:|:---:|:---:|
| <img width="200" src="https://github.com/user-attachments/assets/1c688263-3320-4930-b727-a8189e3fe63e" /> | <img width="200" src="https://github.com/user-attachments/assets/980c9c93-13e6-4046-a997-6526c5c478b4" /> | <img width="200" src="https://github.com/user-attachments/assets/de4a04bc-2356-4d63-87a8-ec708663e7f2" /> |

| 홈 화면 | 설정 | 위젯 |
|:---:|:---:|:---:|
| <img width="200" src="https://github.com/user-attachments/assets/347f9e4a-1e75-451b-9c80-2b965e849942" /> | <img width="200" src="https://github.com/user-attachments/assets/d2479aeb-7060-48f6-9136-84cf0f152e06" /> | <img width="200" src="https://github.com/user-attachments/assets/15a2280b-6438-4958-b89e-b0a703ea1cd1" /> |

<br>

## 🌿 Git Flow 
1. Issue를 생성한다.
2. 현재 브랜치가 아닌 main 브랜치에서 Branch Naming Rule을 따르는 브랜치를 생성한다.
3. 이슈에 작성한 내용을 기반으로 기능을 구현한다. (+ 커밋)
4. add - commit - push - 간략한 PR 과정을 거친다.
5. PR 올린 후 코드 리뷰를 통해 merge 한다.
6. merge 이후에는 로컬에서도 main으로 이동하여 pull 받는다.

<br>

## 📝 Convention
### Commit Message
| 태그       | 설명                                                                 |
|------------|----------------------------------------------------------------------|
| `feat`     | 새로운 기능 구현 시 사용                                              |
| `fix`      | 버그나 오류 해결 시 사용                                              |
| `style`    | 스타일 및 UI 기능 구현 시 사용                                        |
| `docs`     | README, 템플릿 등 프로젝트 내 문서 수정 시 사용                        |
| `setting`  | 프로젝트 관련 설정 변경 시 사용                                       |
| `add`      | 사진 등 에셋이나 라이브러리 추가 시 사용                              |
| `refactor` | 기존 코드를 리팩토링하거나 수정할 때 사용                             |
| `chore`    | 별로 중요한 수정이 아닐 때 사용                                       |
| `hotfix`   | 급하게 develop에 바로 반영해야 하는 경우 사용                         |

### Commit Message Rule
1. 반드시 **소문자**로 작성합니다.
2. 한글로 작성합니다.
3. 제목이 **50자**를 넘지 않도록, 간단하게 명령조로 작성합니다.

```
feat: #1 홈 화면 구현

fix: #2 api 응답 파싱 오류 수정
```

## 📁 프로젝트 구조

> 갱신 명령어: `dart run tool/generate_readme_structure.dart`

<!-- GENERATED:LIB_TREE:START -->
```
🍚 bobmoo_android
└── 📁 lib
    ├── 📄 main.dart                            # 앱 진입점
    ├── 📄 locator.dart                         # DI(Service Locator) 설정
    ├── 📁 collections                          # Isar 컬렉션/스키마
    │   ├── 📄 meal_collection.dart
    │   ├── 📄 menu_cache_status.dart
    │   └── 📄 restaurant_collection.dart
    ├── 📁 constants                            # 앱 전역 상수
    │   └── 📄 app_constants.dart
    ├── 📁 models                               # 도메인/위젯 데이터 모델
    │   ├── 📄 all_cafeterias_widget_data.dart
    │   ├── 📄 meal_by_cafeteria.dart
    │   ├── 📄 meal_widget_data.dart
    │   ├── 📄 menu_model.dart
    │   └── 📄 university.dart
    ├── 📁 providers                            # 상태 관리(Provider)
    │   ├── 📄 search_provider.dart
    │   └── 📄 univ_provider.dart
    ├── 📁 repositories                         # 데이터 접근 계층
    │   └── 📄 meal_repository.dart
    ├── 📁 screens                              # 앱 화면 및 화면 보조 로직
    │   ├── 📄 app_gate.dart
    │   ├── 📄 home_analytics_helper.dart
    │   ├── 📄 home_screen.dart
    │   ├── 📄 home_widget_sync_helper.dart
    │   ├── 📄 loading_screen.dart
    │   ├── 📄 onboarding_screen.dart
    │   ├── 📄 select_school_screen.dart
    │   ├── 📄 settings_screen.dart
    │   └── 📄 splash_screen.dart
    ├── 📁 services                             # 외부 연동/백그라운드 서비스
    │   ├── 📄 analytics_service.dart
    │   ├── 📄 background_service.dart
    │   ├── 📄 menu_service.dart
    │   └── 📄 widget_service.dart
    ├── 📁 ui                                   # 공통 UI 레이어
    │   ├── 📁 components                       # 재사용 UI 컴포넌트
    │   │   ├── 📁 buttons
    │   │   │   └── 📄 primary_button.dart
    │   │   ├── 📁 cards
    │   │   │   ├── 📄 setting_section_card.dart
    │   │   │   └── 📄 time_grouped_card.dart
    │   │   └── 📁 meal
    │   │       ├── 📄 cafeteria_menu_column.dart
    │   │       ├── 📄 meal_item_row.dart
    │   │       └── 📄 open_status_badge.dart
    │   └── 📁 theme                            # 테마 시스템
    │       ├── 📄 app_colors.dart
    │       ├── 📄 app_shadow.dart
    │       └── 📄 app_typography.dart
    └── 📁 utils                                # 유틸리티
        ├── 📄 hours_parser.dart
        └── 📄 meal_utils.dart
```
<!-- GENERATED:LIB_TREE:END -->

<br>


## 🎨 UI/UX Highlights
- **직관적인 탭 네비게이션**: 어제/오늘/내일을 스와이프로 자연스럽게 이동
- **실시간 운영 상태**: 운영중(초록), 종료임박(노랑), 종료(회색)로 직관적 표시
- **풀다운 새로고침**: 당겨서 새로고침으로 최신 데이터 동기화
- **위젯 지원**: 홈화면에서 빠른 급식 확인


<br>

## 🔗 Links
- [Google Play Store](https://play.google.com/store/apps/details?id=com.hwoo.bobmoo) 

---
<p align="center">Made with 🍚 by <a href="https://github.com/hwoo7449">@hwoo7449</a></p>
