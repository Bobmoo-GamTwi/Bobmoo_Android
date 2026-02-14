package com.hwoo.bobmoo

import android.content.Context
import androidx.glance.GlanceId
import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.SizeMode
import androidx.glance.appwidget.provideContent
import es.antonborri.home_widget.HomeWidgetPlugin
import java.util.Calendar

class MealGlanceWidget : GlanceAppWidget() {
    // 데이터 새로고침을 위해 stateDefinition 주석처리
    // override val stateDefinition = HomeWidgetGlanceStateDefinition()
    override val sizeMode = SizeMode.Single

    override suspend fun provideGlance(context: Context, id: GlanceId) {
        provideContent {
            // SharedPreferences에서 모든 데이터를 읽어옵니다.
            val widgetData = HomeWidgetPlugin.getData(context)

            // 전체 식당 데이터 (JSON 배열 형식)
            val allCafeteriasJsonString = widgetData.getString("widgetData", null)
            // Flutter 설정에서 사용자가 선택한 '대표 식당' 이름
            val selectedCafeteriaName = widgetData.getString("selectedCafeteriaName", null)

            val now = Calendar.getInstance()

            // 전체 식당 데이터를 파싱하여 List<MealInfo> 형태로 변환합니다.
            // (AllCafeteriasDataParser는 다음 단계에서 만들 예정이지만, 구조는 미리 적용합니다)
            val allMealInfos =
                AllCafeteriasDataParser.parseAllCafeterias(allCafeteriasJsonString, now)

            // 파싱된 전체 식당 리스트에서 '대표 식당' 이름과 일치하는 정보를 찾습니다.
            val targetMealInfo = if (selectedCafeteriaName != null) {
                allMealInfos.find { it.cafeteriaName == selectedCafeteriaName }
            } else {
                // 선택된 식당 정보가 없으면, 리스트의 첫 번째 항목을 기본값으로 사용합니다.
                allMealInfos.firstOrNull()
            }

            if (targetMealInfo != null) {
                // 일치하는 식당 정보를 찾았으면, 기존 UI에 그대로 전달합니다.
                MealWidgetContent(context = context, mealInfo = targetMealInfo)
            } else {
                // 표시할 데이터가 아무것도 없는 경우 (초기 상태 등)
                // MealWidgetDataParser의 기본값을 활용할 수 있습니다.
                val defaultInfo = MealWidgetDataParser.parseMealInfo(null, now)
                MealWidgetContent(context = context, mealInfo = defaultInfo)
            }
        }
    }
}