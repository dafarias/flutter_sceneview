package com.snt.flutter_sceneview.utils

import dev.romainguy.kotlin.math.Float3
import dev.romainguy.kotlin.math.Quaternion
import io.github.sceneview.math.Position
import io.github.sceneview.math.Rotation
import io.github.sceneview.math.Scale

/**
 * Utility functions for converting SceneView math types to and from maps.
 */
object MathUtils {
    fun positionFromMap(map: Map<*, *>): Position? {
        val x = (map["x"] as? Number)?.toFloat() ?: return null
        val y = (map["y"] as? Number)?.toFloat() ?: return null
        val z = (map["z"] as? Number)?.toFloat() ?: return null
        return Position(x, y, z)
    }

    fun rotationFromMap(map: Map<*, *>): Rotation? {
        val x = (map["x"] as? Number)?.toFloat() ?: return null
        val y = (map["y"] as? Number)?.toFloat() ?: return null
        val z = (map["z"] as? Number)?.toFloat() ?: return null
        return Rotation(x, y, z)
    }

    fun scaleFromMap(map: Map<*, *>): Scale? {
        val x = (map["x"] as? Number)?.toFloat() ?: return null
        val y = (map["y"] as? Number)?.toFloat() ?: return null
        val z = (map["z"] as? Number)?.toFloat() ?: return null
        return Scale(x, y, z)
    }

    fun quaternionFromMap(map: Map<*, *>): Quaternion? {
        val x = (map["x"] as? Number)?.toFloat() ?: return null
        val y = (map["y"] as? Number)?.toFloat() ?: return null
        val z = (map["z"] as? Number)?.toFloat() ?: return null
        val w = (map["w"] as? Number)?.toFloat() ?: return null
        return Quaternion(x, y, z, w)
    }
}
