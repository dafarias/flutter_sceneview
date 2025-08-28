package com.example.flutter_sceneview.controllers

import android.content.Context
import android.graphics.*
import com.example.flutter_sceneview.models.nodes.*
import android.util.Log
import com.example.flutter_sceneview.models.render.RenderInfo
import com.example.flutter_sceneview.results.ARResult
import com.example.flutter_sceneview.results.NodeResult
import com.google.ar.core.Plane
import com.google.ar.core.TrackingState
import dev.romainguy.kotlin.math.Float3
import io.github.sceneview.ar.ARSceneView
import io.github.sceneview.math.Position
import io.github.sceneview.node.ModelNode
import io.github.sceneview.loaders.ModelLoader
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.launch
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterAssets
import io.flutter.plugin.common.MethodChannel
import io.github.sceneview.ar.arcore.createAnchorOrNull
import io.github.sceneview.model.Model
import java.util.UUID
import com.example.flutter_sceneview.models.materials.BaseMaterial
import com.example.flutter_sceneview.models.shapes.BaseShape
import com.example.flutter_sceneview.utils.AssetLoader
import com.example.flutter_sceneview.utils.BitmapUtils
import com.example.flutter_sceneview.utils.MathUtils
import com.example.flutter_sceneview.utils.MathUtils.rotationFromMap
import io.github.sceneview.ar.arcore.position
import io.github.sceneview.ar.arcore.quaternion
import io.github.sceneview.ar.arcore.rotation
import io.github.sceneview.node.ImageNode
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

@Deprecated("Will be removed to favour the centralized management of channels")
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
    private val assetLoader = AssetLoader(context, flutterAssets)
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


    //todo
    // Should return anchored node related info to be able to remove the node, clone it or
    // to perform operations on it
    suspend fun addNode(args: Map<*, *>): NodeResult {
        var failureMessage = ""

        if (sceneView.cameraNode.trackingState != TrackingState.TRACKING) {
            failureMessage = "Camera not tracking — can't perform hit test yet."
            Log.w(TAG, failureMessage)
            return NodeResult.Failed(failureMessage)
        }

        val fileName = args["fileName"] as? String ?: defaultModelSrc
        val testPlacement = args["test"] as? Boolean == true
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
            val renderInfoMap = args["renderInfo"] as? Map<*, *>

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
                rotation = hitResultAnchor.pose.rotation,
                scale = node.scale
            )
            return NodeResult.Placed(node = nodeInfo)
        } catch (e: Exception) {
            Log.e(TAG, "Failed to load model: ${e.message}")
            throw Exception("Failed to create or to load model instance from $fileName: ${e.message}")
        }
    }

    fun addShapeNode(args: Map<*, *>): NodeResult {
        try {
            val material =
                BaseMaterial.fromMap(args["material"] as? Map<*, *> ?: emptyMap<String, Any?>())
                    ?: return NodeResult.Failed("Invalid material")

            val shapeNode = BaseShape.fromMap(args)?.toNode(
                sceneView.engine, sceneView.materialLoader.createColorInstance(
                    color = material.color,
                    metallic = material.metallic,
                    roughness = material.roughness,
                    reflectance = material.reflectance
                )
            ) ?: return NodeResult.Failed("Invalid shape")


            val positionMap =
                args["position"] as? Map<*, *> ?: return NodeResult.Failed("Missing position")
            val position = MathUtils.positionFromMap(positionMap)
                ?: return NodeResult.Failed("Invalid position")

            val rotationMap = args["rotation"] as? Map<*, *>
            val rotation = rotationMap?.let { rotationFromMap(it) }


            shapeNode.name = UUID.randomUUID().toString()
            shapeNode.position = position
            // assigns only if non-null
            rotation?.let { shapeNode.rotation = it }
            // TODO // shapeNode.scale = Scale(1f, 1f, 1f)

            sceneView.addChildNode(shapeNode)


            val nodeInfo = NodeInfo(
                nodeId = shapeNode.name!!,
                position = shapeNode.position,
                rotation = shapeNode.rotation,
                scale = shapeNode.scale,
            )
            return NodeResult.Placed(nodeInfo)

        } catch (e: Exception) {
            return NodeResult.Failed("Could not place shape node: ${e.cause}")
        }

    }


    fun hitTest(args: Map<*, *>): ARResult {
        try {
            val coordX = (args["x"] as? Double)?.toFloat()
            val coordY = (args["y"] as? Double)?.toFloat()

            val renderInfoMap = args["renderInfo"] as? Map<*, *>

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


    fun addTextNode(
        args: Map<*, *>,
    ) {
        val text = args["text"] as? String ?: ""
        var x = (args["x"] as? Double)?.toFloat()
        var y = (args["y"] as? Double)?.toFloat()
        val fontFamily = args["fontFamily"] as? String
        val normalize = args["normalize"] as? Boolean ?: false

        // The size can be a single float value of N = meters, like 0.02 , etc.
        // This size represents the width of the image / bitmap (in meters)
        val size = (args["size"] as? Number)?.toFloat() ?: 1f

        //Temporary measure, color equivalent needs to be worked on
        val textColor = args["textColor"] as? Int ?: Color.WHITE

        val renderInfoMap = args["renderInfo"] as? Map<*, *>

        if (x == null || y == null || renderInfoMap == null) {
            return
        }
        val renderInfo = RenderInfo.fromMap(renderInfoMap)

        if (normalize) {
            val (normalizedX, normalizedY) = normalizePoint(x, y, renderInfo) ?: run {
                Log.e(TAG, "Normalization failed")
                return
            }

            // Use normalizedX and normalizedY for  hit testing
            val physicalX: Float = (normalizedX * sceneView.width)
            val physicalY: Float = (normalizedY * sceneView.height)

            x = physicalX
            y = physicalY
        }

        val hitResultAnchor = sceneView.hitTestAR(
            xPx = x,
            yPx = y,
            point = true,
            planeTypes = setOf(Plane.Type.HORIZONTAL_UPWARD_FACING, Plane.Type.VERTICAL),
        )?.createAnchorOrNull()

        if (hitResultAnchor == null) {
            val failureMessage = "No AR surface found at screen coordinates x=$x, y=$y"
            Log.e(TAG, failureMessage)
            return
        }

        val pose = hitResultAnchor.pose
        val hitPosition = Position(pose.tx(), pose.ty(), pose.tz())

        val textBitmap = BitmapUtils(context, flutterAssets).createTextBitmap(
            text = text, fontFamily = fontFamily, textColor = textColor
        )

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

    private suspend fun loadModelFrom(fileName: String?, loadDefault: Boolean = false): Model? =
        withContext(Dispatchers.IO) {
            val assetPath = assetLoader.resolveAssetPath(fileName, loadDefault)
            modelLoader.loadModel(assetPath)
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


}
