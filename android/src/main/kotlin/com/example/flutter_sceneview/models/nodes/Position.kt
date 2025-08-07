package com.example.flutter_sceneview.models.nodes

import dev.romainguy.kotlin.math.Quaternion
import io.github.sceneview.math.Position


fun Position.toMap(): Map<String, Float> = mapOf(
    "x" to x,
    "y" to y,
    "z" to z,
)

fun Quaternion.toMap(): Map<String, Float> = mapOf(
    "x" to x,
    "y" to y,
    "z" to z,
    "w" to w,
)

fun positionFromMap(map: Map<*, *>): Position? {
    val x = (map["x"] as? Number)?.toFloat() ?: return null
    val y = (map["y"] as? Number)?.toFloat() ?: return null
    val z = (map["z"] as? Number)?.toFloat() ?: return null
    return Position(x, y, z)
}


fun rotationQuaternionFromMap(map: Map<*, *>): Quaternion? {
    val x = (map["x"] as? Number)?.toFloat() ?: return null
    val y = (map["y"] as? Number)?.toFloat() ?: return null
    val z = (map["z"] as? Number)?.toFloat() ?: return null
    val w = (map["w"] as? Number)?.toFloat() ?: return null
    return Quaternion(x, y, z, w)
}
