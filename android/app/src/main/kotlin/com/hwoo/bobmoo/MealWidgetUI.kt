package com.hwoo.bobmoo

import android.content.Context
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.glance.GlanceModifier
import androidx.glance.action.clickable
import androidx.glance.background
import androidx.glance.layout.Column
import androidx.glance.layout.fillMaxSize
import androidx.glance.layout.padding
import es.antonborri.home_widget.actionStartActivity
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

@Composable
fun MealWidgetContent(context: Context, mealInfo: MealInfo) {
    val sdf = SimpleDateFormat("M월 d일 EEEE HH:mm", Locale.KOREAN)
    val currentTimeString = sdf.format(Date())

    Column(
        modifier = GlanceModifier
            .fillMaxSize()
            .background(Color.White)
            .padding(16.dp) // 동일한 전체 패딩 적용
            .clickable(onClick = actionStartActivity<MainActivity>(context)),
    ) {
        // 1. 공통 헤더 재사용
        WidgetHeader(currentTime = currentTimeString)

        // 2. 공통 시간대 헤더 재사용
        MealPeriodHeader(globalStatus = mealInfo.status, periodLabel = mealInfo.periodLabel)

        // 3. 공통 식당 정보 칼럼 재사용
        CafeteriaColumn(mealInfo = mealInfo)
    }
}