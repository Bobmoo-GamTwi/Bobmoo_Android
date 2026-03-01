// workmanager에서 사용할 작업 관련 상수들
const String fetchMealDataTask = "fetchMealDataTask";
const String uniqueTaskName = "com.hwoo.bobmoo.fetchMealDataTask";

// HomeWidget Android receiver FQCN
const String mealWidgetReceiverClassName =
    "com.hwoo.bobmoo.widget.receiver.MealGlanceWidgetReceiver";
const String allCafeteriasWidgetReceiverClassName =
    "com.hwoo.bobmoo.widget.receiver.AllCafeteriasGlanceWidgetReceiver";

// Flutter <-> Android MethodChannel
const String widgetControlChannelName = "com.hwoo.bobmoo/widget_control";
const String refreshWidgetsNowMethod = "refreshWidgetsNow";
