package com.hwoo.bobmoo

import org.json.JSONObject
import java.util.Calendar

object AllCafeteriasDataParser {
    /**
     * 여러 식당 정보가 담긴 JSON 배열 형식의 문자열을 파싱하여
     * MealInfo 객체의 리스트로 반환합니다.
     * @param data Flutter에서 전달받은 JSON 문자열 (형태: { "cafeterias": [...] })
     * @param now 현재 시간
     * @return 파싱된 MealInfo 객체의 리스트
     */
    fun parseAllCafeterias(data: String?, now: Calendar): List<MealInfo> {
        // 데이터가 null인 경우, 사용자에게 안내 메시지를 담은 리스트를 반환합니다.
        if (data == null) {
            return listOf(
                MealInfo(
                    periodLabel = "식당 정보 없음",
                    hoursLabel = "",
                    cafeteriaName = "앱을 실행하여",
                    courses = listOf("데이터를 동기화 해주세요."),
                    status = ""
                )
            )
        }

        return try {
            val root = JSONObject(data)
            val cafeteriasArray = root.getJSONArray("cafeterias")
            val mealInfoList = mutableListOf<MealInfo>()

            // JSON 배열을 순회하면서 각 식당 객체를 파싱합니다.
            for (i in 0 until cafeteriasArray.length()) {
                val cafeteriaObject = cafeteriasArray.getJSONObject(i)

                // **핵심: 기존 MealWidgetDataParser를 그대로 재사용합니다.**
                // 각 식당 객체를 문자열로 다시 변환하여 기존 파서에 넘겨줍니다.
                val mealInfo = MealWidgetDataParser.parseMealInfo(cafeteriaObject.toString(), now)

                mealInfoList.add(mealInfo)
            }

            // 파싱된 MealInfo 객체들이 담긴 리스트를 최종적으로 반환합니다.
            mealInfoList

        } catch (e: Exception) {
            // JSON 파싱 중 오류가 발생한 경우, 에러 메시지를 담은 리스트를 반환합니다.
            listOf(
                MealInfo(
                    periodLabel = "데이터 오류",
                    hoursLabel = "",
                    cafeteriaName = "데이터 포맷을",
                    courses = listOf("확인해주세요."),
                    status = ""
                )
            )
        }
    }
}