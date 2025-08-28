package com.example.flutter_sceneview.models.nodes

import dev.romainguy.kotlin.math.Quaternion
import io.github.sceneview.math.Position
import io.github.sceneview.math.Rotation
import io.github.sceneview.math.Scale



//TODO: Replace with SceneNode
data class NodeInfo(
    val nodeId: String,
    val position: Position,
    val rotation: Rotation? = null,
    val scale: Scale? = null,
) {
    fun toMap(): Map<String, Any?> = mapOf(
        "nodeId" to nodeId,
        "position" to position.toMap(),
        "rotation" to rotation?.toMap(),
        "scale" to scale?.toMap(),
    )
}