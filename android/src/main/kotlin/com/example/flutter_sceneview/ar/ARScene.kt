package com.example.flutter_sceneview.ar

import android.app.Activity
import android.content.Context
import android.graphics.Bitmap
import android.util.Log
import com.example.flutter_sceneview.utils.SnapshotUtils
import com.google.android.filament.*
import com.google.android.filament.utils.KTX1Loader
import io.github.sceneview.ar.ARSceneView
import java.nio.ByteBuffer
import java.nio.ByteOrder
import com.google.android.filament.EntityManager
import com.google.android.filament.IndirectLight
import com.google.android.filament.LightManager
import com.google.android.filament.Skybox
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterAssets
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.github.sceneview.loaders.ModelLoader
import io.github.sceneview.model.Model
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class ARScene(
    private val sceneView: ARSceneView, private val messenger: BinaryMessenger,
    //        private val coroutineScope: CoroutineScope
) : MethodCallHandler {

    private val TAG = "ARScene"
    private val _channel = MethodChannel(messenger, "ar_scene")

    private val engine = sceneView.engine
    private val entityManager = EntityManager.get()
    private val lightManager = engine.lightManager


    init {
        _channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "takeSnapshot" -> {
                onTakeSnapshot(call, result)
                return
            }

            else -> result.notImplemented()
        }
    }

    /**
     * Adds a sunlight to the scene with default parameters.
     */
    fun addSunLight(
        intensity: Float = 100_000.0f,
        direction: FloatArray = floatArrayOf(0.0f, -1.0f, 0.0f),
        color: FloatArray = floatArrayOf(1.0f, 1.0f, 1.0f),
        sunAngularRadius: Float = 0.45f,
        sunHaloSize: Float = 5.0f,
        sunHaloFalloff: Float = 10.0f
    ) {
        val sunEntity = entityManager.create()
        LightManager.Builder(LightManager.Type.SUN).castShadows(true)
            .color(color[0], color[1], color[2]).intensity(intensity)
            .direction(direction[0], direction[1], direction[2]).sunAngularRadius(sunAngularRadius)
            .sunHaloSize(sunHaloSize).sunHaloFalloff(sunHaloFalloff).build(engine, sunEntity)

        lightManager.setDirection(
            lightManager.getInstance(sunEntity), -0f, -1f, -1f
        )
        sceneView.scene.addEntity(sunEntity)

        // addFillLight(direction= floatArrayOf(0.5f, 1f, 1f))
    }

    /**
     * Example placeholder for adding a directional fill light later.
     */
    fun addFillLight(
        intensity: Float = 40_000.0f,
        direction: FloatArray = floatArrayOf(0.3f, -1.0f, 0.8f),
        color: FloatArray = floatArrayOf(0.8f, 0.35f, 0.5f)
    ) {
        val fillEntity = entityManager.create()
        LightManager.Builder(LightManager.Type.DIRECTIONAL).color(color[0], color[1], color[2])
            .intensity(intensity).direction(direction[0], direction[1], direction[2])
            .build(engine, fillEntity)

        sceneView.scene.addEntity(fillEntity)
    }


    fun enableEnvironment() {
        val engine = sceneView.engine
        val entityManager = EntityManager.get()
        val lightManager = engine.lightManager
        val iblTexture = KTX1Loader.createTexture(engine, readAsset("ibl/lightroom_14b_ibl.ktx"))
        val skyboxTexture =
            KTX1Loader.createTexture(engine, readAsset("ibl/lightroom_14b_skybox.ktx"))
    }


    //TODO: Consider moving this to an utility class to be called from this or other classes
    fun readAsset(filename: String): ByteBuffer {
        // Or use the context that comes from the main wrapper class
        val asset = sceneView.context.assets.open(filename)
        val bytes = ByteArray(asset.available())
        asset.read(bytes)
        asset.close()
        val buffer = ByteBuffer.allocateDirect(bytes.size)
        buffer.order(ByteOrder.nativeOrder())
        buffer.put(bytes)
        buffer.rewind()
        return buffer
    }


    fun onTakeSnapshot(call: MethodCall, result: MethodChannel.Result) {
        try {
            Log.i(TAG, "takeSnapshot")
            sceneSnapshot(sceneView.context as Activity) { byteArray ->
                if (byteArray != null) {
                    result.success(byteArray)
                } else {
                    result.error("SNAPSHOT_FAILED", "Failed to take snapshot.", null)
                }
            }
        } catch (e: Exception) {
            result.error("FAILED_SNAPSHOT_ERROR", e.message ?: "Unknown error", null)
        }
    }

    // Possible future implementation
    fun sceneSnapshot(activity: Activity, callback: (ByteArray?) -> Unit) {
        try {
            SnapshotUtils.takePixelCopySnapshot(activity, sceneView) { bitmap ->
                if (bitmap != null) {
                    callback(SnapshotUtils.bitmapToByteArray(bitmap))

                } else {
                    callback(null)
                }
            }

        } catch (e: Exception) {
            Log.e(TAG, "Failed to create snapshot of the AR Scene: ${e.message}")
        }
    }

}
