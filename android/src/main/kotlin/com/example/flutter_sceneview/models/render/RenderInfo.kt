package com.example.flutter_sceneview.models.render

data class RenderInfo(
    val position: Offset,
    val size: Size,
    val pixelRatio: Double
) {
    companion object {
        fun fromMap(map: Map<String, *>): RenderInfo {
            val positionMap = map["position"] as Map<String, *>
            val sizeMap = map["size"] as Map<String, *>
            return RenderInfo(
                position = Offset(
                    (positionMap["dx"] as Number).toDouble(),
                    (positionMap["dy"] as Number).toDouble(),
                    0.0
                ),
                size = Size(
                    (sizeMap["width"] as Number).toDouble(),
                    (sizeMap["height"] as Number).toDouble()
                ),
                pixelRatio = (map["pixelRatio"] as Number).toDouble()
            )
        }
    }
}

data class Offset(val dx: Double, val dy: Double, val dz: Double = 0.0)
data class Size(val width: Double, val height: Double)