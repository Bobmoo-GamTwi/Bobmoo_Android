# ---- Keep Android entry points used by OS / widgets ----
-keep class com.hwoo.bobmoo.widget.receiver.BootReceiver { *; }
-keep class com.hwoo.bobmoo.widget.receiver.MealGlanceWidgetReceiver { *; }
-keep class com.hwoo.bobmoo.widget.receiver.AllCafeteriasGlanceWidgetReceiver { *; }
-keep class com.hwoo.bobmoo.widget.WidgetUpdateManager { *; }
-keep class com.hwoo.bobmoo.widget.RefreshWidgetAction { *; }

# ---- Strip verbose debug logs in release ----
-assumenosideeffects class android.util.Log {
    public static int v(...);
    public static int d(...);
}