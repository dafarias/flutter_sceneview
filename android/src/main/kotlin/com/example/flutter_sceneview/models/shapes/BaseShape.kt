package com.example.flutter_sceneview.models.shapes

import com.example.flutter_sceneview.models.materials.BaseMaterial.Companion.DEFAULT
import com.google.android.filament.Engine
import com.google.android.filament.MaterialInstance
import io.github.sceneview.node.Node

abstract class BaseShape {

    abstract val shapeType: Shapes

    abstract fun toNode(engine: Engine, material: MaterialInstance?): Node

    abstract fun toMap(): Map<String, Any?>

    abstract override fun toString(): String

    companion object {
        fun fromMap(map: Map<*, *>): BaseShape? {
            if (map.isEmpty()) {
                return null
            }
            val shapeType = map["shapeType"] as? String ?: return null
            return when (Shapes.valueOf(shapeType.uppercase())) {
                Shapes.SPHERE -> Sphere.fromMap(map)
                Shapes.TORUS -> Torus.fromMap(map)
                Shapes.CUBE -> Cube.fromMap(map)
            }
        }
    }
}