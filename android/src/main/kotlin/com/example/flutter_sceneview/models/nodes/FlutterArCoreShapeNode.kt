package com.example.flutter_sceneview.models.nodes

import com.example.flutter_sceneview.models.nodes.FlutterArCoreNode
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
        //Todo: Add type based  enum to have a uniform way to select the type in both
        // languages
        return when (shapeType) {
            "Sphere" -> SphereNode(
                engine,
                radius = radius ?: DEFAULT_RADIUS,
                materialInstance = material
            )

            else -> null
        }
    }
}