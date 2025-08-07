package com.example.flutter_sceneview.models.shapes

import android.util.Log
import com.example.flutter_sceneview.models.shapes.Torus.Companion.DEFAULT_MAJOR_RADIUS
import com.example.flutter_sceneview.models.shapes.Torus.Companion.DEFAULT_MINOR_RADIUS
import com.google.android.filament.Engine
import com.google.android.filament.MaterialInstance
import io.github.sceneview.node.SphereNode
import io.github.sceneview.node.Node

class Sphere(
    val radius: Float = DEFAULT_RADIUS
) : BaseShape() {

    override val shapeType = Shapes.SPHERE

    override fun toString(): String {
        return "BaseShape: ${shapeType.name}"
    }

    override fun toNode(engine: Engine, material: MaterialInstance?): Node {
        return SphereNode(
            engine, radius = radius, materialInstance = material
        )
    }

    override fun toMap(): Map<String, Any?> {
        return mapOf(
            "shapeType" to shapeType.name, "radius" to radius
        )
    }

    companion object {
        const val DEFAULT_RADIUS = 0.05f

        fun fromMap(map: Map<*, *>): Sphere? {
            try {
                val radius = (map["radius"] as? Double)?.toFloat() ?: DEFAULT_RADIUS
                return Sphere(radius)
            } catch (e: Exception) {
                Log.e(
                    toString(), "Failed to deserialize json object: ${e.cause}"
                )
                return null
            }

        }
    }
}
