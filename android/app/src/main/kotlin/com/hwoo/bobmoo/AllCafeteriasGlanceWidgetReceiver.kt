package com.hwoo.bobmoo

import android.content.Context
import androidx.glance.appwidget.GlanceAppWidgetReceiver

class AllCafeteriasGlanceWidgetReceiver : GlanceAppWidgetReceiver() {
    override val glanceAppWidget = AllCafeteriasGlanceWidget()

    override fun onEnabled(context: Context) {
        super.onEnabled(context)
        // 중앙 관리자에게 업데이트 시작 요청
        WidgetUpdateManager.scheduleUpdate(context)
    }

    override fun onDisabled(context: Context) {
        super.onDisabled(context)
        // 모든 위젯이 제거되었는지 확인
        if (!hasAnyWidgetEnabled(context)) {
            WidgetUpdateManager.cancelUpdate(context)
        }
    }

    private fun hasAnyWidgetEnabled(context: Context): Boolean {
        // MealGlanceWidget이 아직 활성화되어 있는지 확인
        val appWidgetManager = android.appwidget.AppWidgetManager.getInstance(context)
        val mealComponent = android.content.ComponentName(
            context,
            MealGlanceWidgetReceiver::class.java
        )
        return appWidgetManager.getAppWidgetIds(mealComponent).isNotEmpty()
    }
}