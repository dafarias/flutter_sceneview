package com.example.flutter_sceneview

import android.app.Activity
import android.os.Build
import android.util.Log
import androidx.lifecycle.LifecycleOwner
import com.example.flutter_sceneview.handlers.PermissionsHandler
import com.example.flutter_sceneview.factory.ScenePlatformViewFactory
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/** FlutterSceneviewPlugin */
class FlutterSceneviewPlugin : FlutterPlugin, MethodChannel.MethodCallHandler, ActivityAware {

    private val TAG = "FlutterSceneviewPlugin";
    private var flutterPluginBinding: FlutterPlugin.FlutterPluginBinding? = null;
    private var isViewRegistered = false;

    private var permissionsHandler: PermissionsHandler? = null
    private var activity: Activity? = null

    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        try {
            channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_sceneview")
            channel.setMethodCallHandler(this)
            this.flutterPluginBinding = flutterPluginBinding
            Log.i(TAG, "onAttachedToEngine")
        } catch (e: Exception) {
            Log.e(TAG, "onAttachedToEngine", e)
        }

    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        try {
            activity = binding.activity
            permissionsHandler = PermissionsHandler(activity!!)

            // Hook into the permission result callback
            binding.addRequestPermissionsResultListener { requestCode, permissions, grantResults ->
                permissionsHandler?.onRequestPermissionsResult(
                    requestCode,
                    permissions,
                    grantResults
                )
                true
            }
            Log.i(TAG, "onAttachedToActivity")
        } catch (e: Exception) {
            Log.e(TAG, "onAttachedToActivity", e)
        }
    }

    override fun onDetachedFromActivityForConfigChanges() {
        try {
            onDetachedFromActivity()
            Log.i(TAG, "onDetachedFromActivityForConfigChanges")
        } catch (e: Exception) {
            Log.e(TAG, "onDetachedFromActivityForConfigChanges", e)
        }
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        try {
            onAttachedToActivity(binding)
            Log.i(TAG, "onReattachedToActivityForConfigChanges")
        } catch (e: Exception) {
            Log.e(TAG, "onReattachedToActivityForConfigChanges", e)
        }
    }

    override fun onDetachedFromActivity() {
        try {
            activity = null;
            permissionsHandler = null;
            Log.i(TAG, "onDetachedFromActivity")
        } catch (e: Exception) {
            Log.e(TAG, "onReattachedToActivityForConfigChanges", e)
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }


    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        Log.i(TAG, "onMethodCall: ${call.method}")
        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android ${Build.VERSION.RELEASE}")
            }

            "isReady" -> result.success(null)

            "checkPermissions" -> handleCheckPermissions(result)

            else -> {
                result.notImplemented()
            }
        }
    }


    private fun handleCheckPermissions(result: MethodChannel.Result) {
        try {
            Log.i(TAG, "Requesting permissions")
            permissionsHandler?.checkAndRequestPermission { granted ->
                if (granted) {
                    val lifecycle = if (activity is LifecycleOwner) {
                        (activity as LifecycleOwner).lifecycle
                    } else {
                        throw IllegalStateException("Activity is not a LifecycleOwner")
                    }

                    if (!isViewRegistered) {
                        flutterPluginBinding?.platformViewRegistry?.registerViewFactory(
                            ScenePlatformViewFactory.VIEW_TYPE,
                            ScenePlatformViewFactory(
                                activity = activity!!,
                                messenger = flutterPluginBinding!!.binaryMessenger,
                                lifecycle = lifecycle,
                            )
                        )
                        isViewRegistered = true
                    }
                }
                result.success(granted)
            }

        } catch (e: Exception) {
            Log.i(TAG, "Failure while requesting permissions", e)
        }
    }
}