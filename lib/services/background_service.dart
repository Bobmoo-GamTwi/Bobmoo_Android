import 'package:bobmoo/constants/app_constants.dart';
import 'package:bobmoo/locator.dart';
import 'package:bobmoo/repositories/meal_repository.dart';
import 'package:bobmoo/screens/home_widget_sync_helper.dart';
import 'package:bobmoo/services/analytics_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:workmanager/workmanager.dart';

// WorkManager가 호출할 최상위 함수. @pragma 어노테이션은 Dart 컴파일러에게 이 함수가 코드상에서
// 직접 호출되지 않더라도 제거하지 말라고 알려주는 역할을 합니다.
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await Firebase.initializeApp();
    await AnalyticsService.instance.initialize();

    // Locator (GetIt)를 초기화합니다. 백그라운드 isolate는 앱의 메인 isolate와
    // 메모리를 공유하지 않으므로, 사용하는 서비스들을 다시 초기화해야 합니다.
    await setupLocator();

    // 등록된 작업 이름에 따라 분기 처리합니다.
    switch (task) {
      case fetchMealDataTask:
        try {
          // home_screen.dart에 있던 위젯 업데이트 로직을 그대로 사용합니다.
          final repository = locator<MealRepository>();
          final syncHelper = HomeWidgetSyncHelper(repository: repository);
          final today = DateTime.now();
          final todayMeals = await repository.getMealsForDate(today);

          if (todayMeals.isEmpty) {
            AnalyticsService.instance.logWidgetSync(
              cafeteriaCount: 0,
              triggerSource: AnalyticsTriggerSource.backgroundWorkmanager,
              result: WidgetSyncResult.success,
            );
            if (kDebugMode) {
              debugPrint(
                '[BackgroundService] No meals for today. Skipping widget update.',
              );
            }

            return Future.value(true); // 데이터가 없으면 성공으로 처리
          }

          final cafeteriaCount = await syncHelper.syncWidgetData(
            todayMeals: todayMeals,
          );
          AnalyticsService.instance.logWidgetSync(
            cafeteriaCount: cafeteriaCount,
            triggerSource: AnalyticsTriggerSource.backgroundWorkmanager,
            result: WidgetSyncResult.success,
          );

          if (kDebugMode) {
            debugPrint('[BackgroundService] Successfully updated widget data.');
          }
          return Future.value(true); // 성공
        } catch (e) {
          AnalyticsService.instance.logWidgetSync(
            triggerSource: AnalyticsTriggerSource.backgroundWorkmanager,
            result: WidgetSyncResult.failure,
          );
          if (kDebugMode) {
            debugPrint('[BackgroundService] Error executing task: $e');
          }
          return Future.value(false); // 실패
        }
    }
    return Future.value(true);
  });
}
