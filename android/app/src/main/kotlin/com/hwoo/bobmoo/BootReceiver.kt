package com.hwoo.bobmoo

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.appwidget.AppWidgetManager
import android.content.ComponentName

class BootReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        when (intent.action) {
            Intent.ACTION_BOOT_COMPLETED,
            Intent.ACTION_MY_PACKAGE_REPLACED -> {
                // 위젯이 하나라도 있는지 확인
                if (hasAnyWidget(context)) {
                    // AlarmManager 재등록
                    WidgetUpdateManager.scheduleUpdate(context)
                    android.util.Log.d("BootReceiver", "AlarmManager re-registered")
                }
            }
        }
    }

    private fun hasAnyWidget(context: Context): Boolean {
        val appWidgetManager = AppWidgetManager.getInstance(context)

        val mealWidget = ComponentName(context, MealGlanceWidgetReceiver::class.java)
        val allCafeteriasWidget =
            ComponentName(context, AllCafeteriasGlanceWidgetReceiver::class.java)

        return appWidgetManager.getAppWidgetIds(mealWidget).isNotEmpty() ||
                appWidgetManager.getAppWidgetIds(allCafeteriasWidget).isNotEmpty()
    }
}