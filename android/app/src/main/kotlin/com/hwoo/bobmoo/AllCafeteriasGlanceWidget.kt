package com.hwoo.bobmoo

import android.content.Context
import androidx.glance.GlanceId
import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.SizeMode
import androidx.glance.appwidget.provideContent
import es.antonborri.home_widget.HomeWidgetPlugin
import java.util.Calendar

class AllCafeteriasGlanceWidget : GlanceAppWidget() {
    // 1. 위젯 사이즈 모드를 '반응형'으로 설정합니다.
    override val sizeMode = SizeMode.Single

    override suspend fun provideGlance(context: Context, id: GlanceId) {
        provideContent {
            // 2. Flutter에서 저장한 데이터를 읽어옵니다.
            val widgetData = HomeWidgetPlugin.getData(context)
            val data = widgetData.getString("widgetData", null)
            val now = Calendar.getInstance()

            // 3. 3단계에서 만든 파서를 호출하여 데이터를 파싱합니다. -> List<MealInfo>
            val mealInfos = AllCafeteriasDataParser.parseAllCafeterias(data, now)

            // 4. 4단계에서 만든 UI에 파싱된 데이터를 전달하여 화면을 그립니다.
            AllCafeteriasWidgetContent(context = context, mealInfos = mealInfos)
        }
    }
}