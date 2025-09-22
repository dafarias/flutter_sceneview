package com.snt.flutter_sceneview.utils

import android.graphics.Color
import kotlin.math.roundToInt

class ColorUtils {

    companion object {
        fun getIntColor(color: List<*>?): Int? {
            if (color != null && color.size == 4) {
                val argb = color.mapNotNull { (it as? Number)?.toFloat() }
                val a = (argb[0] * 255).roundToInt()
                val r = (argb[1] * 255).roundToInt()
                val g = (argb[2] * 255).roundToInt()
                val b = (argb[3] * 255).roundToInt()
                return Color.argb(a, r, g, b)
            }
            return null
        }

        fun Color.listOfArgb(): List<Int> {
            return listOf(
                (alpha() * 255).toInt(),
                (red() * 255).toInt(),
                (green() * 255).toInt(),
                (blue() * 255).toInt()
            )
        }
    }
}



