// test/menu_model_test.dart
import 'dart:convert';
import 'package:bobmoo/models/menu_model.dart';
import 'package:flutter_test/flutter_test.dart';

// 테스트용 JSON 데이터 (위와 동일)
const String testJsonData = '''
{
    "date": "2025-09-16",
    "school": "인하대학교",
    "cafeterias": [
        {
            "name": "생활관식당",
            "hours": {
                "breakfast": "07:30-09:00",
                "lunch": "11:30-13:30",
                "dinner": "17:30-19:00"
            },
            "meals": {
                "lunch": [
                    {
                        "course": "A",
                        "mainMenu": "묵은지닭볶음, 꽈리고추멸치볶음",
                        "price": 5300
                    },
                    {
                        "course": "B",
                        "mainMenu": "유니짜장면, 치킨강정",
                        "price": 5300
                    }
                ],
                "breakfast": [
                    {
                        "course": "A",
                        "mainMenu": "두부함박스테이크, 어묵김치국, 맛살야채볶음",
                        "price": 5300
                    }
                ],
                "dinner": [
                    {
                        "course": "A",
                        "mainMenu": "왕소세지얹은 오므라이스, 멕시칸샐러드, 가쓰오우동국물",
                        "price": 5300
                    }
                ]
            }
        },
        {
            "name": "학생식당",
            "hours": {
                "breakfast": "08:00-09:00",
                "lunch": "11:00-14:00",
                "dinner": "17:00-18:30"
            },
            "meals": {
                "lunch": [
                    {
                        "course": "A",
                        "mainMenu": "새우튀김오므라이스, 미니떡볶이",
                        "price": 5500
                    },
                    {
                        "course": "B",
                        "mainMenu": "통등심돈까스 or 치킨까스, 미니와플",
                        "price": 6500
                    },
                    {
                        "course": "C",
                        "mainMenu": "아란치니토마토스파게티, 또띠아고르곤졸라",
                        "price": 5500
                    }
                ],
                "breakfast": [
                    {
                        "course": "A",
                        "mainMenu": "참치김치찌개, 동그랑땡",
                        "price": 1000
                    }
                ],
                "dinner": [
                    {
                        "course": "A",
                        "mainMenu": "닭곰탕, 쌀떡고기산적조림",
                        "price": 5500
                    }
                ]
            }
        },
        {
            "name": "교직원식당",
            "hours": {
                "breakfast": "08:20-09:20",
                "lunch": "11:20-13:30",
                "dinner": "17:00-18:00"
            },
            "meals": {
                "lunch": [
                    {
                        "course": "A",
                        "mainMenu": "돼지고기김치찌개, 고등어카레구이",
                        "price": 5500
                    },
                    {
                        "course": "B",
                        "mainMenu": "고구마치즈돈까스, SELF 메쉬드모닝빵샌드위치",
                        "price": 7500
                    }
                ],
                "breakfast": [
                    {
                        "course": "A",
                        "mainMenu": "동태무조림, 홍초콩나물국",
                        "price": 5000
                    }
                ],
                "dinner": [
                    {
                        "course": "A",
                        "mainMenu": "닭가슴살하이라이스, 새우커틀릿",
                        "price": 5000
                    }
                ]
            }
        }
    ]
}''';

void main() {
  // 여러 테스트를 그룹으로 묶어줍니다.
  group('MenuModel 파싱', () {
    // 첫 번째 테스트: JSON이 MenuResponse 객체로 잘 변환되는가?
    test('JSON 문자열로부터 MenuResponse 객체를 생성해야 한다', () {
      // 준비 & 실행
      final Map<String, dynamic> jsonMap = jsonDecode(testJsonData);
      final menuResponse = MenuResponse.fromJson(jsonMap);

      // 1. 타입이 MenuResponse인지 확인
      expect(menuResponse, isA<MenuResponse>());
      // 2. 최상위 데이터가 올바른지 확인
      expect(menuResponse.date, '2025-09-16');
      // 3. 리스트의 길이가 올바른지 확인
      expect(menuResponse.cafeterias.length, 3);
    });

    // 두 번째 테스트: 중첩된 데이터가 올바르게 파싱되는가?
    test('중첩된 Cafeteria 및 MealItem 데이터가 정확해야 한다', () {
      // 준비 & 실행
      final menuResponse = MenuResponse.fromJson(jsonDecode(testJsonData));

      // 검증
      final studentCafeteria = menuResponse.cafeterias[1];
      // 1. 식당 이름 확인
      expect(studentCafeteria.name, '학생식당');
      // 2. 운영 시간 확인
      expect(studentCafeteria.hours.dinner, '17:00-18:30');
      // 3. 가장 깊은 곳의 메뉴 가격 확인
      expect(studentCafeteria.meals.lunch[0].price, 5500);
    });
  });
}
