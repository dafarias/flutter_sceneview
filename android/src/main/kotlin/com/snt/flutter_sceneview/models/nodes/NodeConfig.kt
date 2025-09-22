package com.snt.flutter_sceneview.models.nodes

import com.snt.flutter_sceneview.models.materials.BaseMaterial
import com.snt.flutter_sceneview.models.shapes.BaseShape

enum class NodeType {
    MODEL, SHAPE, TEXT, ANCHOR, UNKNOWN
}

sealed class NodeConfig

data class ModelConfig(val fileName: String? = null, val loadDefault: Boolean? = false) :
    NodeConfig()

data class ShapeConfig(val shape: BaseShape? = null, val material: BaseMaterial? = null) :
    NodeConfig()

data class TextConfig(
    val text: String? = null,
    val fontFamily: String? = null,
    val textColor: Int = BaseMaterial.Companion.DEFAULT.color,
    val size: Float = 1f // Width in meters
) : NodeConfig()