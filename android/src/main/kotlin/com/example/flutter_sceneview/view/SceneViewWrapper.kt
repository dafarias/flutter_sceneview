package com.example.flutter_sceneview.view

import android.content.Context
import android.util.Log
import android.view.View
import android.widget.FrameLayout
import androidx.lifecycle.Lifecycle
import com.example.flutter_sceneview.FlutterSceneviewPlugin
import com.example.flutter_sceneview.ar.ARScene
import com.example.flutter_sceneview.controller.ARController
import com.example.flutter_sceneview.entities.flutter.FlutterArCoreShapeNode
import com.example.flutter_sceneview.result.NodeResult
import com.google.android.filament.EntityManager
import com.google.android.filament.LightManager
import com.google.ar.core.Config
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.platform.PlatformView
import io.github.sceneview.ar.ARSceneView
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch


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
    private var _controller: ARController

    override fun getView(): View {
//        Log.i(TAG, "getView:")
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
//                 Configure AR session settings
                sessionConfiguration = { session, config ->
                    // Enable depth if supported on the device
                    config.depthMode =
                        when (session.isDepthModeSupported(Config.DepthMode.AUTOMATIC)) {
                            true -> Config.DepthMode.AUTOMATIC
                            else -> Config.DepthMode.DISABLED
                        }
                    config.instantPlacementMode = Config.InstantPlacementMode.LOCAL_Y_UP
                    config.lightEstimationMode = Config.LightEstimationMode.ENVIRONMENTAL_HDR
                }

                onSessionResumed = { session ->
                    Log.i(TAG, "onSessionResumed")
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

            ARScene(sceneView).addSunLight()


            sceneView.layoutParams = FrameLayout.LayoutParams(
                FrameLayout.LayoutParams.MATCH_PARENT, FrameLayout.LayoutParams.MATCH_PARENT
            )
            _channel.setMethodCallHandler(this)

        } catch (e: Exception) {
            Log.i(TAG, "Failed to init ARSceneView", e)
            sceneView = ARSceneView(context)
        }

        _controller = ARController(
            context = context,
            sceneView = sceneView,
            modelLoader = sceneView.modelLoader,
            flutterAssets = FlutterSceneviewPlugin.flutterAssets,
            channel = _channel,
            coroutineScope = _mainScope
        )

//        sceneView.onTouchEvent = { motionEvent, hitResult ->
//            if (motionEvent.action == MotionEvent.ACTION_UP && hitResult != null) {
//                // Convert hit position to SceneView world position
//                val hitPosition = hitResult.position
//
//                // Replace "Duck.glb" with a dynamic value if you send the model name from Flutter
////                val modelName = "Duck.glb"
//
//                _controller?.onTap(hitPosition, )
//
//                true // event was handled
//            } else {
//                false // let others handle it
//            }
//        }
    }


//    private suspend fun buildNode(): ModelNode? { //flutterNode: FlutterSceneViewNode
    /*  var model: ModelInstance? = null
              AnchorNode(sceneView.engine, anchor)
                  .apply {
                      isEditable = true
                      //isLoading = true
                      sceneView.modelLoader.loadModelInstance(
                          "https://sceneview.github.io/assets/models/DamagedHelmet.glb"
                      )?.let { modelInstance ->
                          addChildNode(
                              ModelNode(
                                  modelInstance = modelInstance,
                                  // Scale to fit in a 0.5 meters cube
                                  scaleToUnits = 0.5f,
                                  // Bottom origin instead of center so the model base is on floor
                                  centerOrigin = Position(y = -0.5f)
                              ).apply {
                                  isEditable = true
                              }
                          )
                      }
                      //isLoading = false
                      anchorNode = this
                  }*/

//        when (flutterNode) {
//            is FlutterReferenceNode -> {
//                val fileLocation = Utils.getFlutterAssetKey(activity, flutterNode.fileLocation)
//                Log.d("SceneViewWrapper", fileLocation)
//                model = sceneView.modelLoader.loadModelInstance(fileLocation)
//            }
//        }

//        if (model != null) {
//            val modelNode = ModelNode(modelInstance = model, scaleToUnits = 1.0f).apply {
//
////                transform(
////                    position = flutterNode.position,
////                    rotation = flutterNode.rotation,
////                    //scale = flutterNode.scale,
////                )
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
                _mainScope.launch {
                    onAddNode(call, result)
                }
                return
            }

            "addShapeNode" -> {
                _mainScope.launch {
                    onAddShapeNode(call, result)
                }
                return
            }

            "removeNode" -> {
                onRemoveNode(call, result)
                return
            }

            "removeAllNodes" -> {
                onRemoveAllNodes(call, result)
                return
            }

            else -> result.notImplemented()
        }
    }

    fun onAddNode(call: MethodCall, result: MethodChannel.Result) {
        try {
            Log.i(TAG, "addNode")
            val args = call.arguments as? Map<String, *>
            if (args == null) {
                result.error(
                    "INVALID_ARGUMENTS",
                    "Expected a map with node position and optional model file name",
                    null
                )
                return
            }
            _mainScope.launch {
                try {
                    val nodeResult = _controller.addNode(args)
                    when (nodeResult) {
                        is NodeResult.Placed -> {
                            result.success(nodeResult.node.toMap())
                        }

                        is NodeResult.Failed -> {
                            result.error("ADD_NODE_FAILED", nodeResult.reason, null)
                        }
                    }
                } catch (e: Exception) {
                    result.error("ADD_NODE_ERROR", e.message ?: "Unknown error", null)
                }
            }
        } catch (e: Exception) {
            Log.e(TAG, "Failed to add node: ${e.message}")
            result.error("ADD_NODE_ERROR", e.message ?: "Unknown error", null)
        }
    }

    private fun onAddShapeNode(call: MethodCall, result: MethodChannel.Result) {
        try {
            val args = call.arguments as? Map<String, *>

            if (args == null) {
                result.error(
                    "INVALID_ARGUMENTS",
                    "Expected a map with node position",
                    null
                )
                return
            }

            _mainScope.launch {
                try {
                    val flutterShapeNode = FlutterArCoreShapeNode(args)
                    val nodeResult = _controller.addShapeNode(flutterShapeNode)
                    when (nodeResult) {
                        is NodeResult.Placed -> {
                            result.success(nodeResult.node.toMap())
                        }

                        is NodeResult.Failed -> {
                            result.error("ADD_SHAPE_NODE_FAILED", nodeResult.reason, null)
                        }
                    }
                } catch (e: Exception) {
                    result.error("ADD_SHAPE_NODE_ERROR", e.message ?: "Unknown error",
                        e.stackTraceToString()
                    )
                }
            }
        } catch (e: Exception) {
            Log.e(TAG, "Failed to add shape node: ${e.message}")
            result.error("ADD_SHAPE_NODE_ERROR", e.message ?: "Unknown error", null)
        }
    }


    fun onRemoveNode(call: MethodCall, result: MethodChannel.Result) {
        try {
            Log.i(TAG, "removeNode")
            val args = call.arguments as? Map<String, *>
            if (args == null) {
                result.error("INVALID_ARGUMENTS", "Expected a map argument", null)
                return
            }
            val id = args["nodeId"] as? String ?: ""
            val node = _controller.removeNode(nodeId = id)
            result.success(null)
        } catch (e: Exception) {
            result.error("REMOVE_ALL_NODES_ERROR", e.message ?: "Unknown error", null)
        }
    }

    fun onRemoveAllNodes(call: MethodCall, result: MethodChannel.Result) {
        try {
            Log.i(TAG, "removeAllNodes")
            val node = _controller.removeAllNodes()
            result.success(null)
        } catch (e: Exception) {
            result.error("REMOVE_ALL_NODES_ERROR", e.message ?: "Unknown error", null)
        }
    }
}


