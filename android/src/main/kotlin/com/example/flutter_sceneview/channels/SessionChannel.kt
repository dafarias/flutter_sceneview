package com.example.flutter_sceneview.channels

import android.content.Context
import android.util.Log
import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.LifecycleOwner
import com.example.flutter_sceneview.models.session.toMap
import com.example.flutter_sceneview.utils.Channels
import com.google.ar.core.TrackingFailureReason
import com.google.ar.core.TrackingState
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterAssets
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.github.sceneview.ar.ARSceneView
import kotlinx.coroutines.CoroutineScope

class SessionChannel(
    private val context: Context,
    private val flutterAssets: FlutterAssets,
    private val mainScope: CoroutineScope,
    private val messenger: BinaryMessenger,
    private val sceneView: ARSceneView
) : MethodCallHandler, DefaultLifecycleObserver {

    companion object {
        private const val TAG = "SessionChannel"
    }

    private val _channel = MethodChannel(messenger, Channels.SESSION)

    private var isTracking = false
    private var stableTrackingFrames = 0
    private val requiredStableFrames = 25 // ~0.5s if running at 40fps

    // Constants to control throttling
    private val intervalThreshold = 200L  // Only process every 200 ms
    private var lastCheckTime = 0L
    private var lastTrackingState: TrackingState? = null
    private var trackingFailure: TrackingFailureReason? = null

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
            "trackSession" -> {
                startMonitoring()
                return result.success(true)
            }

            else -> result.notImplemented()
        }
    }


    fun startMonitoring() {
        sceneView.onFrame = ::onTrackingFrame
        sceneView.onTrackingFailureChanged = ::onTrackingFailure
//
//        onSessionResumed = { session ->
//            Log.i(TAG, "onSessionResumed")
//        }
//        onSessionFailed = { exception ->
//            Log.e(TAG, "onSessionFailed : $exception")
//        }
//        onSessionCreated = { session ->
//            Log.i(TAG, "onSessionCreated")
//        }
    }


    fun onTrackingFrame(frameTime: Long) {
        try {
            val nowMs = frameTime / 1_000_000L
            val delta = nowMs - lastCheckTime
            if (delta < intervalThreshold) return

            lastCheckTime = nowMs

            val currentState = sceneView.cameraNode.trackingState

            stableTrackingFrames = if (currentState == TrackingState.TRACKING) {
                stableTrackingFrames + 1
            } else {
                0
            }

            if (currentState != lastTrackingState) {
                lastTrackingState = currentState
            }

            if (currentState == TrackingState.TRACKING && !isTracking && stableTrackingFrames >= requiredStableFrames) {
                isTracking = true
                Log.i(TAG, "Tracking restored")
                _channel.invokeMethod("trackingChanged", currentState.toMap(null))

            } else if (isTracking && currentState != TrackingState.TRACKING) {
                isTracking = false
                Log.i(TAG, "Tracking lost")
                _channel.invokeMethod("trackingChanged", currentState.toMap(trackingFailure))
            }

        } catch (e: Exception) {
            Log.e(TAG, e.toString())
        }
    }

    fun onTrackingFailure(reason: TrackingFailureReason?) {
        try {
            if (reason != null) {
                trackingFailure = reason
            }
            _channel.invokeMethod(
                "trackingFailure", sceneView.cameraNode.trackingState.toMap(reason)
            )
        } catch (e: Exception) {
            Log.e(TAG, "Failed to return session tracking event")
        }
    }
}

