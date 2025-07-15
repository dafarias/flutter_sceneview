package com.example.flutter_sceneview.models.materials

import android.graphics.Color
import androidx.annotation.ColorInt
import androidx.annotation.IntRange
import kotlin.text.get


//TODO: Create model classes as any other class. If needed to create using a map argument
// then add the methods to map / from map.
class BaseMaterial(materialProps: Map<String, *>) {

    private val argb: ArrayList<Int>? = materialProps["color"] as? ArrayList<Int>
    @field:ColorInt
    var color: Int = getIntColor(argb) ?: DEFAULT_COLOR

    @field:IntRange(from = 0, to = 100)
    var metallic: Int = materialProps["metallic"] as? Int ?: DEFAULT_METALLIC

    @field:IntRange(from = 0, to = 100)
    var roughness: Int = materialProps["roughness"] as? Int ?: DEFAULT_ROUGHNESS

    @field:IntRange(from = 0, to = 100)
    var reflectance: Int = materialProps["reflectance"] as? Int ?: DEFAULT_REFLECTANCE

    val textureBytes: ByteArray? = materialProps["textureBytes"] as? ByteArray

    companion object {
        private const val DEFAULT_COLOR = Color.WHITE
        private const val DEFAULT_METALLIC = 0
        private const val DEFAULT_ROUGHNESS = 40
        private const val DEFAULT_REFLECTANCE = 50

        val DEFAULT = BaseMaterial(HashMap<String, Any>())

    }

    private fun getIntColor(argb: ArrayList<Int>?): Int? {
        if (argb != null) {
            return Color.argb(argb[0], argb[1], argb[2], argb[3])
        }
        return null
    }
}
