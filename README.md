# 밥묵자 (Bobmoo)

대학교 식단 정보를 확인할 수 있는 Flutter 기반 Android 앱입니다.

## 주요 기능

- 📅 **날짜별 식단 조회**: 원하는 날짜의 식단 정보를 확인할 수 있습니다
- 🍽️ **시간대별 메뉴**: 아침, 점심, 저녁으로 구분된 메뉴 정보
- 🏫 **다양한 식당**: 대학교 내 여러 식당의 메뉴를 한 번에 확인
- ⏰ **운영시간 표시**: 각 식당의 운영시간 정보 제공
- 📱 **위젯 지원**: 홈 화면에서 바로 식단 정보 확인 가능

## 기술 스택

- **Flutter** 3.9.2+
- **Dart** 3.9.2+
- **HTTP** API 통신
- **SharedPreferences** 로컬 데이터 저장
- **Home Widget** 위젯 기능

## 프로젝트 구조

```
lib/
├── main.dart                 # 앱 진입점
├── locator.dart              # 서비스 로케이터 (DI)
├── collections/              # Isar DB 컬렉션
│   ├── meal_collection.dart
│   ├── menu_cache_status.dart
│   └── restaurant_collection.dart
├── constants/                # 상수 및 테마
│   ├── app_colors.dart
│   └── app_constants.dart
├── models/                   # 데이터 모델
│   ├── menu_model.dart
│   ├── meal_by_cafeteria.dart
│   ├── meal_widget_data.dart
│   └── all_cafeterias_widget_data.dart
├── repositories/             # Repository 패턴
│   └── meal_repository.dart
├── screens/                  # 화면
│   ├── home_screen.dart
│   └── settings_screen.dart
├── services/                 # 서비스
│   ├── menu_service.dart
│   ├── background_service.dart
│   ├── permission_service.dart
│   └── widget_service.dart
├── utils/                    # 유틸리티
│   ├── hours_parser.dart
│   └── meal_utils.dart
└── widgets/                  # 재사용 가능한 위젯
    ├── cafeteria_menu_column.dart
    ├── meal_item_row.dart
    ├── open_status_badge.dart
    └── time_grouped_card.dart
```
