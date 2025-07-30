package com.example.flutter_sceneview.models.nodes

import io.github.sceneview.math.Position

fun Position.toMap(): Map<String, Float> = mapOf(
    "x" to x,
    "y" to y,
    "z" to z,
)

// extend your Position with a from‑map factory
//fun Position.Companion.fromMap(map: Map<String, Any?>): Position {
//    val x = (map["x"] as Number).toFloat()
//    val y = (map["y"] as Number).toFloat()
//    val z = (map["z"] as Number).toFloat()
//    return Position(x, y, z)
//}