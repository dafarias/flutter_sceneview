package com.example.flutter_sceneview.models.nodes

import io.github.sceneview.math.Position

data class NodeInfo(
    val nodeId: String,
    val position: Position,
    val rotation: Position? = null,
    val scale: Float? = null,
) {
    fun toMap(): Map<String, Any?> = mapOf(
        "nodeId" to nodeId,
        "position" to position.toMap(),
        "rotation" to rotation?.toMap(),
        "scale" to scale,
    )
}