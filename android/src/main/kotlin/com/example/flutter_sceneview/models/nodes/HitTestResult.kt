package com.example.flutter_sceneview.models.nodes

class HitTestResult(
    private val distance: Float, private val pose: Pose
) {
    fun toMap(): Map<String, Any> {
        val map = HashMap<String, Any>()
        map["distance"] = distance.toDouble()
        map["pose"] = pose.toMap()
        return map
    }
}
