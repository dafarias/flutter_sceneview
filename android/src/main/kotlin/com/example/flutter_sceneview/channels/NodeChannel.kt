package com.example.flutter_sceneview.channels

import android.content.Context
import android.util.Log
import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.LifecycleOwner
import com.example.flutter_sceneview.logs.NodeError
import com.example.flutter_sceneview.models.nodes.*
import com.example.flutter_sceneview.models.render.RenderInfo
import com.example.flutter_sceneview.utils.AssetLoader
import com.example.flutter_sceneview.utils.BitmapUtils
import com.example.flutter_sceneview.utils.Channels
import com.google.ar.core.Plane
import com.google.ar.core.TrackingState
import dev.romainguy.kotlin.math.Float3
import dev.romainguy.kotlin.math.Quaternion
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterAssets
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.github.sceneview.ar.ARSceneView
import io.github.sceneview.ar.arcore.createAnchorOrNull
import io.github.sceneview.ar.arcore.rotation
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

    private val _channel = MethodChannel(messenger, Channels.NODE)
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
        _channel.setMethodCallHandler(null)
        sceneView.lifecycle?.removeObserver(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "addNode" -> mainScope.launch { onAddNode(call.arguments as Map<*, *>, result) }
            "addShapeNode" -> mainScope.launch { addShapeNode(call.arguments as Map<*, *>, result) }
            "addTextNode" -> mainScope.launch { addTextNode(call.arguments as Map<*, *>, result) }
            "removeNode" -> mainScope.launch { removeNode(call.arguments as Map<*, *>, result) }
            "removeAllNodes" -> mainScope.launch { removeAllNodes(result) }
            else -> result.notImplemented()
        }
    }

    private suspend fun onAddNode(args: Map<*, *>, result: MethodChannel.Result) {
        if (sceneView.cameraNode.trackingState != TrackingState.TRACKING) {
            val message = NodeError.AddNodeNotTracking.format()
            Log.w(TAG, message)
            return result.error(NodeError.AddNodeNotTracking.code, message, null)
        }

        val sceneNode = SceneNode.fromMap(args) ?: run {
            val message =  NodeError.NodeInvalidData.format()
            Log.e(TAG, message)
            return result.error(NodeError.NodeInvalidData.code, message, null)
        }

        val node = buildNativeNode(sceneNode) ?: run {
            var error = NodeError.ModelLoadFailed((sceneNode.config as ModelConfig).fileName!!, null)
            val message = error.format(sceneNode.config)
            Log.e(TAG, message)
            return result.error(error.code, message, null)
        }

        val hitResultAnchor = sceneView.hitTestAR(
            xPx = sceneNode.position.x,
            yPx = sceneNode.position.y,
            point = true,
            planeTypes = setOf(Plane.Type.HORIZONTAL_UPWARD_FACING, Plane.Type.VERTICAL)
        )?.createAnchorOrNull()

        if (hitResultAnchor == null) {
            val message = NodeError.NoSurfaceFound.format(sceneNode.position.x, sceneNode.position.y)
            Log.e(TAG, message)
            return result.error(NodeError.NoSurfaceFound.code, message, null)
        }

        node.position = Position(hitResultAnchor.pose.tx(), hitResultAnchor.pose.ty(), hitResultAnchor.pose.tz())
        node.name = sceneNode.nodeId
        sceneView.addChildNode(node)

        Log.i(TAG, "Node ${node.name} placed successfully")
        val nodeInfo = NodeInfo(
            nodeId = node.name!!,
            position = node.position,
            rotation = hitResultAnchor.pose.rotation,
            scale = node.scale
        )
        result.success(nodeInfo.toMap())
    }

    private suspend fun addShapeNode(args: Map<*, *>, result: MethodChannel.Result) {
        val sceneNode = SceneNode.fromMap(args) ?: run {
            val message = NodeError.NodeInvalidShape.format()
            Log.e(TAG, message)
            return result.error(NodeError.NodeInvalidShape.code, message, null)
        }

        val node = buildNativeNode(sceneNode) ?: run {
            val message = NodeError.NodeInstanceCreationFailed.format(sceneNode)
            Log.e(TAG, message)
            return result.error(NodeError.PlacementFailed.code, message, null)
        }

        node.name = sceneNode.nodeId
        node.position = sceneNode.position
        sceneNode.rotation?.let { node.rotation = it }

        sceneView.addChildNode(node)

        val nodeInfo = NodeInfo(
            nodeId = node.name!!,
            position = node.position,
            rotation = node.rotation,
            scale = node.scale
        )
        result.success(nodeInfo.toMap())
    }

    private suspend fun addTextNode(args: Map<*, *>, result: MethodChannel.Result) {
        val sceneNode = SceneNode.fromMap(args) ?: run {
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

        val node = buildNativeNode(sceneNode) ?: run {
            val message = NodeError.NodeInstanceCreationFailed.format(sceneNode)
            Log.e(TAG, message)
            return result.error(NodeError.NodeInstanceCreationFailed.code, message, null)
        }

        val hitResultAnchor = sceneView.hitTestAR(
            xPx = sceneNode.position.x,
            yPx = sceneNode.position.y,
            point = true,
            planeTypes = setOf(Plane.Type.HORIZONTAL_UPWARD_FACING, Plane.Type.VERTICAL)
        )?.createAnchorOrNull()

        if (hitResultAnchor == null) {
            val message = NodeError.PlacementFailed.format(sceneNode)
            Log.e(TAG, message)
            return result.error(NodeError.PlacementFailed.code, message, null)
        }

        node.position = Position(hitResultAnchor.pose.tx(), hitResultAnchor.pose.ty(), hitResultAnchor.pose.tz())
        node.name = sceneNode.nodeId
        sceneView.addChildNode(node)

        val nodeInfo = NodeInfo(
            nodeId = node.name!!,
            position = node.position,
            rotation = node.rotation,
            scale = node.scale
        )
        result.success(nodeInfo.toMap())
    }

    private fun removeNode(args: Map<*, *>, result: MethodChannel.Result) {
        val nodeId = args["nodeId"] as? String ?: ""
        try {
            val targetNode = sceneView.childNodes.firstOrNull { it.name == nodeId }
            if (targetNode != null) {
                sceneView.removeChildNode(targetNode)
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
            sceneView.childNodes.forEach { node -> sceneView.removeChildNode(node) }
            result.success(true)
        } catch (e: Exception) {
            val message = NodeError.RemoveAllFailed.format(e.message ?: "unknown")
            Log.e(TAG, message)
            result.error(NodeError.RemoveAllFailed.code, message, null)
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
        return when (sceneNode.type) {
            NodeType.MODEL -> {
                val modelConfig = sceneNode.config as? ModelConfig ?: return null
                val fileName = modelConfig.fileName ?: return null
                val model = preloadedModels[fileName] ?: loadModelFrom(fileName, false)
                ?: loadModelFrom(null, true) ?: return null
                preloadedModels[fileName] = model
                ModelNode(modelInstance = modelLoader.createInstance(model) ?: return null, scaleToUnits = 0.5f)
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


            else -> { return null}
        }
    }



    //TODO: The anchor will serve as the point in the AR world to fix and update the child objects
    // positions when the scene tracking session gets updates
    private fun createAnchor() {

    }


    private suspend fun loadModelFrom(fileName: String?, loadDefault: Boolean = false): Model? =
        withContext(Dispatchers.IO) {
            val assetPath = assetLoader.resolveAssetPath(fileName, loadDefault)
            modelLoader.loadModel(assetPath)
        }
}

private fun normalizePoint(x: Float, y: Float, renderInfo: RenderInfo?): Pair<Float, Float>? {
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

        return Pair(localX, localY)
    } else null
}
