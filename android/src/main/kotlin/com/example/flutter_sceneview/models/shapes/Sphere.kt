package com.example.flutter_sceneview.models.shapes

import com.google.android.filament.Engine
import com.google.android.filament.MaterialInstance
import io.github.sceneview.node.SphereNode
import io.github.sceneview.node.Node

class Sphere(
    val radius: Float = DEFAULT_RADIUS
) : BaseShape() {

    override val shapeType = Shapes.SPHERE

    override fun build(engine: Engine, material: MaterialInstance?): Node {
        return SphereNode(
            engine,
            radius = radius,
            materialInstance = material
        )
    }

    override fun toMap(): Map<String, Any?> {
        return mapOf(
            "shapeType" to shapeType.name,
            "radius" to radius
        )
    }

    companion object {
        const val DEFAULT_RADIUS = 0.05f

        fun fromMap(map: Map<String, Any?>): Sphere {
            val radius = (map["radius"] as? Double)?.toFloat() ?: DEFAULT_RADIUS
            return Sphere(radius)
        }
    }
}
