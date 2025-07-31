package com.example.flutter_sceneview.ar

import android.media.Image
import android.content.Context
import android.content.res.AssetManager
import android.util.Log
import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.LifecycleOwner
import com.example.flutter_sceneview.utils.SnapshotUtils
import com.google.android.filament.utils.KTX1Loader
import io.github.sceneview.ar.ARSceneView
import java.nio.ByteBuffer
import java.nio.ByteOrder
import com.google.android.filament.EntityManager
import com.google.android.filament.LightManager
import com.google.android.filament.Skybox
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import kotlin.math.cos
import kotlin.math.sin

class ARScene(
    private val sceneView: ARSceneView,
    private val messenger: BinaryMessenger,
    private val context: Context,
) : MethodCallHandler, DefaultLifecycleObserver {

    private val TAG = "ARScene"
    private val _channel = MethodChannel(messenger, "ar_scene")

    private val engine = sceneView.engine
    private val entityManager = EntityManager.get()
    private val lightManager = engine.lightManager


    init {
        _channel.setMethodCallHandler(this)
        sceneView.lifecycle?.addObserver(this)
    }

    override fun onDestroy(owner: LifecycleOwner) {
        Log.i(TAG, "ARScene onDestroy")
        _channel.setMethodCallHandler(null)
        // …clean up…
        sceneView.lifecycle?.removeObserver(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "takeSnapshot" -> {
                onTakeSnapshot(result)
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
        direction: FloatArray = floatArrayOf(0.0f, -1.0f, -1.0f),
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

        sceneView.scene.addEntity(sunEntity)
    }

    /**
     * Adds a directional light to the scene with default parameters. This is used in order to make
     * the scene more natural, in combination with the main light, the IBL and Skybox
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

        try {
            addSunLight(
                intensity = 30_000f,
                color = floatArrayOf(1.0f, 0.95f, 0.85f),
                direction = floatArrayOf(1.0f, -0.3f, -0.8f)
            )

            addFillLight(
                intensity = 30_000f, direction = floatArrayOf(-1.0f, 0.5f, 0.8f),
                color = floatArrayOf(1.0f, 0.95f, 0.85f),
            )

            // 1) Load the IBL / Skybox KTX file as ByteBuffer
            val iblBuffer = readAsset(context.assets, "ibl/crossroads_ibl.ktx")
            val skyboxBuffer = readAsset(context.assets, "ibl/crossroads_skybox.ktx")
            val options = KTX1Loader.Options().apply {
                srgb = true // HDRs are linear but Filament expects IBLs in sRGB here
            }

            // 2) Use the  buffer to create an Indirect light and a Skybox texture to build the Skybox
            // Using default  brightness for IBL and Skybox (intensity = 30_000f
            val ibl = KTX1Loader.createIndirectLight(engine, iblBuffer, options).apply {
                // create a 3×3 rotation matrix for a yaw of 45°
                // (column‑major: [ cos, 0, sin, 0, 1, 0, –sin, 0, cos ])
                val angle = Math.toRadians(45.0)
                val c = cos(angle).toFloat()
                val s = sin(angle).toFloat()
                val rotationMatrix = floatArrayOf(
                    c, 0f, s, 0f, 1f, 0f, -s, 0f, c
                )
                setRotation(rotationMatrix)
            }

            val skyTexture = KTX1Loader.createTexture(engine, skyboxBuffer, options)
            val skybox = Skybox.Builder().environment(skyTexture).build(engine)


            // 3) Manually added the 9 lines into an array of triples: from the sh file:
            // spherical harmonics
            val shValues = arrayOf(
                floatArrayOf(1.566009998f, 1.342414260f, 0.906218410f),  // L00
                floatArrayOf(0.864655733f, 0.756659091f, 0.529688418f),  // L1-1
                floatArrayOf(1.269931912f, 1.079448223f, 0.684437991f),  // L10
                floatArrayOf(-0.903093815f, -0.772966027f, -0.491679600f),  // L11
                floatArrayOf(-0.171325207f, -0.145993501f, -0.092740633f),  // L2-2
                floatArrayOf(0.230275214f, 0.197136298f, 0.126416520f),  // L2-1
                floatArrayOf(0.029449740f, 0.024572141f, 0.014421941f),  // L20
                floatArrayOf(-0.255975515f, -0.216676027f, -0.135836542f),  // L21
                floatArrayOf(0.004188185f, 0.002333614f, -0.001243074f)   // L22
            )

            // 4) Flatten into one FloatArray in the exact SH order:
            val sphericalHarmonics = FloatArray(9 * 3).apply {
                var idx = 0
                for (l in 0 until 9) {
                    this[idx++] = shValues[l][0]  // R
                    this[idx++] = shValues[l][1]  // G
                    this[idx++] = shValues[l][2]  // B
                }
            }

            // 5) Create & assign the unified Environment
            sceneView.environment = sceneView.environmentLoader.createEnvironment(
                ibl,
                skybox,
                sphericalHarmonics,
            )

            Log.i(TAG, "Environment loaded with: ${sceneView.environment}")

        } catch (e: Exception) {
            Log.e(TAG, "An exception occurred while trying to load the environment: ${e.message}")
        }


    }


    //TODO: Consider moving this to an utility class to be called from this or other classes
    fun readAsset(assetManager: AssetManager, assetName: String): ByteBuffer {
        return try {
            assetManager.open(assetName).use { input ->
                val bytes = input.readBytes()
                return ByteBuffer.allocateDirect(bytes.size).apply {
                    put(bytes)
                    rewind()
                }
            }
        } catch (e: Exception) {
            // Fall back to compressed stream read
            val asset = assetManager.open(assetName)
            val bytes = ByteArray(asset.available())
            asset.read(bytes)
            asset.close()
            val buffer = ByteBuffer.allocateDirect(bytes.size)
            buffer.order(ByteOrder.nativeOrder())
            buffer.put(bytes)
            buffer.rewind()
            buffer
        }
    }

    private fun onTakeSnapshot(result: MethodChannel.Result) {
        try {
            val image: Image? = sceneView.frame?.acquireCameraImage()
            if (image != null) {
                val bitmap = SnapshotUtils.convertYUVToBitmap(image)
                image.close()

                val portraitBitmap =
                    SnapshotUtils.rotateToPortrait(bitmap)
                val scaledBitmap =
                    SnapshotUtils.scaleBitmap(portraitBitmap, sceneView.width, sceneView.height)
                val byteArray = SnapshotUtils.bitmapToByteArray(scaledBitmap)

                result.success(byteArray)
            }
        } catch (e: Exception) {
            result.error("FAILED_SNAPSHOT_ERROR", e.message ?: "Unknown error", null)
        }
    }
}
