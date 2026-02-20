import 'dart:convert';

import 'package:bobmoo/models/university.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class SearchProvider extends ChangeNotifier {
  List<University> _allItems = [];
  String _keyword = "";

  bool _isLoading = true;

  // 1. 앱 시작 시 딱 한 번 호출해서 상태를 복원합니다.
  Future<void> init() async {
    _allItems = await _loadUniversities();

    _isLoading = false;
    notifyListeners();
  }

  Future<List<University>> _loadUniversities() async {
    // universities.json 파일에서 대학목록을 불러옵니다.
    // TODO: 나중에 학교 리스트 받는 API 구축하고 그 Repository를 "생성자"에서 받게끔
    final String jsonString = await rootBundle.loadString(
      'assets/data/universities.json',
    );
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => University.fromJson(json)).toList();
  }

  void updateKeyword(String keyword) async {
    _keyword = keyword;
    notifyListeners();
  }

  bool get isLoading => _isLoading;

  List<University> get filteredItems {
    // 키워드가 비어있다면 그대로 반환
    if (_keyword == "") return _allItems;

    return _allItems.where((item) {
      final itemName = item.name.replaceAll(" ", "").toLowerCase();
      final keyword = _keyword.replaceAll(" ", "").toLowerCase();

      return itemName.contains(keyword);
    }).toList();
  }
}
