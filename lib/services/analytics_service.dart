import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

class AnalyticsService {
  AnalyticsService._();

  static final AnalyticsService instance = AnalyticsService._();
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  void logAppGateDecision({
    required String targetRoute,
    required bool hasSelectedSchool,
  }) {
    _logEvent(
      name: 'app_gate_decision',
      parameters: {
        'target_route': targetRoute,
        'has_selected_school': hasSelectedSchool,
      },
    );
  }

  void logSchoolListLoadResult({
    required String result,
    int? schoolCount,
    int? loadTimeMs,
  }) {
    _logEvent(
      name: 'school_list_load_result',
      parameters: {
        'result': result,
        'school_count': schoolCount,
        'load_time_ms': loadTimeMs,
        'screen_name': 'select_school_screen',
      },
    );
  }

  void logSchoolSearchResultTap({
    required int schoolId,
    required int resultRank,
    required String entryPoint,
  }) {
    _logEvent(
      name: 'school_search_result_tap',
      parameters: {
        'school_id': schoolId,
        'result_rank': resultRank,
        'entry_point': entryPoint,
        'screen_name': 'select_school_screen',
      },
    );
  }

  void logSelectSchool({
    required int schoolId,
    required String entryPoint,
    required bool isFirstSelect,
  }) {
    _logEvent(
      name: 'select_school',
      parameters: {
        'school_id': schoolId,
        'entry_point': entryPoint,
        'is_first_select': isFirstSelect,
      },
    );
  }

  void logChangeSchool({
    required int previousSchoolId,
    required int newSchoolId,
    required String entryPoint,
  }) {
    _logEvent(
      name: 'change_school',
      parameters: {
        'previous_school_id': previousSchoolId,
        'new_school_id': newSchoolId,
        'entry_point': entryPoint,
      },
    );
  }

  void logDateChange({
    required int schoolId,
    required String previousDate,
    required String mealDate,
    required int dateOffset,
    required String changeSource,
    required int daysDelta,
  }) {
    _logEvent(
      name: 'date_change',
      parameters: {
        'school_id': schoolId,
        'previous_date': previousDate,
        'meal_date': mealDate,
        'date_offset': dateOffset,
        'change_source': changeSource,
        'days_delta': daysDelta,
      },
    );
  }

  void logMealApiRequest({
    required int schoolId,
    required String mealDate,
    required String requestType,
    String? changeSource,
    required String result,
  }) {
    _logEvent(
      name: 'meal_api_request',
      parameters: {
        'school_id': schoolId,
        'meal_date': mealDate,
        'request_type': requestType,
        'change_source': changeSource,
        'result': result,
      },
    );
  }

  void logViewMeal({
    required int schoolId,
    required String mealDate,
    required int dateOffset,
    int? mealCount,
  }) {
    _logEvent(
      name: 'view_meal',
      parameters: {
        'school_id': schoolId,
        'meal_date': mealDate,
        'date_offset': dateOffset,
        'meal_count': mealCount,
      },
    );
  }

  void logMealEmptyStateView({
    required int schoolId,
    required String mealDate,
    required int dateOffset,
  }) {
    _logEvent(
      name: 'meal_empty_state_view',
      parameters: {
        'school_id': schoolId,
        'meal_date': mealDate,
        'date_offset': dateOffset,
        'screen_name': 'home_screen',
      },
    );
  }

  void logMealErrorStateView({
    required int schoolId,
    required String mealDate,
    required int dateOffset,
    required String errorType,
  }) {
    _logEvent(
      name: 'meal_error_state_view',
      parameters: {
        'school_id': schoolId,
        'meal_date': mealDate,
        'date_offset': dateOffset,
        'error_type': errorType,
      },
    );
  }

  void logMealRetryTap({
    required int schoolId,
    required String mealDate,
    required String previousErrorType,
  }) {
    _logEvent(
      name: 'meal_retry_tap',
      parameters: {
        'school_id': schoolId,
        'meal_date': mealDate,
        'previous_error_type': previousErrorType,
        'screen_name': 'home_screen',
      },
    );
  }

  void logWidgetSync({
    int? schoolId,
    int? cafeteriaCount,
    required String result,
  }) {
    _logEvent(
      name: 'widget_sync',
      parameters: {
        'school_id': schoolId,
        'cafeteria_count': cafeteriaCount,
        'result': result,
      },
    );
  }

  void _logEvent({
    required String name,
    required Map<String, Object?> parameters,
  }) {
    final normalized = <String, Object>{};

    parameters.forEach((key, value) {
      if (value == null) return;

      if (value is String || value is int || value is double || value is bool) {
        normalized[key] = value;
        return;
      }

      normalized[key] = value.toString();
    });

    unawaited(_safeLogEvent(name: name, parameters: normalized));
  }

  Future<void> _safeLogEvent({
    required String name,
    required Map<String, Object> parameters,
  }) async {
    try {
      await _analytics.logEvent(name: name, parameters: parameters);
    } catch (error) {
      if (kDebugMode) {
        debugPrint('[Analytics] logEvent failed: $name, error: $error');
      }
    }
  }
}
