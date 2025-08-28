package com.example.flutter_sceneview.models.nodes

import android.util.Log
import com.example.flutter_sceneview.utils.MathUtils
import dev.romainguy.kotlin.math.Quaternion
import io.github.sceneview.math.Position
import io.github.sceneview.math.Rotation
import io.github.sceneview.math.toQuaternion
import io.github.sceneview.math.Transform


/**
 * Represents a pose in 3D space with position, Euler rotation, and optional quaternion, adapted for SceneView and Flutter.
 */
data class Pose(
    val position: Position,
    val rotation: Rotation? = null, // Euler angles (x, y, z) in degrees or radians
    val quaternion: Quaternion? = null // Raw quaternion for advanced use
) {
    /**
     * Converts the pose to a map with double arrays for Flutter compatibility.
     */
    fun toMap(): Map<String, Any?> = mapOf(
        "position" to Utils.toDoubleArray(position),
        "rotation" to Utils.rotationToDoubleArray(rotation),
        "quaternion" to Utils.quaternionToDoubleArray(quaternion)
    ).filterValues { it != null }

    /**
     * Creates a Pose from a map.
     */
    companion object {
        fun fromMap(map: Map<*, *>): Pose? {
            try {
                val positionMap = map["position"] as? Map<*, *>
                val rotationMap = map["rotation"] as? Map<*, *>
                val quaternionMap = map["quaternion"] as? Map<*, *>

                val position = positionMap?.let { MathUtils.positionFromMap(it) } ?: return null
                val rotation = rotationMap?.let { MathUtils.rotationFromMap(it) }
                val quaternion = quaternionMap?.let { MathUtils.quaternionFromMap(it) }

                return Pose(position, rotation, quaternion)
            } catch (e: Exception) {
                Log.e("Pose", "Failed to deserialize pose: ${e.message}")
                return null
            }
        }
    }

    // Nested utility object for centralized conversion logic
    object Utils {
        fun toDoubleArray(value: Position): DoubleArray = doubleArrayOf(
            value.x.toDouble(), value.y.toDouble(), value.z.toDouble()
        )

        fun rotationToDoubleArray(value: Rotation?): DoubleArray? = value?.let {
            doubleArrayOf(it.x.toDouble(), it.y.toDouble(), it.z.toDouble())
        }

        fun quaternionToDoubleArray(value: Quaternion?): DoubleArray? = value?.let {
            doubleArrayOf(it.x.toDouble(), it.y.toDouble(), it.z.toDouble(), it.w.toDouble())
        }
    }

    // Accessors for SceneView/ARCore-like API
    fun tx(): Float = position.x
    fun ty(): Float = position.y
    fun tz(): Float = position.z

    fun qx(): Float? = quaternion?.x ?: rotation?.x // Prefer quaternion, fall back to rotation x
    fun qy(): Float? = quaternion?.y ?: rotation?.y
    fun qz(): Float? = quaternion?.z ?: rotation?.z
    fun qw(): Float? = quaternion?.w

    // Convenience method to get Transform for SceneView
    fun toTransform(): Transform = Transform(
        position = position,
        quaternion = quaternion ?: rotation?.toQuaternion() ?: Quaternion(),
        scale = Position(1.0f, 1.0f, 1.0f) // Default scale
    )
}