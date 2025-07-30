package com.example.flutter_sceneview.models.shapes

import com.google.android.filament.Engine
import com.google.android.filament.MaterialInstance
import io.github.sceneview.geometries.Geometry
import io.github.sceneview.math.Position
import io.github.sceneview.math.Size
import io.github.sceneview.node.CubeNode
import io.github.sceneview.node.Node



class Cube(
    val size: Size = DEFAULT_SIZE,
    val center: Position = DEFAULT_CENTER
) : BaseShape() {

    override val shapeType = Shapes.CUBE


    override fun build(engine: Engine, material: MaterialInstance?): Node {
        return CubeNode(
            engine = engine,
            size = size,
            center = center,
            materialInstance = material
        )
    }

    override fun toMap(): Map<String, Any?> {
        return mapOf(
            "shapeType" to shapeType.name,
            "size" to listOf(size.x, size.y, size.z),
            "center" to listOf(center.x, center.y, center.z)
        )
    }

    companion object {
        val DEFAULT_SIZE = Size(0.1f, 0.1f, 0.1f) // default 10cm cube
        val DEFAULT_CENTER = Position(0.0f, 0.0f, 0.0f)

        fun fromMap(map: Map<String, Any?>): Cube {
            val sizeList = map["size"] as? List<Double>
            val size = if (sizeList != null && sizeList.size == 3) {
                Size(sizeList[0].toFloat(), sizeList[1].toFloat(), sizeList[2].toFloat())
            } else {
                DEFAULT_SIZE
            }

            val centerList = map["center"] as? List<Double>
            val center = if (centerList != null && centerList.size == 3) {
                Position(centerList[0].toFloat(), centerList[1].toFloat(), centerList[2].toFloat())
            } else {
                DEFAULT_CENTER
            }

            return Cube(size, center)
        }
    }

}
