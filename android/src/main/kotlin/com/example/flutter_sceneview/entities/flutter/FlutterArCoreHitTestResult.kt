package com.example.flutter_sceneview.entities.flutter

class FlutterArCoreHitTestResult(
    private val distance: Float,
    private val translation: FloatArray,
    private val rotation: FloatArray
) {
    fun toMap(): Map<String, Any> {
        val map = HashMap<String, Any>()
        map["distance"] = distance.toDouble()
        map["pose"] = FlutterArCorePose(translation, rotation).toMap()
        return map
    }
}