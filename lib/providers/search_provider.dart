import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bobmoo/core/exceptions/network_exceptions.dart';
import 'package:bobmoo/models/university.dart';
import 'package:bobmoo/services/analytics_service.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class SearchProvider extends ChangeNotifier {
  List<University> _allItems = [];
  String _keyword = "";

  bool _isLoading = true;
  Object? _schoolListLoadError;

  final String _baseUrl = 'https://bobmoo.site/api/v1/schools';
  static const Duration _requestTimeout = Duration(seconds: 5);

  // 1. 앱 시작 시 딱 한 번 호출해서 상태를 복원합니다.
  Future<void> init() async {
    final stopwatch = Stopwatch()..start();
    _isLoading = true;
    _schoolListLoadError = null;
    notifyListeners();

    try {
      _allItems = await _loadUniversities();
      _schoolListLoadError = null;
      AnalyticsService.instance.logSchoolListLoadResult(
        result: SchoolListLoadResult.success,
        schoolCount: _allItems.length,
        loadTimeMs: stopwatch.elapsedMilliseconds,
      );
    } catch (error) {
      _schoolListLoadError = error;
      AnalyticsService.instance.logSchoolListLoadResult(
        result: SchoolListLoadResult.failure,
        loadTimeMs: stopwatch.elapsedMilliseconds,
      );
      _allItems = [];
    } finally {
      stopwatch.stop();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<University>> _loadUniversities() async {
    late final http.Response response;
    try {
      response = await http.get(Uri.parse(_baseUrl)).timeout(_requestTimeout);
    } on TimeoutException {
      throw const RequestTimeoutException();
    } on SocketException {
      throw const NoConnectivityException();
    }

    if (response.statusCode == 200) {
      // 성공하면, JSON 문자열을 Map<String, dynamic>으로 디코딩
      final decoded =
          jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      final List<dynamic> jsonSchoolList = decoded['data'] ?? [];

      return jsonSchoolList
          .map((json) => University.fromJson(json as Map<String, dynamic>))
          .toList();
    }

    throw HttpStatusException(response.statusCode);
  }

  void updateKeyword(String keyword) {
    if (_keyword == keyword) return;
    _keyword = keyword;
    notifyListeners();
  }

  bool get isLoading => _isLoading;
  Object? get schoolListLoadError => _schoolListLoadError;

  List<University> get filteredItems {
    // 키워드가 비어있다면 그대로 반환
    if (_keyword == "") return _allItems;

    final normalizedKeyword = _keyword.replaceAll(" ", "").toLowerCase();

    return _allItems.where((item) {
      final itemName = item.schoolNameK.replaceAll(" ", "").toLowerCase();

      return itemName.contains(normalizedKeyword);
    }).toList();
  }
}
