package com.example.flutter_sceneview.controller

import android.content.Context
import android.graphics.*
import com.example.flutter_sceneview.models.nodes.*
import com.example.flutter_sceneview.FlutterSceneviewPlugin
import android.util.Log
import com.example.flutter_sceneview.models.render.RenderInfo
import com.example.flutter_sceneview.result.ARResult
import com.example.flutter_sceneview.result.NodeResult
import com.google.ar.core.Plane
import com.google.ar.core.TrackingState
import dev.romainguy.kotlin.math.Float3
import dev.romainguy.kotlin.math.Quaternion
import io.github.sceneview.ar.ARSceneView
import io.github.sceneview.math.Position
import io.github.sceneview.node.ModelNode
import io.github.sceneview.loaders.ModelLoader
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.launch
import java.io.File
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterAssets
import io.flutter.plugin.common.MethodChannel
import io.github.sceneview.ar.arcore.createAnchorOrNull
import io.github.sceneview.math.Transform
import io.github.sceneview.model.Model
import io.github.sceneview.node.Node
import java.io.FileOutputStream
import java.util.UUID
import androidx.core.graphics.createBitmap
import io.github.sceneview.ar.arcore.quaternion
import io.github.sceneview.node.ImageNode

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

    // TODO: Isn't used, remove?
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
            // Send render info with the initialization of the scene, if it changes
            // then send it as an optional parameter
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

        // TODO: add parameter to make normalization appliance optional
        // currently, x & y is passed raw without normalization
        val hitResultAnchor = sceneView.hitTestAR(
            xPx = x!!,
            yPx = y!!,
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
                rotation = hitResultAnchor.pose.quaternion,
                scale = 0.1f
            )
            return NodeResult.Placed(node = nodeInfo)
        } catch (e: Exception) {
            Log.e(TAG, "Failed to load model: ${e.message}")
            throw Exception("Failed to create or to load model instance from $fileName: ${e.message}")
        }
    }

    fun addShapeNode(shape: FlutterArCoreShapeNode): NodeResult {
        val material = sceneView.materialLoader.createColorInstance(Color.WHITE)
        val shapeNode = shape.build(sceneView.engine, material)

        if (shapeNode != null) {
            shapeNode.name = UUID.randomUUID().toString()
            shapeNode.position = shape.position!!
            shapeNode.rotation = shape.rotation!!
//            shapeNode.scale = Scale(1f, 1f, 1f) // TODO

            sceneView.addChildNode(shapeNode)

            val nodeInfo = NodeInfo(
                nodeId = shapeNode.name!!,
                position = shapeNode.position,
                // Needs hitResultAnchor.pose.quaternion,
//                rotation = shapeNode.rotation,
                scale = 0.1f,
                // TODO: replace this with a Float3 instead of Float
            )

            return NodeResult.Placed(nodeInfo)
        }

        return NodeResult.Failed("Could not place shape node")
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

    fun removeAllNodes(): Unit {
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


    fun hitTest(args: Map<String, *>): ARResult {  //NodeResult
        try {
            val coordX = (args["x"] as? Double)?.toFloat()
            val coordY = (args["y"] as? Double)?.toFloat()

            val renderInfoMap = args["renderInfo"] as? Map<String, *>

            if (coordX == null || coordY == null || renderInfoMap == null) {
                return ARResult.Error("Missing x/y or renderInfo to hit test AR Scene")
            }
            val renderInfo = RenderInfo.fromMap(renderInfoMap)

            val (normalizedX, normalizedY) = normalizePoint(coordX, coordY, renderInfo) ?: run {
                Log.e(TAG, "Normalization failed")
                return ARResult.Error("Normalization failed")
            }

            // Use normalizedX and normalizedY for  hit testing
            val physicalX: Float = (normalizedX * sceneView.width).toFloat()
            val physicalY: Float = (normalizedY * sceneView.height).toFloat()

            // TODO: add parameter to make normalization appliance optional
            // currently, x & y is passed raw without normalization

            // TODO: Maybe refactor this logic with sceneView.hitTestAR, because it does the same
            val frame = sceneView.frame
            if (frame != null) {
                if (frame.camera.trackingState == TrackingState.TRACKING) {
                    val hitList = frame.hitTest(coordX, coordY)
                    val list = ArrayList<Map<String, Any>>()
                    for (hit in hitList) {
                        val trackable = hit.trackable
                        if (trackable is Plane && trackable.isPoseInPolygon(hit.hitPose)) {
                            hit.hitPose
                            val distance: Float = hit.distance
                            val translation = hit.hitPose.translation
                            val rotation = hit.hitPose.rotationQuaternion
                            val flutterArCoreHitTestResult =
                                HitTestResult(distance, translation, rotation)
                            val hitTestResult = flutterArCoreHitTestResult.toMap()
                            list.add(hitTestResult)
                        }
                    }
                    Log.i("HitTestResult", "$list")
                    return ARResult.Hits(list)
                }
            }

        } catch (e: Exception) {
            Log.e(TAG, "Failed to remove all nodes from the scene ${e.message}")
            //return NodeResult.Failed("Failed to remove nodes from the scene")
        }
        return ARResult.Hits(ArrayList())
    }


    fun normalizePoint(
        xLogical: Float, yLogical: Float, renderInfo: RenderInfo
    ): Pair<Float, Float>? {
        try {
            val pixelRatio = renderInfo.pixelRatio.toFloat()

            val adjustedX = (xLogical * pixelRatio)
            val adjustedY = (yLogical * pixelRatio)

            val adjustedPosX = (renderInfo.position.dx * pixelRatio).toFloat()
            val adjustedPosY = (renderInfo.position.dy * pixelRatio).toFloat()

            val adjustedWidth = (renderInfo.size.width * pixelRatio).toFloat()
            val adjustedHeight = (renderInfo.size.height * pixelRatio).toFloat()

            val localX = ((adjustedX - adjustedPosX) / adjustedWidth).coerceIn(0f, 1f)
            val localY = ((adjustedY - adjustedPosY) / adjustedHeight).coerceIn(0f, 1f)

            return Pair(localX, localY)
        } catch (e: Exception) {
            Log.e(TAG, "Normalization failed ${e.message}")
        }

        return null
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

    fun addTextNode(
        args: Map<String, *>,
    ) {
        val text = args["text"] as? String ?: ""
        val nodeScale = args["scale"] as? Float3 ?: Float3()
        val x = (args["x"] as? Double)?.toFloat()
        val y = (args["y"] as? Double)?.toFloat()
        val fontFamily = args["fontFamily"] as? String

        // The size can be a single float value of N = meters, like 0.02 , etc.
        // This size represents the widht of the image / bitmap (in meters)
        val size = (args["size"] as? Number)?.toFloat() ?: 1f

        //Temporary measure, color equivalent needs to be worked on
        val textColor = args["textColor"] as? Int ?: Color.WHITE

        val renderInfoMap = args["renderInfo"] as? Map<String, *>

        if (x == null || y == null || renderInfoMap == null) {
            return
        }
        val renderInfo = RenderInfo.fromMap(renderInfoMap)

        val (normalizedX, normalizedY) = normalizePoint(x, y, renderInfo) ?: run {
            Log.e(TAG, "Normalization failed")
            return
        }

        // Use normalizedX and normalizedY for  hit testing
        val physicalX: Float = (normalizedX * sceneView.width).toFloat()
        val physicalY: Float = (normalizedY * sceneView.height).toFloat()


        val hitResultAnchor = sceneView.hitTestAR(
            xPx = physicalX,
            yPx = physicalY,
            point = true,
            planeTypes = setOf(Plane.Type.HORIZONTAL_UPWARD_FACING, Plane.Type.VERTICAL),
        )?.createAnchorOrNull()

        if (hitResultAnchor == null) {
            val failureMessage =
                "No AR surface found at screen coordinates x=$physicalX, y=$physicalX"
            Log.e(TAG, failureMessage)
            return
        }

        val pose = hitResultAnchor.pose
        val hitPosition = Position(pose.tx(), pose.ty(), pose.tz())

        val textBitmap = createTextBitmap(text, size = size, fontFamily = fontFamily)

        // Calculate AR height maintaining aspect ratio
        val aspectRatio = textBitmap.height.toFloat() / textBitmap.width.toFloat()
        val heightMeters = size * aspectRatio

        val textNode = ImageNode(
            materialLoader = sceneView.materialLoader,
            bitmap = textBitmap,
            size = Float3(size, heightMeters, 0f),
            center = Position(0f, 0f, 0f),
        ).apply {
            position = hitPosition
            // The scale can be used to customize the test or node in any required axis: Example
            // scale = Float3(1f, 1f, 1f)
        }

        sceneView.addChildNode(textNode)
    }


    fun transfomNode(node: Node?) {
        try {
            node?.transform(
                Transform(
                    position = node.position,//?: Position(),
                    // Rotate around X),
                    quaternion = Quaternion.fromAxisAngle(Float3(1.0f, 0.0f, 0.0f), 90f),
                    scale = node.scale // ?: Scale(1.0f)
                )
            )

        } catch (e: Exception) {
            Log.e(TAG, " Failed to transform node with: ${e.message}")
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


    //TODO: Move to helpers.
    // Args will be: Text, textColor,
    fun createTextBitmap(
        text: String,
        size: Float = 1f,
        fontFamily: String? = "",
        bitmapTextSize: Float = 200f,
        textColor: Int = Color.WHITE,
        pixelDensity: Int = 2000
    ): Bitmap {

        var typefaceAsset: Typeface? = null

        if (fontFamily != null && fontFamily.isNotEmpty()) {
            // 🔹 Load typeface from Flutter asset
            val fontPathInApk = flutterAssets?.getAssetFilePathByName(fontFamily)
            typefaceAsset = try {
                Typeface.createFromAsset(context.assets, fontPathInApk)
            } catch (e: Exception) {
                Typeface.DEFAULT // fallback if font fails to load
            }
        }


        // The text size is used to calculate the crispness / resolution
        // of the pixels used in the text
        val paint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
            textSize = bitmapTextSize
            color = textColor
            isAntiAlias = true
            isDither = true
            isFilterBitmap = true
            typeface = typefaceAsset
        }

        val targetWidthPx = (size * pixelDensity).toInt()

        //  Measure and adjust text size proportionally to fit target width
        val measuredWidth = paint.measureText(text)
        val proportionalSize = (targetWidthPx / measuredWidth) * paint.textSize
        paint.textSize = proportionalSize

        val textWidth = paint.measureText(text).toInt()
        val textHeight = (paint.descent() - paint.ascent()).toInt()

        val bitmap = createBitmap(textWidth + 40, textHeight + 40)
        val canvas = Canvas(bitmap)
        canvas.drawColor(Color.TRANSPARENT)
        canvas.drawText(text, 20f, textHeight.toFloat(), paint)

        return bitmap
    }
}
