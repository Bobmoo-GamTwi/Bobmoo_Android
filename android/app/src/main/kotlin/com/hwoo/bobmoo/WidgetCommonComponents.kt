package com.hwoo.bobmoo

import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.glance.GlanceModifier
import androidx.glance.appwidget.cornerRadius
import androidx.glance.background
import androidx.glance.layout.Alignment
import androidx.glance.layout.Box
import androidx.glance.layout.Column
import androidx.glance.layout.Row
import androidx.glance.layout.Spacer
import androidx.glance.layout.fillMaxHeight
import androidx.glance.layout.fillMaxWidth
import androidx.glance.layout.height
import androidx.glance.layout.padding
import androidx.glance.text.FontWeight
import androidx.glance.text.Text
import androidx.glance.text.TextStyle

/**
 * 최상단 헤더
 **/
@Composable
fun WidgetHeader(currentTime: String) {
    Row(
        modifier = GlanceModifier.fillMaxWidth(),
        verticalAlignment = Alignment.Vertical.CenterVertically
    ) {
        Text(
            text = currentTime,
            style = TextStyle(
                fontSize = 12.sp,
                color = androidx.glance.color.ColorProvider(Color.Gray, Color.Gray)
            )
        )
    }
}

/**
 * "아침", "점심" 등 시간대 헤더
 **/
@Composable
fun MealPeriodHeader(periodLabel: String, globalStatus: String) {
    // 상태별 색상을 정의하는 데이터 클래스
    data class StatusColors(val background: Color, val text: Color)

    // when을 사용하여 상태별 색상을 결정합니다.
    val statusColors = when (globalStatus) {
        "운영중" -> StatusColors(background = Color(0xFF4D89B2), text = Color.White) // 파란 계열
        "운영전" -> StatusColors(background = Color(0xFF4D89B2), text = Color.White) // 회색 계열
        "운영종료" -> StatusColors(background = Color(0xFFC95353), text = Color.White) // 빨간 계열
        else -> null // 상태 텍스트가 없으면 null 반환
    }

    // Row를 사용하여 시간대와 상태 배지를 가로로 배치합니다.
    Row(
        modifier = GlanceModifier.fillMaxWidth().padding(top = 8.dp),
        verticalAlignment = Alignment.Vertical.CenterVertically
    ) {
        // "아침", "점심" 등 시간대 텍스트
        Text(
            text = periodLabel,
            style = TextStyle(
                fontSize = 22.sp,
                fontWeight = FontWeight.Bold
            )
        )
        Spacer(modifier = GlanceModifier.defaultWeight())

        // 상태 배지 (Chip UI)
        // statusColors가 null이 아닐 때만 (상태 텍스트가 있을 때만) 배지를 표시합니다.
        if (statusColors != null) {
            Box(
                modifier = GlanceModifier
                    .background(statusColors.background)
                    .padding(horizontal = 8.dp, vertical = 4.dp)
                    .cornerRadius(8.dp),
                contentAlignment = Alignment.Center
            ) {
                Text(
                    text = globalStatus,
                    style = TextStyle(
                        color = androidx.glance.color.ColorProvider(
                            statusColors.text,
                            statusColors.text
                        ),
                        fontSize = 11.sp,
                        fontWeight = FontWeight.Bold
                    )
                )
            }
        }
    }
    Spacer(modifier = GlanceModifier.height(12.dp))
}


/**
 * 식당 정보 세로 칼럼
 * @param mealInfo 식당 정보
 * @param maxMenuLines 메뉴당 최대 줄 수 (null이면 자동 계산)
 */
@Composable
fun CafeteriaColumn(
    mealInfo: MealInfo,
    maxMenuLines: Int? = null
) {
    // 자동 계산 로직: 코스 개수에 따라 유연하게
    val calculatedMaxLines = maxMenuLines ?: when {
        mealInfo.courses.size <= 1 -> 3  // 1개: 3줄 (여유롭게)
        mealInfo.courses.size == 2 -> 2  // 2개: 2줄
        else -> 1                        // 3개+: 1줄 (컴팩트)
    }

    Column(
        modifier = GlanceModifier.fillMaxHeight(),
        horizontalAlignment = Alignment.Horizontal.Start
    ) {
        Text(
            text = mealInfo.cafeteriaName,
            style = TextStyle(fontSize = 14.sp, fontWeight = FontWeight.Bold),
            maxLines = 1
        )
        Spacer(modifier = GlanceModifier.height(2.dp))
        Text(
            text = "(${mealInfo.hoursLabel})",
            style = TextStyle(
                fontSize = 12.sp,
                color = androidx.glance.color.ColorProvider(Color.Gray, Color.Gray)
            ),
            maxLines = 1
        )
        Spacer(modifier = GlanceModifier.height(4.dp))
        // 메뉴 리스트
        mealInfo.courses.forEach { line ->
            Text(
                text = line,
                style = TextStyle(fontSize = 13.sp),
                modifier = GlanceModifier.padding(top = 2.dp),
                maxLines = calculatedMaxLines
            )
        }
    }
}
