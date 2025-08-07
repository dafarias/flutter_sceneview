package com.example.flutter_sceneview.models.render

data class RenderInfo(
    val position: Offset, val size: Size, val pixelRatio: Double
) {
    companion object {
        fun fromMap(map: Map<*, *>): RenderInfo? {
            val positionMap = map["position"] as? Map<*, *>
            val sizeMap = map["size"] as? Map<*, *>

            return if (positionMap != null && sizeMap != null) {
                RenderInfo(
                    position = Offset(
                        (positionMap["dx"] as Number).toDouble(),
                        (positionMap["dy"] as Number).toDouble(),
                        0.0
                    ), size = Size(
                        (sizeMap["width"] as Number).toDouble(),
                        (sizeMap["height"] as Number).toDouble()
                    ), pixelRatio = (map["pixelRatio"] as Number).toDouble()
                )
            } else null
        }
    }
}

data class Offset(val dx: Double, val dy: Double, val dz: Double = 0.0)
data class Size(val width: Double, val height: Double)