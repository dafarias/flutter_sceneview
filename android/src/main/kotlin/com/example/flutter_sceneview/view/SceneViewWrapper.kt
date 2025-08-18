package com.example.flutter_sceneview.view

import android.content.Context
import android.util.Log
import android.view.View
import android.widget.FrameLayout
import androidx.lifecycle.Lifecycle
import com.example.flutter_sceneview.FlutterSceneviewPlugin
import com.example.flutter_sceneview.ar.ARScene
import com.example.flutter_sceneview.ar.SessionManager
import com.example.flutter_sceneview.controllers.ARController
import com.example.flutter_sceneview.results.NodeResult
import com.example.flutter_sceneview.results.ARResult
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
    private val sessionManager: SessionManager

    override fun getView(): View {
//        Log.i(TAG, "getView:")
        return sceneView
    }

    override fun dispose() {
        // Dispose / destroy all the handlers here as well
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

//                onTrackingFailureChanged = { reason ->
//                    Log.i(TAG, "onTrackingFailureChanged: $reason");
//                }
            }

            //Wrapped Scene manager
            ARScene(sceneView, messenger, context).enableEnvironment()


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


        // Attach SessionManager
        sessionManager = SessionManager(sceneView, messenger)
//        sessionManager.startMonitoring()


    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "init" -> {
                result.success(null)
            }

            "dispose" -> {
                dispose()
                result.success(null)
            }

            "addNode" -> {
                _mainScope.launch {
                    onAddNode(call, result)
                }
                return
            }

            "addShapeNode" -> {
                onAddShapeNode(call, result)
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

            "performHitTest" -> {
                onHitTest(call, result)
                return
            }

            "addTextNode" -> {
                onAddTextNode(call, result)
                return
            }

            else -> result.notImplemented()
        }
    }

    fun onAddNode(call: MethodCall, result: MethodChannel.Result) {
        try {
            Log.i(TAG, "addNode")
            val args = call.arguments as? Map<*, *>
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
            val args = call.arguments as? Map<*, *>

            if (args == null) {
                result.error(
                    "INVALID_ARGUMENTS", "Expected a map with node position", null
                )
                return
            }

            _mainScope.launch {
                try {
                    val nodeResult = _controller.addShapeNode(args)
                    when (nodeResult) {
                        is NodeResult.Placed -> {
                            result.success(nodeResult.node.toMap())
                        }

                        is NodeResult.Failed -> {
                            result.error("ADD_SHAPE_NODE_FAILED", nodeResult.reason, null)
                        }
                    }
                } catch (e: Exception) {
                    result.error(
                        "ADD_SHAPE_NODE_ERROR", e.message ?: "Unknown error", e.stackTraceToString()
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

    fun onHitTest(call: MethodCall, result: MethodChannel.Result) {
        try {
            Log.i(TAG, "performHitTest")
            val args = call.arguments as? Map<*, *>
            if (args == null) {
                result.error(
                    "INVALID_ARGUMENTS",
                    "Expected a map with the x and y coordinates to perform a hit test on the AR Scene",
                    null
                )
                return
            }
            val results = _controller.hitTest(args)

            when (results) {
                is ARResult.Hits -> {
                    result.success(results.hitResult)
                }
//                is GenericError.Failed -> {
//                    result.error("ADD_NODE_FAILED", nodeResult.reason, null)
//                }
                else -> {
                    result.error("HIT_TEST_FAILED", "Unknown error", null)
                }
            }


        } catch (e: Exception) {
            Log.e(TAG, "Failed to perform hit test: ${e.message}")
            result.error("PerformHitTest", e.message, null)
        }
    }


    fun onAddTextNode(call: MethodCall, result: MethodChannel.Result) {
        try {
            Log.i(TAG, "performHitTest")
            val args = call.arguments as? Map<*, *>
            if (args == null) {
                result.error(
                    "INVALID_ARGUMENTS",
                    "Expected a map with the x and y coordinates to perform a hit test on the AR Scene",
                    null
                )
                return
            }


            val results = _controller.addTextNode(args)

//            when (results) {
//                is ARResult.Hits -> {
//                    result.success(results.hitResult)
//                }
////                is GenericError.Failed -> {
////                    result.error("ADD_NODE_FAILED", nodeResult.reason, null)
////                }
//                else -> {
//                    result.error("HIT_TEST_FAILED", "Unknown error", null)
//                }
//            }


        } catch (e: Exception) {
            Log.e(TAG, "Failed to add text label: ${e.message}")
            result.error("AddTextNode", e.message, null)
        }
    }
}


