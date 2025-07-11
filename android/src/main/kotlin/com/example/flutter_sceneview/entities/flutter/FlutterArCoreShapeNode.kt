package com.example.flutter_sceneview.entities.flutter

import com.google.android.filament.Engine
import com.google.android.filament.MaterialInstance
import io.github.sceneview.node.Node
import io.github.sceneview.node.SphereNode

class FlutterArCoreShapeNode(shapeProps: Map<String, *>) :
    FlutterArCoreNode(shapeProps) {

    // TODO: Recheck all/add more args when more shapes are available
    val shapeType: String = shapeProps["shapeType"] as String
    val radius: Float? = (shapeProps["radius"] as? Double)?.toFloat()

    companion object {
        const val DEFAULT_RADIUS = 0.05f
    }

    fun build(engine: Engine, material: MaterialInstance?): Node? {
        return when (shapeType) {
            "ArCoreSphere" -> SphereNode(
                engine,
                radius = radius ?: DEFAULT_RADIUS,
                materialInstance = material
            )

            else -> null
        }
    }
}