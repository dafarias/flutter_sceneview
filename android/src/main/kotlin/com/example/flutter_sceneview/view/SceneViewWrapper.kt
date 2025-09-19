package com.example.flutter_sceneview.view

import android.content.Context
import android.util.Log
import android.view.View
import android.widget.FrameLayout
import androidx.lifecycle.Lifecycle
import com.example.flutter_sceneview.channels.NodeChannel
import com.example.flutter_sceneview.channels.SceneChannel
import com.example.flutter_sceneview.channels.SessionChannel
import com.example.flutter_sceneview.utils.Channels
import com.google.ar.core.Config
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterAssets
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.platform.PlatformView
import io.github.sceneview.ar.ARSceneView
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers


class SceneViewWrapper(
    private val context: Context,
    private val binding: FlutterPlugin.FlutterPluginBinding,
    private val id: Int,
    lifecycle: Lifecycle,
) : PlatformView, MethodCallHandler {

    companion object {
        private const val TAG = "SceneViewWrapper"
    }

    private var sceneView: ARSceneView

    private val _mainScope = CoroutineScope(Dispatchers.Main)
    private val _channel = MethodChannel(binding.binaryMessenger, Channels.VIEW)

    // Define flutterAssets as a property if not already available
    private val flutterAssets: FlutterAssets by lazy {
        binding.flutterAssets
    }

    private var nodeChannel: NodeChannel
    private var sceneChannel: SceneChannel
    private var sessionChannel: SessionChannel


    override fun getView(): View = sceneView


    override fun dispose() {
        Log.i(TAG, "dispose")
        sceneView.clearChildNodes()
        sceneView.destroy()
        _channel.setMethodCallHandler(null)
        // TODO: Enable after implementing disposal methods
//        if (::sceneChannel.isInitialized) sceneChannel.let { /* cleanup logic  */ }
//        if (::_controller.isInitialized) _controller.dispose() // Assume ARController has a dispose method
//        if (::sessionManager.isInitialized) sessionManager.dispose() // Assume SessionManager has a dispose met
    }


    //TODO: Create DTO or Model class to send in the configuration params
    init {
        _channel.setMethodCallHandler(this)
        try {
            Log.i(TAG, "init")
            sceneView = ARSceneView(context, sharedLifecycle = lifecycle)
            sceneView.apply {
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

                layoutParams = FrameLayout.LayoutParams(
                    FrameLayout.LayoutParams.MATCH_PARENT, FrameLayout.LayoutParams.MATCH_PARENT
                )

                planeRenderer.isEnabled = true
            }

            // Initialize channels after sceneView is ready
            nodeChannel = NodeChannel(
                context, flutterAssets, _mainScope, binding.binaryMessenger, sceneView
            )
            sceneChannel = SceneChannel(
                context, flutterAssets, _mainScope, binding.binaryMessenger, sceneView
            )
            sessionChannel = SessionChannel(
                context, flutterAssets, _mainScope, binding.binaryMessenger, sceneView
            )

            // Enable environment in scene channel
            sceneChannel.enableEnvironment()

        } catch (e: Exception) {
            Log.i(TAG, "Failed to init ARSceneView", e)
            throw e // Re-throw to let the caller handle the failure
        }
    }


    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "init" -> {
                // if true then finish the initialization on init
                result.success(null)
            }

            "dispose" -> {
                dispose()
                result.success(null)
            }

            else -> result.notImplemented()
        }
    }

}

