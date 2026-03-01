import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

enum AppGateDestinationRoute {
  home('/home'),
  onboarding('/onboarding');

  const AppGateDestinationRoute(this.value);
  final String value;
}

enum AnalyticsEntryPoint {
  onboarding('onboarding'),
  settings('settings');

  const AnalyticsEntryPoint(this.value);
  final String value;
}

enum SchoolListLoadResult {
  success('success'),
  failure('failure');

  const SchoolListLoadResult(this.value);
  final String value;
}

enum AnalyticsChangeSource {
  swipe('swipe'),
  picker('picker');

  const AnalyticsChangeSource(this.value);
  final String value;
}

enum MealApiRequestType {
  initialLoad('initial_load'),
  retry('retry'),
  userPullToRefresh('user_pull_to_refresh'),
  dateChange('date_change');

  const MealApiRequestType(this.value);
  final String value;
}

enum MealApiResult {
  success('success'),
  networkError('network_error'),
  staleData('stale_data'),
  unknownError('unknown_error');

  const MealApiResult(this.value);
  final String value;
}

enum AnalyticsDataSource {
  dbHit('db_hit'),
  apiFetched('api_fetched'),
  dbStaleFallback('db_stale_fallback');

  const AnalyticsDataSource(this.value);
  final String value;
}

enum AnalyticsTriggerSource {
  foreground('foreground'),
  backgroundWorkmanager('background_workmanager');

  const AnalyticsTriggerSource(this.value);
  final String value;
}

enum AnalyticsErrorType {
  networkError('network_error'),
  unknownError('unknown_error');

  const AnalyticsErrorType(this.value);
  final String value;
}

enum WidgetSyncResult {
  success('success'),
  failure('failure'),
  skippedInProgress('skipped_in_progress'),
  skippedDebounce('skipped_debounce');

  const WidgetSyncResult(this.value);
  final String value;
}

class AnalyticsService {
  AnalyticsService._();

  static final AnalyticsService instance = AnalyticsService._();
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  bool _isInitialized = false;

  String get environment {
    switch (appFlavor) {
      case 'prod':
        return 'prod';
      case 'staging':
        return 'staging';
      case 'dev':
        return 'dev';
      default:
        return kReleaseMode ? 'prod' : 'dev';
    }
  }

  Future<void> initialize() async {
    if (_isInitialized) return;
    _isInitialized = true;

    try {
      await _analytics.setDefaultEventParameters({
        'env': environment,
      });
      await _analytics.setUserProperty(
        name: 'env',
        value: environment,
      );
    } catch (error) {
      if (kDebugMode) {
        debugPrint('[Analytics] initialize failed: $error');
      }
    }
  }

  void logAppGateDecision({
    required AppGateDestinationRoute destinationRoute,
    required bool hasSelectedSchool,
  }) {
    _logEvent(
      name: 'app_gate_decision',
      parameters: {
        'destination_route': destinationRoute.value,
        'has_selected_school': hasSelectedSchool,
      },
    );
  }

  void logSchoolListLoadResult({
    required SchoolListLoadResult result,
    int? schoolCount,
    int? loadTimeMs,
  }) {
    _logEvent(
      name: 'school_list_load_result',
      parameters: {
        'result': result.value,
        'school_count': schoolCount,
        'load_time_ms': loadTimeMs,
        'screen_name': 'select_school_screen',
      },
    );
  }

  void logSchoolSearchResultTap({
    required int schoolId,
    required int resultRank,
    required AnalyticsEntryPoint entryPoint,
  }) {
    _logEvent(
      name: 'school_search_result_tap',
      parameters: {
        'school_id': schoolId,
        'result_rank': resultRank,
        'entry_point': entryPoint.value,
        'screen_name': 'select_school_screen',
      },
    );
  }

  void logSelectSchool({
    required int schoolId,
    required AnalyticsEntryPoint entryPoint,
    required bool isFirstSelect,
  }) {
    _logEvent(
      name: 'select_school',
      parameters: {
        'school_id': schoolId,
        'entry_point': entryPoint.value,
        'is_first_select': isFirstSelect,
      },
    );
  }

  void logChangeSchool({
    required int previousSchoolId,
    required int newSchoolId,
    required AnalyticsEntryPoint entryPoint,
  }) {
    _logEvent(
      name: 'change_school',
      parameters: {
        'previous_school_id': previousSchoolId,
        'new_school_id': newSchoolId,
        'entry_point': entryPoint.value,
      },
    );
  }

  void logDateChange({
    required int schoolId,
    required String previousDate,
    required String mealDate,
    required int dateOffset,
    required AnalyticsChangeSource changeSource,
    required int daysDelta,
  }) {
    _logEvent(
      name: 'date_change',
      parameters: {
        'school_id': schoolId,
        'previous_date': previousDate,
        'meal_date': mealDate,
        'date_offset': dateOffset,
        'change_source': changeSource.value,
        'days_delta': daysDelta,
      },
    );
  }

  void logMealApiRequest({
    required int schoolId,
    required String mealDate,
    required MealApiRequestType requestType,
    AnalyticsChangeSource? changeSource,
    AnalyticsDataSource? dataSource,
    required AnalyticsTriggerSource triggerSource,
    required MealApiResult result,
  }) {
    _logEvent(
      name: 'meal_api_request',
      parameters: {
        'school_id': schoolId,
        'meal_date': mealDate,
        'request_type': requestType.value,
        'change_source': changeSource?.value,
        'data_source': dataSource?.value,
        'trigger_source': triggerSource.value,
        'result': result.value,
      },
    );
  }

  void logViewMeal({
    required int schoolId,
    required String mealDate,
    required int dateOffset,
    AnalyticsDataSource? dataSource,
    int? mealCount,
  }) {
    _logEvent(
      name: 'view_meal',
      parameters: {
        'school_id': schoolId,
        'meal_date': mealDate,
        'date_offset': dateOffset,
        'data_source': dataSource?.value,
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
    required AnalyticsErrorType errorType,
  }) {
    _logEvent(
      name: 'meal_error_state_view',
      parameters: {
        'school_id': schoolId,
        'meal_date': mealDate,
        'date_offset': dateOffset,
        'error_type': errorType.value,
      },
    );
  }

  void logMealRetryTap({
    required int schoolId,
    required String mealDate,
    required AnalyticsErrorType previousErrorType,
  }) {
    _logEvent(
      name: 'meal_retry_tap',
      parameters: {
        'school_id': schoolId,
        'meal_date': mealDate,
        'previous_error_type': previousErrorType.value,
        'screen_name': 'home_screen',
      },
    );
  }

  void logWidgetSync({
    int? schoolId,
    int? cafeteriaCount,
    required AnalyticsTriggerSource triggerSource,
    required WidgetSyncResult result,
  }) {
    _logEvent(
      name: 'widget_sync',
      parameters: {
        'school_id': schoolId,
        'cafeteria_count': cafeteriaCount,
        'trigger_source': triggerSource.value,
        'result': result.value,
      },
    );
  }

  void logWidgetDefaultCafeteriaChange({
    int? schoolId,
    String? previousCafeteria,
    required String newCafeteria,
  }) {
    _logEvent(
      name: 'widget_default_cafeteria_change',
      parameters: {
        'school_id': schoolId,
        'previous_cafeteria': previousCafeteria,
        'new_cafeteria': newCafeteria,
        'screen_name': 'settings_screen',
      },
    );
  }

  Future<void> setSelectedSchoolUserProperty(int? schoolId) async {
    try {
      await _analytics.setUserProperty(
        name: 'selected_school_id',
        value: schoolId?.toString(),
      );
    } catch (error) {
      if (kDebugMode) {
        debugPrint('[Analytics] setUserProperty failed: $error');
      }
    }
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
