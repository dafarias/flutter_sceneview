package com.example.flutter_sceneview.models.materials

import android.graphics.Color
import android.util.Log
import androidx.annotation.ColorInt
import androidx.annotation.FloatRange
import com.example.flutter_sceneview.utils.ColorUtils
import com.example.flutter_sceneview.utils.ColorUtils.Companion.listOfArgb
import io.github.sceneview.material.kMaterialDefaultMetallic
import io.github.sceneview.material.kMaterialDefaultReflectance
import io.github.sceneview.material.kMaterialDefaultRoughness


class BaseMaterial(
    @ColorInt var color: Int = DEFAULT_COLOR,

    @FloatRange(from = 0.0, to = 1.0) var metallic: Float = DEFAULT_METALLIC,

    @FloatRange(from = 0.0, to = 1.0) var roughness: Float = DEFAULT_ROUGHNESS,

    @FloatRange(from = 0.0, to = 1.0) var reflectance: Float = DEFAULT_REFLECTANCE,

    val textureBytes: ByteArray? = null
) {

    companion object {
        private const val DEFAULT_COLOR = Color.WHITE
        private const val DEFAULT_METALLIC = kMaterialDefaultMetallic
        private const val DEFAULT_ROUGHNESS = kMaterialDefaultRoughness
        private const val DEFAULT_REFLECTANCE = kMaterialDefaultReflectance

        val DEFAULT = BaseMaterial()

        fun fromMap(map: Map<*, *>): BaseMaterial? {
            if (map.isEmpty()) {
                return DEFAULT
            }
            try {
                val color = ColorUtils.getIntColor(map["color"] as? List<*>) ?: DEFAULT_COLOR
                val metallic =
                    (map["metallic"] as? Number)?.toFloat()?.coerceIn(0f, 1f) ?: DEFAULT_METALLIC
                val roughness =
                    (map["roughness"] as? Number)?.toFloat()?.coerceIn(0f, 1f) ?: DEFAULT_ROUGHNESS
                val reflectance = (map["reflectance"] as? Number)?.toFloat()?.coerceIn(0f, 1f)
                    ?: DEFAULT_REFLECTANCE
                val textureBytes = map["textureBytes"] as? ByteArray

                return BaseMaterial(
                    color = color,
                    metallic = metallic,
                    roughness = roughness,
                    reflectance = reflectance,
                    textureBytes = textureBytes
                )
            } catch (e: Exception) {
                Log.e(
                    "BaseMaterial",
                    "Failed to deserialize json object into BaseMaterial: ${e.message}"
                )
                return null
            }
        }

    }

    fun toMap(): Map<String, Any?> = mapOf(
        "color" to Color.valueOf(color).listOfArgb(),
        "metallic" to metallic,
        "roughness" to roughness,
        "reflectance" to reflectance,
        "textureBytes" to textureBytes
    )

}
