package com.example.flutter_sceneview.models.nodes

import com.google.ar.core.Pose
import io.github.sceneview.ar.arcore.rotation

class HitTestResult(
    private val distance: Float, private val pose: Pose
) {
    fun toMap(): Map<String, Any> {
        val map = HashMap<String, Any>()
        map["distance"] = distance.toDouble()
        map["pose"] = pose.toMap()
        return map
    }
}


fun Pose.toMap(): Map<String, Any> {
    return mapOf(
        "position" to translation.map { it.toDouble() }.toDoubleArray(),
        "rotation" to rotation.toFloatArray().map { it.toDouble() }.toDoubleArray(),
        "quaternion" to rotationQuaternion.map { it.toDouble() }.toDoubleArray(),
    )
}