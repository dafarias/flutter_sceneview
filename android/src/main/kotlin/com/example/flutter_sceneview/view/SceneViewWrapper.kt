package com.example.flutter_sceneview.view

import android.app.Activity
import android.content.Context
import android.util.Log
import android.view.View
import android.widget.FrameLayout
import androidx.lifecycle.Lifecycle
import com.example.flutter_sceneview.FlutterSceneviewPlugin
import com.google.android.filament.gltfio.FilamentInstance
import com.google.ar.core.Config
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.platform.PlatformView
import io.github.sceneview.ar.ARSceneView
import io.github.sceneview.math.Position
import io.github.sceneview.math.Transform
import io.github.sceneview.model.Model
import io.github.sceneview.model.ModelInstance
import io.github.sceneview.node.ModelNode
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import java.io.File
import java.io.FileOutputStream
import kotlin.random.Random


class SceneViewWrapper(
    private val context: Context,
    lifecycle: Lifecycle,
    messenger: BinaryMessenger,
    id: Int,
) : PlatformView, MethodCallHandler {

    private val TAG = "SceneViewWrapper"

    private var sceneView: ARSceneView
    private val _mainScope = CoroutineScope(Dispatchers.Main)
    private val _channel = MethodChannel(messenger, "ar_view_wrapper")

    override fun getView(): View {
        Log.i(TAG, "getView:")
        return sceneView
    }

    override fun dispose() {
        Log.i(TAG, "dispose")
        _channel.setMethodCallHandler(null)
    }

    // Create DTO or Model class to send in the configuration params
    init {
        try {
            Log.i(TAG, "init")
            sceneView = ARSceneView(context, sharedLifecycle = lifecycle)
            sceneView.apply {
                configureSession { session, config ->
                    config.lightEstimationMode = Config.LightEstimationMode.ENVIRONMENTAL_HDR
                    config.depthMode =
                        when (session.isDepthModeSupported(Config.DepthMode.AUTOMATIC)) {
                            true -> Config.DepthMode.AUTOMATIC
                            else -> Config.DepthMode.DISABLED
                        }
                    config.instantPlacementMode = Config.InstantPlacementMode.DISABLED
                }
                onSessionResumed = { session ->
                    Log.i(TAG, "onSessionCreated")
                }
                onSessionFailed = { exception ->
                    Log.e(TAG, "onSessionFailed : $exception")
                }
                onSessionCreated = { session ->
                    Log.i(TAG, "onSessionCreated")
                }
                onTrackingFailureChanged = { reason ->
                    Log.i(TAG, "onTrackingFailureChanged: $reason");
                }
            }
            sceneView.layoutParams = FrameLayout.LayoutParams(
                FrameLayout.LayoutParams.MATCH_PARENT,
                FrameLayout.LayoutParams.MATCH_PARENT
            )
            sceneView.keepScreenOn = true
            _channel.setMethodCallHandler(this)

        } catch (e: Exception) {
            Log.i(TAG, "Failed to init ARSceneView", e)
            sceneView = ARSceneView(context)
        }
    }

    private fun addNode() { //flutterNode: FlutterSceneViewNode
        placeTestNode();
        //  val node = buildNode(flutterNode) ?: return
        //        sceneView.addChildNode(node)
        //AnchorNode(sceneView.engine, anchor).apply {}
        Log.d("addNode", "Done")
    }

//    private suspend fun buildNode(flutterNode: FlutterSceneViewNode): ModelNode? {
//        var model: ModelInstance? = null
//        /*
//                AnchorNode(sceneView.engine, anchor)
//                    .apply {
//                        isEditable = true
//                        //isLoading = true
//                        sceneView.modelLoader.loadModelInstance(
//                            "https://sceneview.github.io/assets/models/DamagedHelmet.glb"
//                        )?.let { modelInstance ->
//                            addChildNode(
//                                ModelNode(
//                                    modelInstance = modelInstance,
//                                    // Scale to fit in a 0.5 meters cube
//                                    scaleToUnits = 0.5f,
//                                    // Bottom origin instead of center so the model base is on floor
//                                    centerOrigin = Position(y = -0.5f)
//                                ).apply {
//                                    isEditable = true
//                                }
//                            )
//                        }
//                        //isLoading = false
//                        anchorNode = this
//                    }
//        */
//        when (flutterNode) {
//            is FlutterReferenceNode -> {
//                val fileLocation = Utils.getFlutterAssetKey(activity, flutterNode.fileLocation)
//                Log.d("SceneViewWrapper", fileLocation)
//                model =
//                    sceneView.modelLoader.loadModelInstance(fileLocation)
//            }
//        }
//        if (model != null) {
//            val modelNode = ModelNode(modelInstance = model, scaleToUnits = 1.0f).apply {
//                transform(
//                    position = flutterNode.position,
//                    rotation = flutterNode.rotation,
//                    //scale = flutterNode.scale,
//                )
//                //scaleToUnitsCube(flutterNode.scaleUnits)
//                // TODO: Fix centerOrigin
//                //     centerOrigin(Position(x=-1.0f, y=-1.0f))
//                //playAnimation()
//            }
//            return modelNode
//        }
//        return null
//    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "init" -> {
                result.success(null)
            }

            "addNode" -> {
//                Log.i(TAG, "addNode")
//                val flutterNode = FlutterSceneViewNode.from(call.arguments as Map<String, *>)
                val fileName = call.argument<String>("fileName")
                _mainScope.launch {
                    placeTestNode(fileName)
//                    addNode() //flutterNode
                }
                result.success(null)
                return
            }

            else -> result.notImplemented()
        }
    }

    fun placeTestNode(fileName: String? = null) {
        try {
            val assetPath = getAssetPath(fileName)

            val modelInstance = if (assetPath.startsWith("/")) {
                // It's an absolute file path -> load from FileA
                sceneView.modelLoader.createModelInstance(File(assetPath))
            } else {
                // It's a relative asset path inside plugin APK assets -> load from assets
                sceneView.modelLoader.createModelInstance(assetPath)
            }

            val node = ModelNode(
                modelInstance = modelInstance,
                scaleToUnits = 0.2f, // Optional scaling
                centerOrigin =  Position(0f, 0f, 0f)  // Optional centering
            )
            // Apparently you can set the position of the node after its creation.
           // node.position = randomPosition(-1f, 1f)

            sceneView.addChildNode(node);
        } catch (e: Exception) {
            Log.e("ModelTest", "Failed to load cube.glb: ${e.message}")
        }
    }


    fun getAssetPath(fileName: String? = null): String {
        val default = "models/Duck.glb"
        val flutterAssets = FlutterSceneviewPlugin.flutterAssets ?: return ""

        return try {
            if (fileName.isNullOrEmpty()) {
                // Load the default asset directly from plugin's assets (no copying)
                // Just return the relative path inside the plugin assets folder
                default
            } else {
                val localFile = File(context.filesDir, fileName)
                if (!localFile.exists()) {
                    // Get Flutter asset relative path inside Flutter APK (e.g. "flutter_assets/assets/models/golf_flag.glb")
                    val flutterAssetRelativePath =
                        flutterAssets.getAssetFilePathByName("assets/models/$fileName")

                    context.assets.open(flutterAssetRelativePath).use { input ->
                        FileOutputStream(localFile).use { output ->
                            input.copyTo(output)
                        }
                    }
                }

                // Return absolute file path on local storage for ModelLoader to load as File
                return localFile.absolutePath
            }
        } catch (e: Exception) {
            Log.e(TAG, "Failed to load 3d asset $fileName: ${e.message}")
            return default;
        }
    }

    fun randomPosition(min: Float = -1.0f, max: Float = 1.0f): Position {
        fun randomFloat() = Random.nextFloat() * (max - min) + min
        return Position(randomFloat(), randomFloat(), randomFloat())
    }
}


