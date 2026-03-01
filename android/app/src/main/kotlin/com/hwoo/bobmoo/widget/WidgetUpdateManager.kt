package com.hwoo.bobmoo.widget

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
        if (intent.action != WIDGET_UPDATE_ACTION) return

        // 두 위젯을 동시에 업데이트
        CoroutineScope(Dispatchers.Main).launch {
            updateAllWidgets(context)
        }
        // 다음 업데이트 예약
        scheduleUpdate(context)
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
        private const val REGULAR_INTERVAL_MINUTES = 30
        private const val SCHEDULE_WINDOW_MILLIS = 5 * 60 * 1000L
        private val MEAL_BOUNDARY_HOURS = intArrayOf(8, 12, 18)

        fun triggerImmediateUpdate(context: Context) {
            val intent = Intent(context, WidgetUpdateManager::class.java).apply {
                action = WIDGET_UPDATE_ACTION
            }
            context.sendBroadcast(intent)
        }

        fun scheduleUpdate(context: Context) {
            val alarmManager = context.getSystemService<AlarmManager>() ?: return

            val intent = Intent(context, WidgetUpdateManager::class.java).apply {
                action = WIDGET_UPDATE_ACTION
            }
            val pendingIntent = PendingIntent.getBroadcast(
                context,
                WIDGET_REQUEST_CODE,
                intent,
                PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
            )

            val now = Calendar.getInstance()
            val nextRegular = (now.clone() as Calendar).apply {
                add(Calendar.MINUTE, REGULAR_INTERVAL_MINUTES)
                set(Calendar.SECOND, 0)
                set(Calendar.MILLISECOND, 0)
            }
            val nextBoundary = calculateNextMealBoundary(now)
            val triggerAtMillis = minOf(nextRegular.timeInMillis, nextBoundary.timeInMillis)

            alarmManager.setWindow(
                AlarmManager.RTC_WAKEUP,
                triggerAtMillis,
                SCHEDULE_WINDOW_MILLIS,
                pendingIntent
            )
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

        private fun calculateNextMealBoundary(now: Calendar): Calendar {
            for (hour in MEAL_BOUNDARY_HOURS) {
                val boundary = (now.clone() as Calendar).apply {
                    set(Calendar.HOUR_OF_DAY, hour)
                    set(Calendar.MINUTE, 0)
                    set(Calendar.SECOND, 0)
                    set(Calendar.MILLISECOND, 0)
                }
                if (boundary.after(now)) {
                    return boundary
                }
            }

            return (now.clone() as Calendar).apply {
                add(Calendar.DAY_OF_YEAR, 1)
                set(Calendar.HOUR_OF_DAY, MEAL_BOUNDARY_HOURS.first())
                set(Calendar.MINUTE, 0)
                set(Calendar.SECOND, 0)
                set(Calendar.MILLISECOND, 0)
            }
        }
    }
}