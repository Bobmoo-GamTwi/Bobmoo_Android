package com.hwoo.bobmoo.widget.ui

import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.glance.GlanceModifier
import androidx.glance.Image
import androidx.glance.ImageProvider
import androidx.glance.appwidget.cornerRadius
import androidx.glance.background
import androidx.glance.color.ColorProvider
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
import androidx.glance.text.Text
import com.hwoo.bobmoo.R
import com.hwoo.bobmoo.widget.data.MealInfo
import com.hwoo.bobmoo.widget.theme.TypographyTokens

private data class StatusColors(val background: Color, val text: Color)

/** 날짜 표시용 텍스트 */
@Composable
fun WidgetDateText(
    dateLabel: String,
    dateToken: String = "widget.sb7"
) {
    if (dateLabel.isBlank()) return
    Text(
        text = dateLabel,
        style = TypographyTokens.textStyle(
            key = dateToken,
            color = ColorProvider(Color(0xFF61656F), Color(0xFF61656F))
        ),
        maxLines = 1
    )
}

/** 시간대 라벨 표시용 텍스트 */
@Composable
fun WidgetPeriodText(
    periodLabel: String,
    periodToken: String = "widget.sb14"
) {
    Text(
        text = periodLabel,
        style = TypographyTokens.textStyle(key = periodToken),
        maxLines = 1
    )
}

/** 식당이름 표시용 텍스트 */
@Composable
fun cafeteriaNameText(
    cafeteriaName: String,
    periodToken: String = "widget.sb12"
) {
    Text(
        text = cafeteriaName,
        style = TypographyTokens.textStyle(key = periodToken),
        maxLines = 1
    )
}

/** 식당 시간 표시용 텍스트 */
@Composable
fun WidgetHoursText(
    hoursLabel: String,
    hourToken: String = "widget.sb7"
) {
    if (hoursLabel.isBlank()) return
    Text(
        text = "($hoursLabel)",
        style = TypographyTokens.textStyle(
            key = hourToken,
            color = ColorProvider(Color(0xFF61656F), Color(0xFF61656F))
        ),
        maxLines = 1
    )
}

/** 상태에 따른 운영배지 색상 반환하는 함수 */
private fun statusColors(globalStatus: String): StatusColors? {
    return when (globalStatus) {
        "운영전" -> StatusColors(background = Color(0xFF61656F), text = Color.White)
        "운영중" -> StatusColors(background = Color(0xFF0064FB), text = Color.White)
        "운영종료" -> StatusColors(background = Color(0xFFFF2200), text = Color.White)
        else -> null
    }
}

/** 운영배지 */
@Composable
fun WidgetStatusBadge(globalStatus: String) {
    val statusColors = statusColors(globalStatus) ?: return
    Box(
        modifier = GlanceModifier
            .background(statusColors.background)
            .padding(horizontal = 10.dp, vertical = 5.dp)
            .cornerRadius(12.dp),
        contentAlignment = Alignment.Center
    ) {
        Text(
            text = globalStatus,
            style = TypographyTokens.textStyle(
                key = "button.sb12",
                color = ColorProvider(statusColors.text, statusColors.text)
            )
        )
    }
}

@Composable
fun WidgetPeriodStatusRow(
    periodLabel: String,
    globalStatus: String,
    periodToken: String = "head.b21",
    topPadding: Int = 0
) {
    Row(
        modifier = GlanceModifier.fillMaxWidth().padding(top = topPadding.dp),
        verticalAlignment = Alignment.Vertical.CenterVertically
    ) {
        WidgetPeriodText(periodLabel = periodLabel, periodToken = periodToken)
        Spacer(modifier = GlanceModifier.defaultWeight())
        WidgetStatusBadge(globalStatus = globalStatus)
    }
}

@Composable
fun MealPeriodHeader(
    periodLabel: String,
    globalStatus: String,
    periodToken: String = "head.b21",
    topPadding: Int = 0
) {
    WidgetPeriodStatusRow(
        periodLabel = periodLabel,
        globalStatus = globalStatus,
        periodToken = periodToken,
        topPadding = topPadding
    )
    Spacer(modifier = GlanceModifier.height(10.dp))
}


/**
 * 식당 정보 세로 칼럼
 * @param mealInfo 식당 정보
 * @param maxMenuLines 메뉴당 최대 줄 수 (null이면 자동 계산)
 */
@Composable
fun CafeteriaColumn(
    mealInfo: MealInfo,
    maxMenuLines: Int? = null,
    cafeteriaNameToken: String = "search.b17",
    hourToken: String = "widget.m11",
    menuToken: String = "widget.sb12",
    showHours: Boolean = true
) {
    val calculatedMaxLines = maxMenuLines ?: when {
        mealInfo.courses.size <= 1 -> 3
        mealInfo.courses.size == 2 -> 2
        else -> 1
    }

    Column(
        modifier = GlanceModifier.fillMaxHeight(),
        horizontalAlignment = Alignment.Horizontal.Start
    ) {
        Text(
            text = mealInfo.cafeteriaName,
            style = TypographyTokens.textStyle(key = cafeteriaNameToken),
            maxLines = 1
        )
        if (showHours) {
            Spacer(modifier = GlanceModifier.height(2.dp))
            WidgetHoursText(hoursLabel = mealInfo.hoursLabel, hourToken = hourToken)
            Spacer(modifier = GlanceModifier.height(6.dp))
        } else {
            Spacer(modifier = GlanceModifier.height(6.dp))
        }
        mealInfo.courses.forEach { line ->
            Text(
                text = line,
                style = TypographyTokens.textStyle(key = menuToken),
                modifier = GlanceModifier.padding(top = 3.dp),
                maxLines = calculatedMaxLines
            )
        }
    }
}

fun MealInfo.isEmptyDraftState(): Boolean {
    if (isEmptyState) return true
    if (cafeteriaName.isBlank()) return true
    return courses.isEmpty()
}

@Composable
fun WidgetEmptyState() {
    Column(
        modifier = GlanceModifier.fillMaxSize().padding(horizontal = 8.dp),
        verticalAlignment = Alignment.Vertical.CenterVertically,
        horizontalAlignment = Alignment.Horizontal.CenterHorizontally
    ) {
        Image(
            provider = ImageProvider(R.drawable.ic_widget_bob),
            contentDescription = "빈 상태 아이콘",
            modifier = GlanceModifier.width(57.dp).height(57.dp)
        )
        Spacer(modifier = GlanceModifier.height(12.dp))
        Text(
            text = "등록된 식단이 없어요",
            style = TypographyTokens.textStyle(key = "head.sb18")
        )
        Spacer(modifier = GlanceModifier.height(10.dp))
        Text(
            text = "식단 정보가 등록되지 않았어요.",
            style = TypographyTokens.textStyle(
                key = "widget.m11",
                color = ColorProvider(Color.Gray, Color.Gray)
            )
        )
        Spacer(modifier = GlanceModifier.height(4.dp))
        Text(
            text = "잠시 후 다시 확인해주세요.",
            style = TypographyTokens.textStyle(
                key = "widget.m11",
                color = ColorProvider(Color.Gray, Color.Gray)
            )
        )
    }
}