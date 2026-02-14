package com.hwoo.bobmoo

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import androidx.core.content.getSystemService
import androidx.glance.appwidget.GlanceAppWidgetManager
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import java.util.Calendar

/**
 * 모든 위젯의 업데이트를 중앙에서 관리하는 BroadcastReceiver
 * 이렇게 하면 두 위젯이 동시에 업데이트되어 데이터 불일치 문제를 방지할 수 있습니다.
 */
class WidgetUpdateManager : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {
        android.util.Log.d("WidgetUpdate", "onReceive called: ${intent.action}")

        when (intent.action) {
            WIDGET_UPDATE_ACTION -> {
                // 두 위젯을 동시에 업데이트
                android.util.Log.d("WidgetUpdate", "Starting widget update")
                CoroutineScope(Dispatchers.Main).launch {
                    updateAllWidgets(context)
                }
                // 다음 업데이트 예약
                scheduleUpdate(context)
            }
        }
    }

    private suspend fun updateAllWidgets(context: Context) {
        android.util.Log.d("WidgetUpdate", "updateAllWidgets started")

        val glanceManager = GlanceAppWidgetManager(context)

        // MealGlanceWidget 업데이트
        val mealWidget = MealGlanceWidget()
        glanceManager.getGlanceIds(MealGlanceWidget::class.java).forEach { glanceId ->
            mealWidget.update(context, glanceId)
        }

        // AllCafeteriasGlanceWidget 업데이트
        val allCafeteriasWidget = AllCafeteriasGlanceWidget()
        glanceManager.getGlanceIds(AllCafeteriasGlanceWidget::class.java).forEach { glanceId ->
            allCafeteriasWidget.update(context, glanceId)
        }

        android.util.Log.d("WidgetUpdate", "updateAllWidgets completed")
    }

    companion object {
        private const val WIDGET_UPDATE_ACTION = "com.hwoo.bobmoo.action.WIDGET_UPDATE"
        private const val WIDGET_REQUEST_CODE = 1000

        fun scheduleUpdate(context: Context) {
            val alarmManager = context.getSystemService<AlarmManager>()
            if (alarmManager == null) {
                android.util.Log.w("WidgetUpdateManager", "AlarmManager not available.")
                return
            }

            val intent = Intent(context, WidgetUpdateManager::class.java).apply {
                action = WIDGET_UPDATE_ACTION
            }
            val pendingIntent = PendingIntent.getBroadcast(
                context,
                WIDGET_REQUEST_CODE,
                intent,
                PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
            )

            val nextMinute = Calendar.getInstance().apply {
                add(Calendar.MINUTE, 1)
                set(Calendar.SECOND, 0)
                set(Calendar.MILLISECOND, 0)
            }

            if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.S) {
                if (alarmManager.canScheduleExactAlarms()) {
                    alarmManager.setExactAndAllowWhileIdle(
                        AlarmManager.RTC_WAKEUP,
                        nextMinute.timeInMillis,
                        pendingIntent
                    )
                }
            } else {
                alarmManager.setExactAndAllowWhileIdle(
                    AlarmManager.RTC_WAKEUP,
                    nextMinute.timeInMillis,
                    pendingIntent
                )
            }
        }

        fun cancelUpdate(context: Context) {
            val alarmManager = context.getSystemService<AlarmManager>()
            val intent = Intent(context, WidgetUpdateManager::class.java).apply {
                action = WIDGET_UPDATE_ACTION
            }
            val pendingIntent = PendingIntent.getBroadcast(
                context,
                WIDGET_REQUEST_CODE,
                intent,
                PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_NO_CREATE
            )
            pendingIntent?.let { alarmManager?.cancel(it) }
        }
    }
}