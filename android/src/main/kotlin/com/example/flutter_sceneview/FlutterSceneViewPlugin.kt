package com.example.flutter_sceneview

import android.app.Activity
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.util.Log
import androidx.lifecycle.LifecycleOwner
import com.example.flutter_sceneview.handlers.PermissionsHandler
import com.example.flutter_sceneview.factory.ScenePlatformViewFactory
import com.example.flutter_sceneview.utils.Channels
import com.google.ar.core.ArCoreApk
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/** FlutterSceneViewPlugin */
class FlutterSceneViewPlugin : FlutterPlugin, MethodChannel.MethodCallHandler, ActivityAware {

    companion object {
        private const val TAG = "FlutterSceneViewPlugin";
    }

    private var flutterPluginBinding: FlutterPlugin.FlutterPluginBinding? = null;
    private var activity: Activity? = null

    /// The main MethodChannel that will handle the communication between Flutter and native Android
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    // TODO Refactor permission handler to use arcore permissions
    private var isViewRegistered = false;
    private var permissionsHandler: PermissionsHandler? = null


    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        try {
            channel = MethodChannel(flutterPluginBinding.binaryMessenger, Channels.MAIN)
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
                    requestCode, permissions, grantResults
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

            "checkARCoreStatus" -> {
                handleCheckARCoreAvailability(result)
            }

            "requestARCoreInstall" -> {
                handleRequestARCoreInstall(result)
            }

            else -> {
                result.notImplemented()
            }
        }
    }


    //TODO: Move this to the right subpackage division or handler
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
                        val viewTypeId = Channels.VIEW
                        flutterPluginBinding?.platformViewRegistry?.registerViewFactory(
                            viewTypeId, ScenePlatformViewFactory(
                                binding = flutterPluginBinding,
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


    private fun handleCheckARCoreAvailability(result: MethodChannel.Result) {
        try {
            val context = flutterPluginBinding?.applicationContext ?: run {
                result.error("NO_CONTEXT", "Application context is null", null)
                return
            }

            // This will never return UNKNOWN_CHECKING.
            ArCoreApk.getInstance().checkAvailabilityAsync(context) { availability ->
                val status = when (availability) {
                    ArCoreApk.Availability.SUPPORTED_APK_TOO_OLD -> "supported_apk_too_old"
                    ArCoreApk.Availability.SUPPORTED_INSTALLED -> "supported_installed"
                    ArCoreApk.Availability.SUPPORTED_NOT_INSTALLED -> "supported_not_installed"
                    ArCoreApk.Availability.UNKNOWN_CHECKING -> "unknown_checking"
                    ArCoreApk.Availability.UNKNOWN_ERROR -> "unknown_error"
                    ArCoreApk.Availability.UNKNOWN_TIMED_OUT -> "unknown_timed_out"
                    ArCoreApk.Availability.UNSUPPORTED_DEVICE_NOT_CAPABLE -> "unsupported_device"
                    else -> "unknown"
                }

                // Send result back to Flutter on the main thread.
                Handler(Looper.getMainLooper()).post {
                    result.success(mapOf("status" to status))
                }
            }
        } catch (e: Exception) {
            result.error("ARCORE_ERROR", "Failed to check ARCore", e.message)
        }
    }


    private fun handleRequestARCoreInstall(result: MethodChannel.Result) {
        try {
            // Try to request install if needed. This must be called from the main thread.
            val installStatus = ArCoreApk.getInstance().requestInstall(
                activity, /* userRequestedInstall= */
                true
            )

            val status = when (installStatus) {
                ArCoreApk.InstallStatus.INSTALLED -> "installed"
                ArCoreApk.InstallStatus.INSTALL_REQUESTED -> "install_requested"
            }

            result.success(mapOf("status" to status))
        } catch (e: Exception) {
            result.error(
                "ARCORE_INSTALL_ERROR",
                "Failed to request ARCore install: ${e.localizedMessage}",
                null
            )
        }
    }
}