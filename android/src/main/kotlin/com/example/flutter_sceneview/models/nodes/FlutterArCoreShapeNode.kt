package com.example.flutter_sceneview.models.nodes

import com.example.flutter_sceneview.models.nodes.FlutterArCoreNode
import com.example.flutter_sceneview.models.shapes.Shapes
import com.example.flutter_sceneview.models.shapes.Sphere
import com.example.flutter_sceneview.models.shapes.Torus
import com.google.android.filament.Engine
import com.google.android.filament.MaterialInstance
import io.github.sceneview.node.Node
import io.github.sceneview.node.SphereNode


// TODO: Improve API to add a shape node. The shape should be attached to the node
//  as an optional param. Also, the flow can be improved by just expanding the add shape node.
//  In essence it should receive the coordinates (x,y) and the shape(type, material, etc). If performing
//  a hit test on x,y it should return the Pose to add the node directly, instead of sending it from
//  the flutter side
class FlutterArCoreShapeNode(shapeProps: Map<String, *>) : FlutterArCoreNode(shapeProps) {

    // TODO: Recheck all/add more args when more shapes are available
    val shapeType = try {
        Shapes.valueOf((shapeProps["shapeType"] as String).uppercase())
    } catch (e: IllegalArgumentException) {
        Shapes.SPHERE // default fallback
    }

    val args: Map<String, *> = shapeProps


    fun build(engine: Engine, material: MaterialInstance?): Node? {
        //Todo: Add type based  enum to have a uniform way to select the type in both
        // languages
        return when (shapeType) {
            Shapes.SPHERE -> {
                val radius: Float? = (args["radius"] as? Double)?.toFloat()
                return SphereNode(
                    engine, radius = radius ?: Sphere.DEFAULT_RADIUS, materialInstance = material
                )
            }

            Shapes.TORUS -> {
                val major: Float = (args["majorRadius"] as? Double)?.toFloat() ?: 0.0f
                val minor: Float = (args["minorRadius"] as? Double)?.toFloat() ?: 0.0f
                return Torus(
                    majorRadius = major,
                    minorRadius = minor,
                ).build(engine, material)
            }

            else -> null
        }
    }

}