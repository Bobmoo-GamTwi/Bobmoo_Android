package com.hwoo.bobmoo

import android.content.Context
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.glance.GlanceModifier
import androidx.glance.action.clickable
import androidx.glance.appwidget.cornerRadius
import androidx.glance.background
import androidx.glance.layout.*
import androidx.glance.text.FontWeight
import androidx.glance.text.Text
import androidx.glance.text.TextStyle
import es.antonborri.home_widget.actionStartActivity
import java.text.SimpleDateFormat
import java.util.*

@Composable
fun AllCafeteriasWidgetContent(context: Context, mealInfos: List<MealInfo>) {
    val sdf = SimpleDateFormat("M월 d일 EEEE HH:mm", Locale.KOREAN)
    val currentTimeString = sdf.format(Date())

    // "운영중"인 식당이 하나라도 있는지 확인하여 전체 상태를 결정
    val globalStatus =
        mealInfos.find { it.status == "운영중" }?.status ?: mealInfos.firstOrNull()?.status ?: ""
    val periodLabel = mealInfos.firstOrNull()?.periodLabel ?: "정보 없음"

    Column(
        modifier = GlanceModifier
            .fillMaxSize()
            .background(Color.White)
            .padding(16.dp)
            .clickable(onClick = actionStartActivity<MainActivity>(context)),
    ) {
        WidgetHeader(currentTime = currentTimeString)
        MealPeriodHeader(globalStatus = globalStatus, periodLabel = periodLabel)

        Row(
            modifier = GlanceModifier.fillMaxWidth().defaultWeight(),
            verticalAlignment = Alignment.Vertical.Top
        ) {
            // 각 식당 정보에 대해 루프를 돕니다.
            mealInfos.forEachIndexed { index, mealInfo ->
                Box(
                    modifier = GlanceModifier.defaultWeight().fillMaxHeight(),
                    contentAlignment = Alignment.TopStart
                ) {
                    CafeteriaColumn(mealInfo = mealInfo)
                }

                if (index < mealInfos.size - 1) {
                    // 컨텐츠 뒤에 항상 세로선을 추가합니다.
                    VerticalSeparator()
                }
            }
        }
    }
}

/**
 * 세로 구분선을 그리는 Composable 함수 (재사용을 위해 분리)
 */
@Composable
private fun VerticalSeparator() {
    Spacer(modifier = GlanceModifier.width(8.dp))
    Spacer(
        modifier = GlanceModifier.width(1.dp).height(100.dp)
            .background(Color(0xFFE0E0E0))
    )
    Spacer(modifier = GlanceModifier.width(8.dp))
}