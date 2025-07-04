package com.example.flutter_sceneview.controller

import android.content.Context
import android.util.Log
import com.example.flutter_sceneview.FlutterSceneviewPlugin
import com.example.flutter_sceneview.models.NodeInfo
import com.example.flutter_sceneview.models.render.RenderInfo
import com.example.flutter_sceneview.result.NodeResult
import com.google.ar.core.Plane
import com.google.ar.core.TrackingState
import io.github.sceneview.ar.ARSceneView
import io.github.sceneview.math.Position
import io.github.sceneview.model.ModelInstance
import io.github.sceneview.node.ModelNode
import io.github.sceneview.loaders.ModelLoader
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import java.io.File
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterAssets
import io.flutter.plugin.common.MethodChannel
import io.github.sceneview.ar.arcore.createAnchorOrNull
import io.github.sceneview.model.Model
import java.io.FileOutputStream
import java.util.UUID
import kotlin.random.Random

class ARController(
    private val context: Context,
    private val sceneView: ARSceneView,
    private val modelLoader: ModelLoader,
    private val flutterAssets: FlutterAssets?,
    private val channel: MethodChannel,
    private val coroutineScope: CoroutineScope
) {
    private val TAG = "ARController"
    private val defaultModelSrc = "models/Duck.glb"

    private val preloadedModels = mutableMapOf<String, Model>()


    fun onTap(position: Position, fileName: String? = null) {
        coroutineScope.launch {
            try {

                val model = preloadedModels[fileName] ?: run {
                    // Load and cache the model only if not already loaded
                    val assetPath = "resolveAssetPath(fileName)"
                    val loadedModel = modelLoader.loadModel(assetPath)
                        ?: throw Exception("Failed to load model from $assetPath")
                    preloadedModels["fileName"] = loadedModel
                    loadedModel
                }


                val node = ModelNode(
                    modelInstance = model.instance,
                    scaleToUnits = 0.2f,
                    centerOrigin = Position(0f, -1f, 0f)
                )
                node.position = position
                sceneView.addChildNode(node)

                // Optionally return to Flutter
                channel.invokeMethod(
                    "onNodePlaced", mapOf(
                        "x" to position.x, "y" to position.y, "z" to position.z
                    )
                )

            } catch (e: Exception) {
                Log.e(TAG, "Failed to place node: ${e.message}")
            }
        }
    }

//    private fun resolveAssetPath(fileName: String?): String {
//        val default = "models/Duck.glb"
//        return if (fileName.isNullOrEmpty()) {
//            default
//        } else {
//            val file = File(context.filesDir, fileName)
//            if (!file.exists()) {
//                val pathInFlutterAssets =
//                    flutterAssets.dartExecutor.flutterAssets.getAssetFilePathByName("assets/models/$fileName")
//                context.assets.open(pathInFlutterAssets).use { input ->
//                    file.outputStream().use { output -> input.copyTo(output) }
//                }
//            }
//            file.toURI().toString()
//        }
//    }
//

    //todo
    // Should return anchored node related info to be able to remove the node, clone it or
    // to perform operations on it
    suspend fun addNode(args: Map<String, *>): NodeResult {
        var failureMessage = ""

        if (sceneView.cameraNode.trackingState != TrackingState.TRACKING) {
            failureMessage = "Camera not tracking — can't perform hit test yet."
            Log.w(TAG, failureMessage)
            return NodeResult.Failed(failureMessage)
        }

        val fileName = args["fileName"] as? String ?: defaultModelSrc
        val testPlacement = args["test"] as? Boolean ?: false
        val x = (args["x"] as? Double)?.toFloat()
        val y = (args["y"] as? Double)?.toFloat()

        val physicalX: Float
        val physicalY: Float

        if (testPlacement) {
            // Place at center of scene view
            physicalX = sceneView.width / 2f
            physicalY = sceneView.height / 2f
            Log.i(TAG, "Placing node at scene center x=$physicalX, y=$physicalY")
        } else {
            val renderInfoMap = args["renderInfo"] as? Map<String, *>
            if (x == null || y == null || renderInfoMap == null) {
                failureMessage = "Missing x/y or renderInfo for node placement."
                Log.e(TAG, failureMessage)
                return NodeResult.Failed(failureMessage)
            }
            val renderInfo = RenderInfo.fromMap(renderInfoMap)
            val (normalizedX, normalizedY) = normalizePoint(x, y, renderInfo) ?: run {
                failureMessage = "Normalization failed"
                Log.e(TAG, failureMessage)
                return NodeResult.Failed(failureMessage)
            }

            // Use normalizedX and normalizedY for  hit testing
            physicalX = (normalizedX * sceneView.width).toFloat()
            physicalY = (normalizedY * sceneView.height).toFloat()
        }

        Log.d(
            TAG,
            "SceneView size = ${sceneView.width} x ${sceneView.height}, normalized hit at x=$x y=$y"
        )
        Log.d(TAG, "Transformed coordinates x:$physicalX, y:$physicalY")
        val hitResultAnchor = sceneView.hitTestAR(
            xPx = physicalX,
            yPx = physicalY,
            point = true,
            planeTypes = setOf(Plane.Type.HORIZONTAL_UPWARD_FACING, Plane.Type.VERTICAL),
        )?.createAnchorOrNull()

        if (hitResultAnchor == null) {
            failureMessage = "No AR surface found at screen coordinates x=$x, y=$y"
            Log.e(TAG, failureMessage)
            return NodeResult.Failed(failureMessage)
        }

        val pose = hitResultAnchor.pose
        val hitPosition = Position(pose.tx(), pose.ty(), pose.tz())
        try {
            val model = preloadedModels[fileName] ?: loadModelFrom(fileName)?.also {
                preloadedModels[fileName] = it
            } ?: throw Exception("Failed to load model $fileName")

            val instance = modelLoader.createInstance(model)
                ?: throw Exception("Failed to create instance for $fileName")

            val node = ModelNode(
                modelInstance = instance,
                scaleToUnits = 0.5f,
            )
            node.position = hitPosition
            node.name = UUID.randomUUID().toString()
            sceneView.addChildNode(node)

            Log.i(TAG, "Node $node.name placed successfully")
            //todo: node.scale is a vector, not a simple float
            val nodeInfo = NodeInfo(
                nodeId = node.name ?: "",
                position = hitPosition,
                rotation = node.rotation,
                scale = 0.1f
            )
            return NodeResult.Placed(node = nodeInfo)
        } catch (e: Exception) {
            Log.e(TAG, "Failed to load model: ${e.message}")
            throw Exception("Failed to create or to load model instance from $fileName: ${e.message}")
        }
    }

    //todo: Return success on node removal
    fun removeNode(nodeId: String): Unit { //NodeResult
        try {
            val targetNode = sceneView.childNodes.firstOrNull { it.name == nodeId }
            if (targetNode != null) {
                sceneView.removeChildNode(targetNode)
                Log.d("ARSceneController", "Node with id $nodeId removed successfully.")
            } else {
                Log.w("ARSceneController", "Node with id $nodeId not found.")
            }

        } catch (e: Exception) {
            Log.e(TAG, "Failed to remove node with id:$nodeId. ${e.message}")
        }
    }

    fun removeAllNodes(): Unit { //NodeResult
        try {
            sceneView.childNodes.forEach { node ->
                sceneView.removeChildNode(node)
            }
            //return NodeResult.Success("All nodes removed")
        } catch (e: Exception) {
            Log.e(TAG, "Failed to remove all nodes from the scene ${e.message}")
            //return NodeResult.Failed("Failed to remove nodes from the scene")
        }
    }


    fun normalizePoint(
        xLogical: Float, yLogical: Float, renderInfo: RenderInfo
    ): Pair<Float, Float>? {
        val pixelRatio = renderInfo.pixelRatio.toFloat()

        val adjustedX = (xLogical * pixelRatio).toFloat()
        val adjustedY = (yLogical * pixelRatio).toFloat()

        val adjustedPosX = (renderInfo.position.dx * pixelRatio).toFloat()
        val adjustedPosY = (renderInfo.position.dy * pixelRatio).toFloat()

        val adjustedWidth = (renderInfo.size.width * pixelRatio).toFloat()
        val adjustedHeight = (renderInfo.size.height * pixelRatio).toFloat()

        val localX = ((adjustedX - adjustedPosX) / adjustedWidth).coerceIn(0f, 1f)
        val localY = ((adjustedY - adjustedPosY) / adjustedHeight).coerceIn(0f, 1f)

        return Pair(localX, localY)
    }


    suspend fun loadModelFrom(fileName: String? = null): Model? {
        return try {
            val assetPath = getAssetPath(fileName)
            val model = sceneView.modelLoader.loadModel(assetPath)
            if (model == null) {
                Log.e(TAG, "Model is null for path: $assetPath")
            }
            model
        } catch (e: Exception) {
            Log.e(TAG, "Failed to load model: ${e.message}")
            null
        }
    }


    //TODO: Move to a helper or to a util class so this class only worries about handling scene objects
    fun getAssetPath(fileName: String? = null): String {
        val default = defaultModelSrc
        val flutterAssets = FlutterSceneviewPlugin.flutterAssets ?: return ""

        return try {
            if (fileName.isNullOrEmpty()) {
                // Load the default asset directly from plugin's assets (no copying)
                // Just return the relative path inside the plugin assets folder
                default
            } else {
                val localFile = File(context.filesDir, fileName)
                if (!localFile.exists()) {
                    // Get Flutter asset relative path inside Flutter APK
                    // (e.g. "flutter_assets/assets/models/golf_flag.glb")
                    val flutterAssetRelativePath =
                        flutterAssets.getAssetFilePathByName("assets/models/$fileName")

                    context.assets.open(flutterAssetRelativePath).use { input ->
                        FileOutputStream(localFile).use { output ->
                            input.copyTo(output)
                        }
                    }
                }

                // Return absolute file path on local storage for ModelLoader to load as File
                // return localFile.absolutePath

                // If using loadInstance, then for some reason the absolutePath doesn't work,
                // but the URI works
                return localFile.toURI().toString()
            }
        } catch (e: Exception) {
            Log.e(TAG, "Failed to load 3d asset $fileName: ${e.message}")
            return default;
        }
    }

}