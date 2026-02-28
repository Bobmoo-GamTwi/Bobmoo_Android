package com.hwoo.bobmoo.widget.ui

import android.content.Context
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.glance.GlanceModifier
import androidx.glance.action.clickable
import androidx.glance.background
import androidx.glance.layout.Column
import androidx.glance.layout.Spacer
import androidx.glance.layout.fillMaxSize
import androidx.glance.layout.height
import androidx.glance.layout.padding
import com.hwoo.bobmoo.MainActivity
import com.hwoo.bobmoo.widget.data.MealInfo
import es.antonborri.home_widget.actionStartActivity

@Composable
fun MealWidgetContent(context: Context, mealInfo: MealInfo) {
    Column(
        modifier = GlanceModifier
            .fillMaxSize()
            .background(Color.White)
            .padding(16.dp)
            .clickable(onClick = actionStartActivity<MainActivity>(context)),
    ) {
        if (mealInfo.isEmptyDraftState()) {
            WidgetEmptyState()
        } else {
            WidgetDateText(
                dateLabel = mealInfo.dateLabel,
                dateToken = "widget.sb12"
            )
            Spacer(modifier = GlanceModifier.height(6.dp))
            WidgetPeriodStatusRow(
                globalStatus = mealInfo.status,
                periodLabel = mealInfo.periodLabel,
                periodToken = "head.b30"
            )
            Spacer(modifier = GlanceModifier.height(2.dp))
            WidgetHoursText(hoursLabel = mealInfo.hoursLabel, hourToken = "widget.sb12")
            Spacer(modifier = GlanceModifier.height(10.dp))
            CafeteriaColumn(
                mealInfo = mealInfo,
                maxMenuLines = 2,
                cafeteriaNameToken = "widget.sb14",
                hourToken = "widget.sb12",
                menuToken = "widget.sb12",
                showHours = false
            )
        }
    }
}