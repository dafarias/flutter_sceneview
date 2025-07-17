package com.example.flutter_sceneview.result

import com.example.flutter_sceneview.models.nodes.NodeInfo

sealed interface BaseResult;

sealed interface NodeResult : BaseResult {
    data class Placed(val node: NodeInfo,) : NodeResult
    data class Failed(val reason: String) : NodeResult
}
sealed interface ARResult : BaseResult {
    data class Hits(val hitResult: ArrayList<Map<String, Any>>) : ARResult
    data class Error(val reason: String) : ARResult
}

sealed interface SessionResult : BaseResult {
    data class Active(val sessionId: String) : SessionResult
    data class Inactive(val reason: String) : SessionResult
}

data class GenericError(val code: String, val message: String) : BaseResult
