import 'package:bobmoo/constants/app_constants.dart';
import 'package:bobmoo/locator.dart';
import 'package:bobmoo/services/analytics_service.dart';
import 'package:bobmoo/services/widget_update_service.dart';
import 'package:firebase_core/firebase_core.dart';
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
        await WidgetUpdateService.updateWidget();
    }
    return Future.value(true);
  });
}
