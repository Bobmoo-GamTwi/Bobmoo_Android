import 'package:bobmoo/core/exceptions/network_exceptions.dart';
import 'package:bobmoo/services/analytics_service.dart';
import 'package:intl/intl.dart';

class HomeAnalyticsHelper {
  MealApiRequestType _nextMealRequestType = MealApiRequestType.initialLoad;
  AnalyticsChangeSource? _nextMealChangeSource;
  String? _lastEmptyStateKey;
  final Set<String> _loggedErrorStateKeys = <String>{};

  void setMealRequestContext({
    required MealApiRequestType requestType,
    AnalyticsChangeSource? changeSource,
  }) {
    _nextMealRequestType = requestType;
    _nextMealChangeSource = changeSource;
  }

  ({MealApiRequestType requestType, AnalyticsChangeSource? changeSource})
  consumeMealRequestContext() {
    final requestType = _nextMealRequestType;
    final changeSource = _nextMealChangeSource;
    _nextMealRequestType = MealApiRequestType.initialLoad;
    _nextMealChangeSource = null;
    return (requestType: requestType, changeSource: changeSource);
  }

  String toDateKey(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

  int dateOffsetFromToday(DateTime date) {
    final today = DateTime.now();
    final onlyDate = DateTime(date.year, date.month, date.day);
    final onlyToday = DateTime(today.year, today.month, today.day);
    return onlyDate.difference(onlyToday).inDays;
  }

  void resetStateExposureGuards() {
    _lastEmptyStateKey = null;
    _loggedErrorStateKeys.clear();
  }

  AnalyticsErrorType errorTypeOf(Object error) {
    if (error is NetworkException) return AnalyticsErrorType.networkError;
    return AnalyticsErrorType.unknownError;
  }

  void logDateChangeIfNeeded({
    required int? schoolId,
    required DateTime previousDate,
    required DateTime nextDate,
    required AnalyticsChangeSource changeSource,
  }) {
    if (schoolId == null) return;
    if (_isSameDay(previousDate, nextDate)) return;

    AnalyticsService.instance.logDateChange(
      schoolId: schoolId,
      previousDate: toDateKey(previousDate),
      mealDate: toDateKey(nextDate),
      dateOffset: dateOffsetFromToday(nextDate),
      changeSource: changeSource,
      daysDelta: DateTime(nextDate.year, nextDate.month, nextDate.day)
          .difference(
            DateTime(previousDate.year, previousDate.month, previousDate.day),
          )
          .inDays,
    );
  }

  void logEmptyStateIfNeeded({
    required int? schoolId,
    required DateTime selectedDate,
  }) {
    if (schoolId == null) return;

    final mealDate = toDateKey(selectedDate);
    final contextKey = '$schoolId|$mealDate';
    if (_lastEmptyStateKey == contextKey) return;

    _lastEmptyStateKey = contextKey;
    AnalyticsService.instance.logMealEmptyStateView(
      schoolId: schoolId,
      mealDate: mealDate,
      dateOffset: dateOffsetFromToday(selectedDate),
    );
  }

  void logErrorStateIfNeeded({
    required int? schoolId,
    required DateTime selectedDate,
    required Object error,
  }) {
    if (schoolId == null) return;

    final mealDate = toDateKey(selectedDate);
    final errorType = errorTypeOf(error);
    final contextKey = '$schoolId|$mealDate|$errorType';
    if (_loggedErrorStateKeys.contains(contextKey)) return;

    _loggedErrorStateKeys.add(contextKey);
    AnalyticsService.instance.logMealErrorStateView(
      schoolId: schoolId,
      mealDate: mealDate,
      dateOffset: dateOffsetFromToday(selectedDate),
      errorType: errorType,
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
