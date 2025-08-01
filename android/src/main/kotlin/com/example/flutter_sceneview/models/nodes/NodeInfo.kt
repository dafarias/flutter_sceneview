package com.example.flutter_sceneview.models.nodes

import dev.romainguy.kotlin.math.Quaternion
import io.github.sceneview.math.Position

data class NodeInfo(
    val nodeId: String,
    val position: Position,
    val rotation: Quaternion? = null,
    val scale: Float? = null,
) {
    fun toMap(): Map<String, Any?> = mapOf(
        "nodeId" to nodeId,
        "position" to position.toMap(),
        "rotation" to rotation?.toMap(),
        "scale" to scale,
    )

//    companion object {
//        @Suppress("UNCHECKED_CAST")
//        fun fromMap(map: Map<String, Any?>): NodeInfo {
//            val nodeId   = map["nodeId"] as String
//            val posMap   = map["position"] as Map<String, Any?>
//            val position = Position.fromMap(posMap)
//
//            val rotMap   = map["rotation"] as? Map<String, Any?>
//            val rotation = rotMap?.let { Position.fromMap(it) }
//
//            val scale    = (map["scale"] as? Number)?.toFloat()
//
//            return NodeInfo(nodeId, position, rotation, scale)
//        }
//    }
}