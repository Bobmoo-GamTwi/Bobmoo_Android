package com.hwoo.bobmoo.widget.ui

import android.content.Context
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.glance.GlanceModifier
import androidx.glance.action.clickable
import androidx.glance.background
import androidx.glance.layout.Column
import androidx.glance.layout.Row
import androidx.glance.layout.Spacer
import androidx.glance.layout.fillMaxSize
import androidx.glance.layout.fillMaxWidth
import androidx.glance.layout.height
import androidx.glance.layout.padding
import androidx.glance.layout.width
import com.hwoo.bobmoo.MainActivity
import com.hwoo.bobmoo.widget.data.MealInfo
import com.hwoo.bobmoo.widget.theme.WidgetTypography
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
            )
            Spacer(modifier = GlanceModifier.height(6.dp))
            Row {
                CafeteriaNameText(mealInfo.cafeteriaName)
                Spacer(modifier = GlanceModifier.width(5.dp))
                WidgetHoursText(hoursLabel = mealInfo.hoursLabel, hourToken = WidgetTypography.HOURS)
            }
            Spacer(modifier = GlanceModifier.height(10.dp))
            CourseList(
                courses = mealInfo.courses,
                maxMenuLines = 1,
            )
            Spacer(modifier = GlanceModifier.height(8.dp))
            Row(modifier = GlanceModifier.fillMaxWidth()) {
                Spacer(modifier = GlanceModifier.defaultWeight())
                WidgetStatusBadge(mealInfo.status)
            }
        }
    }
}