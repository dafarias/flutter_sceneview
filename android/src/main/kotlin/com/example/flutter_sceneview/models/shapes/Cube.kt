package com.example.flutter_sceneview.models.shapes

import android.util.Log
import com.google.android.filament.Engine
import com.google.android.filament.MaterialInstance
import io.github.sceneview.math.Position
import io.github.sceneview.math.Size
import io.github.sceneview.node.CubeNode
import io.github.sceneview.node.Node

class Cube(
    val size: Size = DEFAULT_SIZE, val center: Position = DEFAULT_CENTER
) : BaseShape() {

    override val shapeType = Shapes.CUBE


    override fun toNode(engine: Engine, material: MaterialInstance?): Node {
        return CubeNode(
            engine = engine, size = size, center = center, materialInstance = material
        )
    }

    override fun toMap(): Map<String, Any?> {
        return mapOf(
            "shapeType" to shapeType.name.lowercase(),

            //Fix return types for cube on Dart side
            "size" to listOf(size.x, size.y, size.z),
            "center" to listOf(center.x, center.y, center.z)
        )
    }

    override fun toString(): String {
        return "BaseShape: ${this.shapeType.name}"
    }

    companion object {
        val DEFAULT_SIZE = Size(0.1f, 0.1f, 0.1f) // default 10cm cube
        val DEFAULT_CENTER = Position(0.0f, 0.0f, 0.0f)

        fun fromMap(map: Map<*, *>): Cube? {
            try {
                val sizeList = (map["size"] as? List<*>)?.mapNotNull { (it as? Number)?.toFloat() }
                val size = if (sizeList != null && sizeList.size == 3) {
                    Size(sizeList[0], sizeList[1], sizeList[2])
                } else {
                    DEFAULT_SIZE
                }

                val centerList =
                    (map["center"] as? List<*>)?.mapNotNull { (it as? Number)?.toFloat() }
                val center = if (centerList != null && centerList.size == 3) {
                    Position(centerList[0], centerList[1], centerList[2])
                } else {
                    DEFAULT_CENTER
                }

                return Cube(size, center)

            } catch (e: Exception) {
                Log.e(
                    toString(), "Failed to deserialize json object: ${e.cause}"
                )
                return null
            }

        }
    }

}
