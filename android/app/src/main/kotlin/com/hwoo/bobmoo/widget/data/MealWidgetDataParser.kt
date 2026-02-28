package com.hwoo.bobmoo.widget.data

import org.json.JSONArray
import org.json.JSONObject
import java.util.Calendar

// 위젯에 표시될 정보를 담는 데이터 클래스
data class MealInfo(
    val dateLabel: String,
    val periodLabel: String,
    val hoursLabel: String,
    val cafeteriaName: String,
    val courses: List<String>,
    val status: String,
    val isEmptyState: Boolean = false
) {
    companion object {
        fun empty(): MealInfo = MealInfo(
            dateLabel = "",
            periodLabel = "",
            hoursLabel = "",
            cafeteriaName = "",
            courses = emptyList(),
            status = "",
            isEmptyState = true
        )
    }
}

object MealWidgetDataParser {

    private enum class MealPeriod { BREAKFAST, LUNCH, DINNER }
    private data class PeriodSelection(val period: MealPeriod, val status: String)

    fun parseMealInfo(data: String?, now: Calendar): MealInfo {
        if (data == null) {
            return MealInfo.empty()
        }

        try {
            val root = JSONObject(data)
            val dateLabel = root.optString("date", "")
            val cafeteriaName = root.optString("cafeteriaName", "식당 정보 없음")

            val hours = root.optJSONObject("hours")
            val breakfastHours = hours?.optString("breakfast") ?: ""
            val lunchHours = hours?.optString("lunch") ?: ""
            val dinnerHours = hours?.optString("dinner") ?: ""

            val meals = root.optJSONObject("meals")
            val breakfast = meals?.optJSONArray("breakfast") ?: JSONArray()
            val lunch = meals?.optJSONArray("lunch") ?: JSONArray()
            val dinner = meals?.optJSONArray("dinner") ?: JSONArray()

            val currentSelection = selectTargetPeriod(
                now,
                breakfastHours,
                lunchHours,
                dinnerHours
            )

            val target = selectDisplayPeriod(
                currentPeriod = currentSelection.period,
                breakfast = breakfast,
                lunch = lunch,
                dinner = dinner
            ) ?: return MealInfo.empty()

            val periodLabel: String
            val hoursLabel: String
            val courses: List<String>

            when (target) {
                MealPeriod.BREAKFAST -> {
                    periodLabel = "아침"
                    hoursLabel = breakfastHours
                    courses = mapCourses(breakfast)
                }

                MealPeriod.LUNCH -> {
                    periodLabel = "점심"
                    hoursLabel = lunchHours
                    courses = mapCourses(lunch)
                }

                MealPeriod.DINNER -> {
                    periodLabel = "저녁"
                    hoursLabel = dinnerHours
                    courses = mapCourses(dinner)
                }
            }

            return MealInfo(
                dateLabel,
                periodLabel,
                hoursLabel,
                cafeteriaName,
                courses,
                currentSelection.status,
                isEmptyState = false
            )

        } catch (e: Exception) {
            return MealInfo.empty()
        }
    }

    private fun selectTargetPeriod(
        now: Calendar,
        breakfastHours: String,
        lunchHours: String,
        dinnerHours: String,
    ): PeriodSelection {
        val b = parseHoursToToday(now, breakfastHours)
        val l = parseHoursToToday(now, lunchHours)
        val d = parseHoursToToday(now, dinnerHours)

        return when {
            now.before(b.first) -> PeriodSelection(MealPeriod.BREAKFAST, "운영전")
            now.after(b.first) && now.before(b.second) -> PeriodSelection(MealPeriod.BREAKFAST, "운영중")
            now.after(b.second) && now.before(l.first) -> PeriodSelection(MealPeriod.LUNCH, "운영전")
            now.after(l.first) && now.before(l.second) -> PeriodSelection(MealPeriod.LUNCH, "운영중")
            now.after(l.second) && now.before(d.first) -> PeriodSelection(MealPeriod.DINNER, "운영전")
            now.after(d.first) && now.before(d.second) -> PeriodSelection(MealPeriod.DINNER, "운영중")
            else -> PeriodSelection(MealPeriod.DINNER, "운영종료")
        }
    }

    private fun selectDisplayPeriod(
        currentPeriod: MealPeriod,
        breakfast: JSONArray,
        lunch: JSONArray,
        dinner: JSONArray
    ): MealPeriod? {
        fun hasMeals(period: MealPeriod): Boolean = when (period) {
            MealPeriod.BREAKFAST -> breakfast.length() > 0
            MealPeriod.LUNCH -> lunch.length() > 0
            MealPeriod.DINNER -> dinner.length() > 0
        }

        val orderedCandidates = when (currentPeriod) {
            // 현재 -> 과거(가까운 순) -> 미래
            MealPeriod.BREAKFAST -> listOf(MealPeriod.BREAKFAST, MealPeriod.LUNCH, MealPeriod.DINNER)
            MealPeriod.LUNCH -> listOf(MealPeriod.LUNCH, MealPeriod.BREAKFAST, MealPeriod.DINNER)
            MealPeriod.DINNER -> listOf(MealPeriod.DINNER, MealPeriod.LUNCH, MealPeriod.BREAKFAST)
        }

        return orderedCandidates.firstOrNull { hasMeals(it) }
    }

    private fun parseHoursToToday(base: Calendar, hours: String): Pair<Calendar, Calendar> {
        // hours: "HH:mm-HH:mm"
        val startEnd = hours.split("-")
        val start = (base.clone() as Calendar)
        val end = (base.clone() as Calendar)
        fun apply(timeStr: String, cal: Calendar) {
            try {
                val parts = timeStr.trim().split(":")
                cal.set(Calendar.HOUR_OF_DAY, parts[0].toInt())
                cal.set(Calendar.MINUTE, parts[1].toInt())
                cal.set(Calendar.SECOND, 0)
                cal.set(Calendar.MILLISECOND, 0)
            } catch (_: Exception) {
                // fallback 00:00
                cal.set(Calendar.HOUR_OF_DAY, 0)
                cal.set(Calendar.MINUTE, 0)
                cal.set(Calendar.SECOND, 0)
                cal.set(Calendar.MILLISECOND, 0)
            }
        }
        if (startEnd.size == 2) {
            apply(startEnd[0], start)
            apply(startEnd[1], end)
        } else {
            // invalid -> 00:00-00:00
            apply("00:00", start)
            apply("00:00", end)
        }
        return start to end
    }

    private fun mapCourses(mealArray: JSONArray): List<String> {
        val courses = mutableListOf<String>()
        for (i in 0 until mealArray.length()) {
            try {
                val meal = mealArray.getJSONObject(i)
                val course = meal.optString("course", "")
                val mainMenu = meal.optString("mainMenu", "")
                if (course.isNotEmpty() && mainMenu.isNotEmpty()) {
                    courses.add("$course $mainMenu")
                }
            } catch (e: Exception) {
                // 개별 메뉴 파싱 실패 시 무시
            }
        }
        return courses
    }
}