import 'dart:convert';

import 'package:bobmoo/locator.dart';
import 'package:bobmoo/models/university.dart';
import 'package:bobmoo/services/analytics_service.dart';
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
      try {
        final json = jsonDecode(jsonString) as Map<String, dynamic>?;
        if (json != null &&
            json['schoolId'] != null &&
            json['schoolName'] != null &&
            json['schoolNameK'] != null &&
            json['schoolColor'] != null) {
          _selectedUniversity = University.fromJson(json);
          _lastUnivColor = _selectedUniversity!.hexToColor();
        }
        // 필수 데이터 없으면 그냥 null 유지 → 학교 선택 화면으로 감
      } catch (e) {
        await prefs.remove('selectedUniv'); // 깨진 데이터 삭제
      }
    }

    await AnalyticsService.instance.setSelectedSchoolUserProperty(
      _selectedUniversity?.schoolId,
    );

    _isInitialized = true;
    notifyListeners();
  }

  // 2. 대학이 선택되었을 때 호출합니다.
  Future<void> updateUniversity(University? univ) async {
    // 대학이 선택될 때마다 Color 저장 (null로 설정될 때도 이전 Color 유지)
    if (univ != null) {
      _lastUnivColor = univ.hexToColor();
    }

    // 선택한 학교가 이전에 선택한 학교와 같다면? (변경 안함)
    if (_selectedUniversity == univ) {
      // 아무런 변화 없음
      return;
    }

    final isar = locator<Isar>();

    // 학교가 변경되면 기존의 모든 이전 학교의 식단 및 캐시 삭제
    await isar.writeTxn(() async {
      await isar.meals.clear();
      await isar.menuCacheStatuses.clear();
    });

    _selectedUniversity = univ;

    // 로컬 저장소에도 저장
    final prefs = locator<SharedPreferences>();
    if (univ != null) {
      await prefs.setString('selectedUniv', jsonEncode(univ.toJson()));
    } else {
      await prefs.remove('selectedUniv');
    }

    await AnalyticsService.instance.setSelectedSchoolUserProperty(
      _selectedUniversity?.schoolId,
    );

    notifyListeners();
  }

  University? get university => _selectedUniversity;

  Color get univColor =>
      university?.hexToColor() ?? _lastUnivColor ?? Colors.blue;
  String get univName => university?.schoolNameK ?? "";
}
