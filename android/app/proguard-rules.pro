# ---- Keep Android entry points used by OS / widgets ----
-keep class com.hwoo.bobmoo.BootReceiver { *; }
-keep class com.hwoo.bobmoo.MealGlanceWidgetReceiver { *; }
-keep class com.hwoo.bobmoo.AllCafeteriasGlanceWidgetReceiver { *; }
-keep class com.hwoo.bobmoo.WidgetUpdateManager { *; }

# ---- Strip verbose debug logs in release ----
-assumenosideeffects class android.util.Log {
    public static int v(...);
    public static int d(...);
}