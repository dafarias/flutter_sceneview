package com.example.flutter_sceneview.models.nodes

import com.example.flutter_sceneview.utils.MathUtils
import android.graphics.Color
import io.github.sceneview.math.Position
import io.github.sceneview.math.Rotation
import io.github.sceneview.math.Scale
import java.util.UUID
import android.util.Log
import com.example.flutter_sceneview.models.shapes.BaseShape
import com.example.flutter_sceneview.models.materials.BaseMaterial
import dev.romainguy.kotlin.math.Float3
import dev.romainguy.kotlin.math.Quaternion



fun Float3.toMap(): Map<String, Float> = mapOf(
    "x" to x, "y" to y, "z" to z
)

fun Quaternion.toMap(): Map<String, Float> = mapOf(
    "x" to x, "y" to y, "z" to z, "w" to w
)

data class SceneNode(
    val nodeId: String = UUID.randomUUID().toString(),
    var position: Position,
    var rotation: Rotation? = null,
    var scale: Scale? = null,
    val type: NodeType,
    val config: NodeConfig,
    var isPlaced: Boolean = false
) {
    fun toMap(): Map<String, Any?> = mapOf(
        "nodeId" to nodeId,
        "position" to position.toMap(),
        "rotation" to rotation?.toMap(),
        "scale" to scale?.toMap(),
        "type" to type.name,
        "isPlaced" to isPlaced,
        "config" to when (config) {
            is ModelConfig -> mapOf("fileName" to config.fileName)
            is ShapeConfig -> mapOf(
                "shape" to config.shape?.toMap(), "material" to config.material?.toMap()
            )

            is TextConfig -> mapOf(
                "text" to config.text,
                "fontFamily" to config.fontFamily,
                "textColor" to config.textColor,
                "size" to config.size
            )
        },
    )

    companion object {
        fun fromMap(map: Map<*, *>): SceneNode? {
            try {
                val positionMap = map["position"] as? Map<*, *>
                val rotationMap = map["rotation"] as? Map<*, *>
                val scaleMap = map["scale"] as? Map<*, *>

                val position = positionMap?.let { MathUtils.positionFromMap(it) } ?: return null
                val rotation = rotationMap?.let { MathUtils.rotationFromMap(it) }
                val scale = scaleMap?.let { MathUtils.scaleFromMap(it) }

                val type = try {
                    NodeType.valueOf((map["type"] as String).uppercase())
                } catch (e: IllegalArgumentException) {
                    NodeType.UNKNOWN
                }


                val configMap = map["config"] as? Map<*, *>
                val config = when (type) {
                    NodeType.MODEL -> ModelConfig(configMap?.get("fileName") as? String)
                    NodeType.SHAPE -> ShapeConfig(
                        shape = (configMap?.get("shape") as? Map<*, *>)?.let { BaseShape.fromMap(it) },
                        material = (configMap?.get("material") as? Map<*, *>)?.let {
                            BaseMaterial.fromMap(
                                it
                            )
                        })

                    NodeType.TEXT -> TextConfig(
                        text = configMap?.get("text") as? String,
                        fontFamily = configMap?.get("fontFamily") as? String,
                        textColor = configMap?.get("textColor") as? Int ?: Color.WHITE,
                        size = (configMap?.get("size") as? Number)?.toFloat() ?: 1f
                    )

                    else -> { return null}
                }

                return SceneNode(
                    nodeId = map["nodeId"] as? String ?: UUID.randomUUID().toString(),
                    position = position,
                    rotation = rotation,
                    scale = scale,
                    type = type,
                    config = config,
                    isPlaced = map["isPlaced"] as? Boolean == true
                )
            } catch (e: Exception) {
                Log.e("SceneNode", "Failed to deserialize: ${e.message}")
                return null
            }
        }

    }
}