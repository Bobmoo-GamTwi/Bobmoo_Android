// GENERATED CODE - DO NOT MODIFY BY HAND.
// Source: tokens/typography.json

package com.hwoo.bobmoo.widget.theme

import androidx.compose.ui.unit.sp
import androidx.glance.text.FontFamily
import androidx.glance.text.FontWeight
import androidx.glance.text.TextStyle
import androidx.glance.unit.ColorProvider

data class TypographyToken(
    val fontSizeSp: Float,
    val letterSpacingPercent: Float,
    val fontWeight: FontWeight
)

object TypographyTokens {
    private val tokens = mapOf(
        "button.sb11" to TypographyToken(12f, 0.04f, FontWeight.Bold),
        "button.sb12" to TypographyToken(12f, 0.02f, FontWeight.Bold),
        "caption.m15" to TypographyToken(15f, 0.02f, FontWeight.Medium),
        "caption.r15" to TypographyToken(15f, 0.02f, FontWeight.Normal),
        "caption.sb11" to TypographyToken(11f, 0.02f, FontWeight.Bold),
        "caption.sb9" to TypographyToken(9f, 0.02f, FontWeight.Bold),
        "head.b21" to TypographyToken(21f, 0.05f, FontWeight.Bold),
        "head.b30" to TypographyToken(30f, 0.04f, FontWeight.Bold),
        "head.b48" to TypographyToken(48f, 0.04f, FontWeight.Bold),
        "head.sb18" to TypographyToken(18f, 0.05f, FontWeight.Bold),
        "search.b15" to TypographyToken(15f, 0.02f, FontWeight.Bold),
        "search.b17" to TypographyToken(17f, 0.04f, FontWeight.Bold),
        "search.sb12" to TypographyToken(12f, 0.02f, FontWeight.Bold),
        "search.sb15" to TypographyToken(15f, 0.02f, FontWeight.Bold),
        "widget.m11" to TypographyToken(13f, 0.02f, FontWeight.Medium),
        "widget.r11" to TypographyToken(13f, 0.02f, FontWeight.Normal),
        "widget.sb12" to TypographyToken(14f, 0.05f, FontWeight.Bold),
        "widget.sb14" to TypographyToken(16f, 0.05f, FontWeight.Bold),
        "widget.sb7" to TypographyToken(9f, 0.02f, FontWeight.Bold),
    )

    private fun token(key: String): TypographyToken {
        return requireNotNull(tokens[key]) {
            "Unknown typography token: $key"
        }
    }

    fun textStyle(key: String): TextStyle {
        val token = token(key)
        return TextStyle(
            fontSize = token.fontSizeSp.sp,
            fontWeight = token.fontWeight
        )
    }

    fun textStyle(key: String, color: ColorProvider): TextStyle {
        val token = token(key)
        return TextStyle(
            fontSize = token.fontSizeSp.sp,
            fontWeight = token.fontWeight,
            color = color,
            fontFamily = FontFamily.SansSerif,
        )
    }
}

