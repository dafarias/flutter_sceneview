package com.snt.flutter_sceneview.utils

import io.github.sceneview.collision.Vector3
import io.github.sceneview.math.Position

class Parsers {
    companion object {
        fun parseVector3(vector: Map<String, *>?): Vector3 {
            if (vector != null) {
                val x: Float = (vector["x"] as Double).toFloat()
                val y: Float = (vector["y"] as Double).toFloat()
                val z: Float = (vector["z"] as Double).toFloat()
                return Vector3(x, y, z)
            }
            return Vector3.zero()
        }

        fun parsePosition(vector: Map<String, *>?): Position {
            if(vector != null) {
                val x: Float = (vector["x"] as Double).toFloat()
                val y: Float = (vector["y"] as Double).toFloat()
                val z: Float = (vector["z"] as Double).toFloat()
                return Position(x, y, z)
            }
            return Position(0f, 0f, 0f)
        }
    }
}