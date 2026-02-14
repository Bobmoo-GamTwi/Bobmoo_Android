import 'dart:convert';

import 'package:bobmoo/locator.dart';
import 'package:bobmoo/models/university.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UnivProvider extends ChangeNotifier {
  University? _selectedUniversity;
  bool _isInitialized = false;
  Color? _lastUnivColor; // 마지막으로 선택했던 대학의 Color

  // Getter
  University? get selectedUniversity => _selectedUniversity;
  bool get isInitialized => _isInitialized;

  // 1. 앱 시작 시 딱 한 번 호출해서 상태를 복원합니다.
  Future<void> init() async {
    final prefs = locator<SharedPreferences>();
    String? jsonString = prefs.getString('selectedUniv');

    if (jsonString != null) {
      _selectedUniversity = University.fromJson(jsonDecode(jsonString));
      _lastUnivColor = _selectedUniversity!.hexToColor();
    }

    _isInitialized = true;
    notifyListeners();
  }

  // 2. 대학이 선택되었을 때 호출합니다.
  Future<void> updateUniversity(University? univ) async {
    // 대학이 선택될 때마다 Color 저장 (null로 설정될 때도 이전 Color 유지)
    if (univ != null) {
      _lastUnivColor = univ.hexToColor();
    }

    _selectedUniversity = univ;

    // 로컬 저장소에도 저장
    final prefs = locator<SharedPreferences>();
    if (univ != null) {
      await prefs.setString('selectedUniv', jsonEncode(univ.toJson()));
    } else {
      await prefs.remove('selectedUniv');
    }

    notifyListeners();
  }

  University? get university => _selectedUniversity;

  Color get univColor =>
      university?.hexToColor() ?? _lastUnivColor ?? Colors.blue;
  String get univName => university?.name ?? "";
}
