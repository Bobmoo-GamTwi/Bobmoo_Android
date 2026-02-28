package com.hwoo.bobmoo.widget.ui

import android.content.Context
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.glance.GlanceModifier
import androidx.glance.action.clickable
import androidx.glance.background
import androidx.glance.layout.Alignment
import androidx.glance.layout.Box
import androidx.glance.layout.Column
import androidx.glance.layout.Row
import androidx.glance.layout.Spacer
import androidx.glance.layout.fillMaxHeight
import androidx.glance.layout.fillMaxSize
import androidx.glance.layout.fillMaxWidth
import androidx.glance.layout.height
import androidx.glance.layout.padding
import androidx.glance.layout.width
import com.hwoo.bobmoo.MainActivity
import com.hwoo.bobmoo.widget.data.MealInfo
import es.antonborri.home_widget.actionStartActivity

@Composable
fun AllCafeteriasWidgetContent(context: Context, mealInfos: List<MealInfo>) {
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
        if (mealInfos.isEmpty() || mealInfos.all { it.isEmptyDraftState() }) {
            WidgetEmptyState()
        } else {
            WidgetDateText(
                dateLabel = mealInfos.firstOrNull()?.dateLabel ?: "",
                dateToken = "widget.sb12"
            )
            Spacer(modifier = GlanceModifier.height(6.dp))
            WidgetPeriodStatusRow(
                globalStatus = globalStatus,
                periodLabel = periodLabel,
                periodToken = "head.b21"
            )
            Spacer(modifier = GlanceModifier.height(10.dp))

            Row(
                modifier = GlanceModifier.fillMaxWidth().defaultWeight(),
                verticalAlignment = Alignment.Vertical.Top
            ) {
                mealInfos.forEachIndexed { index, mealInfo ->
                    Box(
                        modifier = GlanceModifier.defaultWeight().fillMaxHeight(),
                        contentAlignment = Alignment.TopStart
                    ) {
                        CafeteriaColumn(
                            mealInfo = mealInfo,
                            maxMenuLines = 1,
                            cafeteriaNameToken = "widget.sb14",
                            hourToken = "widget.m11",
                            menuToken = "widget.sb12"
                        )
                    }

                    if (index < mealInfos.size - 1) {
                        VerticalSeparator()
                    }
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
    Spacer(modifier = GlanceModifier.width(10.dp))
    Spacer(
        modifier = GlanceModifier.width(1.dp).height(88.dp)
            .background(Color(0xFFE0E0E0))
    )
    Spacer(modifier = GlanceModifier.width(10.dp))
}