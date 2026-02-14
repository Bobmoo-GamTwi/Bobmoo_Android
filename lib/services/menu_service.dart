import 'dart:convert';
import 'package:bobmoo/models/menu_model.dart';
import 'package:http/http.dart' as http;

class MenuService {
  // API의 기본 URL
  final String _baseUrl = 'https://bobmoo.site/api/v1/menu';

  // 날짜를 인자로 받아 해당 날짜의 메뉴를 가져오는 함수
  Future<MenuResponse> getMenu(DateTime date) async {
    // 날짜를 'yyyy-MM-dd' 형식의 문자열로 변환
    String formattedDate =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

    final response = await http.get(Uri.parse('$_baseUrl?date=$formattedDate'));

    if (response.statusCode == 200) {
      // 성공하면, JSON 문자열을 Map<String, dynamic>으로 디코딩
      final Map<String, dynamic> jsonResponse = jsonDecode(
        utf8.decode(response.bodyBytes),
      );
      // Map을 MenuResponse 객체로 변환하여 반환 (이 변환 로직은 모델 클래스에 만드는 것이 좋음)
      return MenuResponse.fromJson(jsonResponse);
    } else {
      // 실패하면 에러 발생
      throw Exception('Failed to load menu');
    }
  }
}
