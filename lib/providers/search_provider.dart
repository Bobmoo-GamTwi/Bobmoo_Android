import 'dart:convert';

import 'package:bobmoo/models/university.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class SearchProvider extends ChangeNotifier {
  List<University> _allItems = [];
  String _keyword = "";

  bool _isLoading = true;

  final String _baseUrl = 'https://bobmoo.site/api/v1/schools';

  // 1. 앱 시작 시 딱 한 번 호출해서 상태를 복원합니다.
  Future<void> init() async {
    _allItems = await _loadUniversities();

    _isLoading = false;
    notifyListeners();
  }

  Future<List<University>> _loadUniversities() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      // 성공하면, JSON 문자열을 Map<String, dynamic>으로 디코딩
      final decoded =
          jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      final List<dynamic> jsonSchoolList = decoded['data'] ?? [];

      return jsonSchoolList
          .map((json) => University.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      // 실패하면 에러 발생
      throw Exception('Failed to load menu');
    }
  }

  void updateKeyword(String keyword) {
    _keyword = keyword;
    notifyListeners();
  }

  bool get isLoading => _isLoading;

  List<University> get filteredItems {
    // 키워드가 비어있다면 그대로 반환
    if (_keyword == "") return _allItems;

    final normalizedKeyword = _keyword.replaceAll(" ", "").toLowerCase();

    return _allItems.where((item) {
      final itemName = item.schoolName.replaceAll(" ", "").toLowerCase();

      return itemName.contains(normalizedKeyword);
    }).toList();
  }
}
