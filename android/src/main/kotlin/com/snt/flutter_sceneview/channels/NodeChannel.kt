package com.snt.flutter_sceneview.channels

import android.content.Context
import android.util.Log
import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.LifecycleOwner
import com.snt.flutter_sceneview.logs.NodeError
import com.snt.flutter_sceneview.models.render.RenderInfo
import com.snt.flutter_sceneview.utils.AssetLoader
import com.snt.flutter_sceneview.utils.BitmapUtils
import com.snt.flutter_sceneview.utils.Channels
import com.snt.flutter_sceneview.utils.findNodeByName
import com.google.ar.core.HitResult
import com.google.ar.core.Plane
import com.google.ar.core.TrackingState
import com.snt.flutter_sceneview.models.nodes.HitTestResult
import com.snt.flutter_sceneview.models.nodes.ModelConfig
import com.snt.flutter_sceneview.models.nodes.NodeType
import com.snt.flutter_sceneview.models.nodes.Pose
import com.snt.flutter_sceneview.models.nodes.SceneNode
import com.snt.flutter_sceneview.models.nodes.ShapeConfig
import com.snt.flutter_sceneview.models.nodes.TextConfig
import dev.romainguy.kotlin.math.Float3
import dev.romainguy.kotlin.math.Quaternion
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterAssets
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.github.sceneview.ar.ARSceneView
import io.github.sceneview.ar.arcore.createAnchorOrNull
import io.github.sceneview.ar.arcore.position
import io.github.sceneview.ar.arcore.quaternion
import io.github.sceneview.ar.arcore.rotation
import io.github.sceneview.ar.node.AnchorNode
import io.github.sceneview.math.Position
import io.github.sceneview.math.Transform
import io.github.sceneview.model.Model
import io.github.sceneview.node.ImageNode
import io.github.sceneview.node.ModelNode
import io.github.sceneview.node.Node
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import kotlin.collections.get

class NodeChannel(
    private val context: Context,
    private val flutterAssets: FlutterAssets,
    private val mainScope: CoroutineScope,
    private val messenger: BinaryMessenger,
    private val sceneView: ARSceneView

) : MethodCallHandler, DefaultLifecycleObserver {

    companion object {
        private const val TAG = "NodeChannel"
    }

    private val _channel = MethodChannel(messenger, Channels.Companion.NODE)
    private val preloadedModels = mutableMapOf<String, Model>()
    private val bitmapUtils = BitmapUtils(context, flutterAssets)
    private val assetLoader = AssetLoader(context, flutterAssets)
    private val modelLoader = sceneView.modelLoader
    private val materialLoader = sceneView.materialLoader
    private val engine = sceneView.engine

    init {
        _channel.setMethodCallHandler(this)
        sceneView.lifecycle?.addObserver(this)
    }

    override fun onDestroy(owner: LifecycleOwner) {
        Log.i(TAG, "onDestroy")
        dispose()
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "addNode" -> mainScope.launch { onAddNode(call.arguments as Map<*, *>, result) }
            "addChildNode" -> mainScope.launch {
                addChildNode(call.arguments as Map<*, *>, result)
            }

            "addChildNodes" -> mainScope.launch {
                addChildNodes(call.arguments as Map<*, *>, result)
            }

            "removeNode" -> mainScope.launch { removeNode(call.arguments as Map<*, *>, result) }
            "removeAllNodes" -> mainScope.launch { removeAllNodes(result) }
            "getAllNodes" -> {
                getAllNodes(result)
            }

            "createAnchorNode" -> mainScope.launch {
                createAnchorNode(
                    call.arguments as Map<*, *>, result
                )
            }

            "detachAnchor" -> mainScope.launch { detachAnchor(call.arguments as Map<*, *>, result) }
            "hitTest" -> mainScope.launch { hitTest(call.arguments as Map<*, *>, result) }

            "dispose" -> {
                dispose()
                result.success(true)
                return
            }

            else -> result.notImplemented()
        }
    }

    private fun dispose() {
        _channel.setMethodCallHandler(null)
        sceneView.lifecycle?.removeObserver(this)
        // Clears cache to free memory
        preloadedModels.clear()
        // Unregister any other listeners or resources
        Log.i(TAG, "NodeChannel disposed")
    }


    private suspend fun onAddNode(args: Map<*, *>, result: MethodChannel.Result) {
        // Adds node to the scene as direct child of it
        val nodeMap = (args["node"] as? Map<*, *>)
        if (sceneView.cameraNode.trackingState != TrackingState.TRACKING) {
            val message = NodeError.AddNodeNotTracking.format()
            Log.w(TAG, message)
            return result.error(NodeError.AddNodeNotTracking.code, message, null)
        }

        val sceneNode = SceneNode.Companion.fromMap(nodeMap!!) ?: run {
            val message = NodeError.NodeInvalidData.format()
            Log.e(TAG, message)
            return result.error(NodeError.NodeInvalidData.code, message, null)
        }

        val node = buildNativeNode(sceneNode) ?: run {
            var error = NodeError.NodeInstanceCreationFailed
            val message = error.format(sceneNode)
            Log.e(TAG, message)
            return result.error(error.code, message, null)
        }

        sceneView.addChildNode(node)

        sceneNode.apply {
            position = node.worldPosition
            rotation = node.rotation
            scale = node.scale
            isPlaced = true
        }

        result.success(sceneNode.toMap())
    }

    @Deprecated("Preserve to use the error messages to improve the buildNativeNode")
    private suspend fun addShapeNode(args: Map<*, *>, result: MethodChannel.Result) {
        val nodeMap = (args["node"] as? Map<*, *>)
        val sceneNode = SceneNode.Companion.fromMap(nodeMap!!) ?: run {
            val message = NodeError.NodeInvalidShape.format()
            Log.e(TAG, message)
            return result.error(NodeError.NodeInvalidShape.code, message, null)
        }

        val node = buildNativeNode(sceneNode) ?: run {
            val message = NodeError.NodeInstanceCreationFailed.format(sceneNode)
            Log.e(TAG, message)
            return result.error(NodeError.PlacementFailed.code, message, null)
        }
    }

    @Deprecated("Preserve to use the error messages to improve the buildNativeNode")
    private fun addTextNode(args: Map<*, *>, result: MethodChannel.Result) {
        val nodeMap = (args["node"] as? Map<*, *>)
        val sceneNode = SceneNode.Companion.fromMap(nodeMap!!) ?: run {
            val message = NodeError.NodeInvalidData.format()
            Log.e(TAG, message)
            return result.error(NodeError.NodeInvalidData.code, message, null)
        }

        val textConfig = sceneNode.config as? TextConfig ?: run {
            val message = NodeError.NodeInvalidData.format()
            Log.e(TAG, message)
            return result.error(NodeError.NodeInvalidData.code, message, null)
        }

        if (textConfig.text == null) {
            val message = NodeError.TextNodeMissingText.format()
            Log.e(TAG, message)
            return result.error(NodeError.TextNodeMissingText.code, message, null)
        }

    }

    private suspend fun addChildNode(args: Map<*, *>, result: MethodChannel.Result) {
        try {
            val childMap = (args["child"] as? Map<*, *>)
            val parentId = (args["parentId"] as? String)

            if (childMap != null && parentId != null) {
                val child = SceneNode.Companion.fromMap(childMap) ?: run {
                    val message = NodeError.NodeInvalidData.format()
                    Log.e(TAG, message)
                    return result.error(NodeError.NodeInvalidData.code, message, null)
                }

                sceneView.findNodeByName(parentId)?.let { parent ->
                    buildNativeNode(child)?.let { nativeNode ->
                        parent.addChildNode(nativeNode)
                        child.parentId = parentId
                        child.isPlaced = true
                        child.position = nativeNode.worldPosition
                        child.rotation = nativeNode.rotation
                        child.scale = nativeNode.scale
                        nativeNode
                    } ?: run {
                        val message = NodeError.NodeInstanceCreationFailed.format(child)
                        Log.e(TAG, message)
                        return result.error(
                            NodeError.NodeInstanceCreationFailed.code, message, null
                        )
                    }

                    return result.success(child.toMap())
                }
                return result.error(
                    NodeError.NodeNotFound(parentId).code, "Parent node '$parentId' not found", null
                )
            } else {
                return result.error("CHILD_NOT_ADDED", "Child data or parent ID is invalid", null)
            }

        } catch (e: Exception) {
            val message = NodeError.RemoveAllFailed.format(e.message ?: "unknown")
            Log.e(TAG, message)
            result.error(NodeError.RemoveAllFailed.code, message, null)
        }

    }


    private suspend fun addChildNodes(args: Map<*, *>, result: MethodChannel.Result) {
        try {
            val children = (args["children"] as? List<*>)
            val parentId = (args["parentId"] as? String) ?: run {
                val message = NodeError.InvalidParentId.format()
                Log.e(TAG, message)
                return result.error(NodeError.InvalidParentId.code, message, null)
            }

            if (children != null) {
                val updatedSceneNodes = mutableListOf<SceneNode>()
                val nativeNodes = mutableSetOf<Node>()

                val parent = sceneView.findNodeByName(parentId) ?: run {
                    val message = NodeError.NodeNotFound(parentId).format(parentId)
                    Log.e(TAG, message)
                    return result.error(NodeError.NodeNotFound(parentId).code, message, null)
                }

                val sceneNodes = children.mapNotNull {
                    val child = SceneNode.Companion.fromMap(it as Map<*, *>) ?: run {
                        val message = NodeError.NodeInvalidData.format()
                        Log.e(TAG, message)
                        return result.error(NodeError.NodeInvalidData.code, message, null)
                    }
                    child
                }.toList()

                if (sceneNodes.isEmpty()) {
                    return result.error("CHILDREN_NOT_ADDED", "No valid children to add", null)
                }

                sceneNodes.forEach { child ->
                    val nativeNode = buildNativeNode(child)
                    if (nativeNode != null) {
                        nativeNodes.add(nativeNode)
                    } else {
                        Log.e(TAG, "Failed to build native node for child: ${child.nodeId}")
                    }
                }

                if (nativeNodes.isNotEmpty()) {
                    parent.addChildNodes(nativeNodes)
                    // Updates SceneNodes after successfully adding nodes
                    nativeNodes.forEach { nativeNode ->
                        val child = sceneNodes.find { it.nodeId == nativeNode.name }
                        child?.let {
                            it.parentId = parentId
                            it.isPlaced = true
                            it.position = nativeNode.worldPosition
                            it.rotation = nativeNode.rotation
                            it.scale = nativeNode.scale
                            updatedSceneNodes.add(it)
                        }
                    }
                }

                return if (updatedSceneNodes.isNotEmpty()) {
                    result.success(updatedSceneNodes.map { it.toMap() })
                } else {
                    val message = NodeError.FailedAddingChildren.format(parentId)
                    Log.w(TAG, message)
                    result.error(NodeError.FailedAddingChildren.code, message, null)
                }
            }

        } catch (e: Exception) {
            val message = NodeError.RemoveAllFailed.format(e.message ?: "unknown")
            Log.e(TAG, message)
            return result.error(NodeError.RemoveAllFailed.code, message, null)
        }

    }


    private suspend fun createAnchorNode(args: Map<*, *>, result: MethodChannel.Result) {
        try {
            var x = (args["x"] as? Double)?.toFloat()
            var y = (args["y"] as? Double)?.toFloat()
            var normalize = (args["normalize"]) as? Boolean == true
            var px = 0.0f
            var py = 0.0f

            val sceneNode = SceneNode.Companion.fromMap((args["node"] as? Map<*, *>)!!) ?: run {
                val message = NodeError.NodeInvalidData.format()
                Log.e(TAG, message)
                return result.error(NodeError.NodeInvalidData.code, message, null)
            }

            if (x == null || y == null) {
                val message = NodeError.InvalidCoordinates(x, y).format()
                Log.w(TAG, message)
                return result.success(false)
            }

            if (normalize) {
                val renderInfo = RenderInfo.Companion.fromMap((args["renderInfo"] as? Map<*, *>)!!)
                var (normalX, normalY) = normalizeToPhysical(x, y, renderInfo) ?: run {
                    val message = NodeError.NormalizationFailed.format()
                    Log.e(TAG, message)
                    return result.error(NodeError.NormalizationFailed.code, message, null)
                }
                px = normalX
                py = normalY
            }

            val node = buildNativeNode(sceneNode)

            val (xPx, yPx) = if (normalize == true) px to py else x to y
            val hitResult = hitTestWithAR(xPx, yPx)?.createAnchorOrNull()

            if (node != null && hitResult != null) {
                val anchor = AnchorNode(engine, hitResult)
                anchor.apply {
                    name = sceneNode.parentId
                }

                node.apply {
                    parent = anchor
                    position = Position(0f, 0f, 0f) // Aligns with the anchor
                    worldPosition =
                        Position(hitResult.pose.tx(), hitResult.pose.ty(), hitResult.pose.tz())
                }
                anchor.addChildNode(node)
                sceneView.addChildNode(anchor)

            } else {
                val message = NodeError.NoSurfaceFound.format(x, y)
                Log.e(TAG, message)
                return result.error(NodeError.NoSurfaceFound.code, message, null)

            }

            sceneNode.apply {
                position = node.worldPosition
                scale = node.scale
                rotation = node.rotation
                isPlaced = true
            }

            result.success(sceneNode.toMap())

        } catch (e: Exception) {
            Log.w(TAG, e.toString())
            result.error("ANCHOR_ERROR", "Failed to create anchor", null)
        }

    }


    private fun removeNode(args: Map<*, *>, result: MethodChannel.Result) {
        val nodeId = args["nodeId"] as? String ?: ""
        try {
            val targetNode = sceneView.findNodeByName(nodeId)
            if (targetNode != null) {
                targetNode.parent?.removeChildNode(targetNode)
                if (targetNode is AnchorNode) {
                    targetNode.destroy()
                }
                Log.d(TAG, "Node with id $nodeId removed successfully from the scene")
                result.success(true)
            } else {
                val message = NodeError.NodeNotFound(nodeId).format()
                Log.w(TAG, message)
                result.success(false)
            }
        } catch (e: Exception) {
            val message = NodeError.RemoveFailed.format(nodeId, e.message ?: "unknown")
            Log.e(TAG, message)
            result.error(NodeError.RemoveFailed.code, message, null)
        }
    }


    private fun removeAllNodes(result: MethodChannel.Result) {
        try {
            sceneView.clearChildNodes()
            result.success(true)
        } catch (e: Exception) {
            val message = NodeError.RemoveAllFailed.format(e.message ?: "unknown")
            Log.e(TAG, message)
            result.error(NodeError.RemoveAllFailed.code, message, null)
        }
    }

    private fun getAllNodes(result: MethodChannel.Result) {
        try {
            //TODO: Special recreation of the nodes to send them back. Needs to be looked at
            val nodes = sceneView.childNodes.map { node ->
                SceneNode(
                    nodeId = node.name!!,
                    position = node.position,
                    rotation = node.rotation,
                    scale = node.scale,
                    type = NodeType.UNKNOWN,
                    config = ModelConfig()
                )
            }

            val nodesList = ArrayList(nodes.map { it.toMap() })

            result.success(nodesList)
        } catch (e: Exception) {
            Log.e(TAG, "Failed to retrieve all nodes from the scene")
            result.error(
                "GET_ALL_NODES_ERROR", e.message ?: "Unknown error", e.stackTraceToString()
            )
        }
    }


    fun transformNode(node: Node?) {
        try {
            node?.transform(
                Transform(
                    position = node.position,
                    quaternion = Quaternion.fromAxisAngle(Float3(1.0f, 0.0f, 0.0f), 90f),
                    scale = node.scale
                )
            )
        } catch (e: Exception) {
            Log.e(TAG, "Failed to transform node with: ${e.message}")
        }
    }


    private suspend fun buildNativeNode(sceneNode: SceneNode): Node? {
        //TODO: Add better error handling so we can know the exact reason why a build failed
        var node = when (sceneNode.type) {
            NodeType.MODEL -> {
                val modelConfig = sceneNode.config as? ModelConfig ?: return null
                val default = modelConfig.loadDefault == true
                val fileName = if (default) assetLoader.defaultModel else modelConfig.fileName ?: ""

                val model =
                    preloadedModels[fileName] ?: loadModelFrom(fileName, default) ?: return null

                preloadedModels[fileName] = model
                ModelNode(
                    modelInstance = modelLoader.createInstance(model) ?: return null,
                    scaleToUnits = 0.5f
                )
            }

            NodeType.SHAPE -> {
                val shapeConfig = sceneNode.config as? ShapeConfig ?: return null
                val material = shapeConfig.material ?: return null
                val materialInstance = materialLoader.createColorInstance(
                    color = material.color,
                    metallic = material.metallic,
                    roughness = material.roughness,
                    reflectance = material.reflectance,
                )
                shapeConfig.shape?.toNode(engine, materialInstance)
            }

            NodeType.TEXT -> {
                val textConfig = sceneNode.config as? TextConfig ?: return null
                val text = textConfig.text ?: return null
                val textBitmap = bitmapUtils.createTextBitmap(
                    text = text,
                    fontFamily = textConfig.fontFamily,
                    textColor = textConfig.textColor
                )
                val aspectRatio = textBitmap.height.toFloat() / textBitmap.width.toFloat()
                val heightMeters = textConfig.size * aspectRatio
                ImageNode(
                    materialLoader = materialLoader,
                    bitmap = textBitmap,
                    size = Float3(textConfig.size, heightMeters, 0f),
                    center = Position(0f, 0f, 0f)
                )
            }

            else -> {
                return null
            }
        }

        node?.apply {
            name = sceneNode.nodeId
            position = sceneNode.position
            rotation = sceneNode.rotation ?: rotation
            scale = sceneNode.scale ?: scale
        }
        return node
    }


    private suspend fun loadModelFrom(fileName: String?, loadDefault: Boolean = false): Model? =
        withContext(Dispatchers.IO) {
            val assetPath = assetLoader.resolveAssetPath(fileName, loadDefault)
            modelLoader.loadModel(assetPath)
        }


    private fun detachAnchor(args: Map<*, *>, result: MethodChannel.Result) {
        try {
            val anchorId = args["anchorId"] as? String
            if (anchorId.isNullOrEmpty()) {
                return result.error(
                    "DETACH_ANCHOR", "Anchor id is not valid. Null or empty: $anchorId", null
                )
            }

            sceneView.findNodeByName(anchorId)?.let {
                if (it is AnchorNode) {
                    sceneView.removeChildNode(it)
                    it.destroy()
                }
                return result.success(true)
            }

        } catch (e: Exception) {
            Log.e(TAG, "Failed to detach and destroy anchor")
            return result.error("DETACH_ANCHOR", e.message, null)
        }

    }


    private fun hitTestWithAR(xPx: Float, yPx: Float): HitResult? {
        try {
            return sceneView.hitTestAR(
                xPx = xPx,
                yPx = yPx,
                point = true,
                planeTypes = setOf(Plane.Type.HORIZONTAL_UPWARD_FACING, Plane.Type.VERTICAL)
            )
        } catch (e: Exception) {
            Log.e(TAG, "Failed to hit test ")
            return null
        }
    }


    fun hitTest(args: Map<*, *>, result: MethodChannel.Result) {
        try {
            var x = (args["x"] as? Double)?.toFloat()
            var y = (args["y"] as? Double)?.toFloat()
            var normalize = (args["normalize"]) as? Boolean == true
            var withFrame = (args["withFrame"]) as? Boolean == true
            var px = 0.0f
            var py = 0.0f

            if (x == null || y == null) {
                val message = NodeError.InvalidCoordinates(x, y).format()
                Log.w(TAG, message)
                return result.success(false)
            }

            if (normalize) {
                val renderInfo = RenderInfo.Companion.fromMap((args["renderInfo"] as? Map<*, *>)!!)
                var (normalX, normalY) = normalizeToPhysical(x, y, renderInfo) ?: run {
                    val message = NodeError.NormalizationFailed.format()
                    Log.e(TAG, message)
                    return result.error(NodeError.NormalizationFailed.code, message, null)
                }
                px = normalX
                py = normalY
            }

            val (xPx, yPx) = if (normalize == true) px to py else x to y
            val list = ArrayList<Map<String, Any>>()
            if (withFrame) {
                val frame = sceneView.frame
                if (frame != null) {
                    if (frame.camera.trackingState == TrackingState.TRACKING) {
                        val hitList = frame.hitTest(xPx, yPx)
                        for (hit in hitList) {
                            val trackable = hit.trackable
                            if (trackable is Plane && trackable.isPoseInPolygon(hit.hitPose)) {
                                hit.hitPose.position
                                print(hit.hitPose.translation)
                                // Translation is the same as Position
                                list.add(
                                    HitTestResult(
                                        hit.distance, Pose(
                                            hit.hitPose.position,
                                            hit.hitPose.rotation,
                                            hit.hitPose.quaternion
                                        )
                                    ).toMap()
                                )
                            }
                        }

                    }
                    return result.success(list)
                    Log.i("HitTestResult", "$list")
                }
            } else {
                val hitResult = hitTestWithAR(xPx, yPx)
                if (hitResult != null) {
                    list.add(
                        HitTestResult(
                            hitResult.distance, Pose(
                                hitResult.hitPose.position,
                                hitResult.hitPose.rotation,
                                hitResult.hitPose.quaternion
                            )
                        ).toMap()
                    )
                    return result.success(list)
                }

            }

        } catch (e: Exception) {
            Log.e(TAG, "Failed to hit test the scene ${e.message}")
            result.error("HIT_TEST_ERROR", e.message, null)
        }

        return result.success(ArrayList<Map<String, Any>>())
    }


    private fun normalizeToPhysical(
        x: Float, y: Float, renderInfo: RenderInfo?
    ): Pair<Float, Float>? {
        return if (renderInfo != null) {
            val pixelRatio = renderInfo.pixelRatio.toFloat()

            val adjustedX = (x * pixelRatio)
            val adjustedY = (y * pixelRatio)

            val adjustedPosX = (renderInfo.position.dx * pixelRatio).toFloat()
            val adjustedPosY = (renderInfo.position.dy * pixelRatio).toFloat()

            val adjustedWidth = (renderInfo.size.width * pixelRatio).toFloat()
            val adjustedHeight = (renderInfo.size.height * pixelRatio).toFloat()

            val localX = ((adjustedX - adjustedPosX) / adjustedWidth).coerceIn(0f, 1f)
            val localY = ((adjustedY - adjustedPosY) / adjustedHeight).coerceIn(0f, 1f)

            return Pair((localX * sceneView.width).toFloat(), (localY * sceneView.height).toFloat())
        } else null
    }

}

