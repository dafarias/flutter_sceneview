package com.example.flutter_sceneview.models.shapes

import android.util.Log
import com.example.flutter_sceneview.models.shapes.Cube.Companion.DEFAULT_CENTER
import com.example.flutter_sceneview.models.shapes.Cube.Companion.DEFAULT_SIZE
import com.google.android.filament.Engine
import com.google.android.filament.MaterialInstance
import dev.romainguy.kotlin.math.Float3
import io.github.sceneview.geometries.Geometry
import io.github.sceneview.node.GeometryNode
import io.github.sceneview.node.Node
import kotlin.math.cos
import kotlin.math.sin
import io.github.sceneview.math.Position
import kotlin.math.sqrt


class Torus(
    val majorRadius: Float = DEFAULT_MAJOR_RADIUS, val minorRadius: Float = DEFAULT_MINOR_RADIUS
) : BaseShape() {

    override val shapeType = Shapes.TORUS

    override fun toString(): String {
        return "BaseShape: ${this.shapeType.name}"
    }

    override fun toNode(engine: Engine, material: MaterialInstance?): Node {
        return createTorusNode(
            engine,
            majorRadius = majorRadius,
            minorRadius = minorRadius,
            materialInstance = material
        )
    }

    override fun toMap(): Map<String, Any?> {
        return mapOf(
            "shapeType" to shapeType.name,
            "majorRadius" to majorRadius,
            "minorRadius" to minorRadius
        )
    }

    companion object {
        const val DEFAULT_MAJOR_RADIUS = 0.1f
        const val DEFAULT_MINOR_RADIUS = 0.03f

        fun fromMap(map: Map<*, *>): Torus? {
            try {
                val major = (map["majorRadius"] as? Double)?.toFloat() ?: DEFAULT_MAJOR_RADIUS
                val minor = (map["minorRadius"] as? Double)?.toFloat() ?: DEFAULT_MINOR_RADIUS
                return Torus(major, minor)
            } catch (e: Exception) {
                Log.e(
                    toString(), "Failed to deserialize json object: ${e.cause}"
                )
                return null
            }
        }
    }

    //TODO: Rename maybe the build method to: toNode for example, or buildNode
    fun createTorusNode(
        engine: Engine,
        majorRadius: Float = 0.5f,
        minorRadius: Float = 0.2f,
        segmentsU: Int = 64,
        segmentsV: Int = 128,
        materialInstance: MaterialInstance?
    ): GeometryNode {
        val vertices = mutableListOf<Geometry.Vertex>()
        val indices = mutableListOf<Int>()

        // Generate vertices
        for (i in 0 until segmentsU) {
            val u = (i.toFloat() / segmentsU) * (2 * Math.PI).toFloat()
            val cosU = cos(u)
            val sinU = sin(u)

            for (j in 0 until segmentsV) {
                val v = (j.toFloat() / segmentsV) * (2 * Math.PI).toFloat()
                val cosV = cos(v)
                val sinV = sin(v)

                // Modify axes to align torus normal along +Y
                val x = (majorRadius + minorRadius * cosV) * cosU
                val y = minorRadius * sinV // vertical variation now on Y
                val z = (majorRadius + minorRadius * cosV) * sinU

                // Normal calculation (approximate)
                var nx = cosU * cosV
                var ny = sinV
                var nz = sinU * cosV

//                 Normalize the normal vector
                val length = sqrt(nx * nx + ny * ny + nz * nz)
                if (length != 0f) {
                    nx /= length
                    ny /= length
                    nz /= length
                }

                vertices.add(
                    Geometry.Vertex(
                        position = Position(x, y, z), normal = Position(nx, ny, nz)
                    )
                )
            }
        }

        // Generate indices (same as before)
        for (i in 0 until segmentsU) {
            val iNext = (i + 1) % segmentsU
            for (j in 0 until segmentsV) {
                val jNext = (j + 1) % segmentsV

                val a = i * segmentsV + j
                val b = iNext * segmentsV + j
                val c = iNext * segmentsV + jNext
                val d = i * segmentsV + jNext

                // Triangle 1
                indices.addAll(listOf(a, b, c))
                // Triangle 2
                indices.addAll(listOf(a, c, d))
            }
        }

        val geometry = Geometry.Builder().vertices(vertices)
            .indices(indices) // fix indices type here if needed
            .build(engine)

        return GeometryNode(
            engine = engine, geometry = geometry, materialInstance = materialInstance
        )
    }

}
