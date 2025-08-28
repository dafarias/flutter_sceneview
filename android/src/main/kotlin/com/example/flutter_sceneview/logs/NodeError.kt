package com.example.flutter_sceneview.logs

sealed class NodeError(val code: String, open val defaultMessage: String) {
    fun format(vararg args: Any): String = defaultMessage.format(*args)

    // AddNode errors
    object AddNodeNotTracking : NodeError("ADD_NODE_CAMERA_NOT_TRACKING", "Camera not tracking — can't perform hit test yet.")
    data class InvalidCoordinates(val x: Float?, val y: Float?) : NodeError("INVALID_COORDINATES", "Missing or invalid coordinates x=%.2f, y=%.2f")
    object NoSurfaceFound : NodeError("NO_SURFACE_FOUND", "No AR surface found at screen coordinates x=%.2f, y=%.2f")
    data class ModelLoadFailed(val fileName: String, val cause: String?) : NodeError("MODEL_LOAD_FAILED", "Failed to load model %s: %s")
    object NodeInstanceCreationFailed : NodeError("NODE_INSTANCE_CREATION_FAILED", "Failed to create instance for %s")

    // AddShapeNode errors
    object NodeInvalidMaterial : NodeError("INVALID_MATERIAL", "Invalid material provided.")
    object NodeInvalidShape : NodeError("INVALID_SHAPE", "Invalid shape data.")
    object PlacementFailed : NodeError("PLACEMENT_FAILED", "Could not place node: %s")

    object NodeInvalidData : NodeError("NODE_INVALID_DATA", "Invalid node data.")
    object TextNodeMissingText : NodeError("TEXT_NODE_NO_TEXT", "No text provided.")

    // RemoveNode errors
    data class NodeNotFound(val nodeId: String) : NodeError("NODE_NOT_FOUND", "Node with id %s not found.")
    object RemoveFailed : NodeError("REMOVE_FAILED", "Failed to remove node with id: %s. %s")

    // RemoveAllNodes errors
    object RemoveAllFailed : NodeError("REMOVE_ALL_FAILED", "Failed to remove all nodes from the scene: %s")
}