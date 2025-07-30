package com.example.flutter_sceneview.models.shapes

import com.google.android.filament.Engine
import com.google.android.filament.MaterialInstance
import io.github.sceneview.node.Node

abstract class BaseShape {

    abstract val shapeType: Shapes

    abstract fun build(engine: Engine, material: MaterialInstance?): Node

    abstract fun toMap(): Map<String, Any?>

    companion object {
        fun fromMap(map: Map<String, Any?>): BaseShape? {
            val shapeType = map["shapeType"] as? String ?: return null
            return when (Shapes.valueOf(shapeType.uppercase())) {
                Shapes.SPHERE -> Sphere.fromMap(map)
                Shapes.TORUS -> Torus.fromMap(map)
                Shapes.CUBE -> Cube.fromMap(map)
            }
        }
    }
}