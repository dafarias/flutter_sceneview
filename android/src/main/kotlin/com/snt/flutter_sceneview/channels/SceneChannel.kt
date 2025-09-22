package com.snt.flutter_sceneview.channels

import android.content.Context
import android.media.Image
import android.util.Log
import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.LifecycleOwner
import com.snt.flutter_sceneview.utils.AssetLoader
import com.snt.flutter_sceneview.utils.Channels
import com.snt.flutter_sceneview.utils.SnapshotUtils
import com.google.android.filament.EntityManager
import com.google.android.filament.LightManager
import com.google.android.filament.Skybox
import com.google.android.filament.utils.KTX1Loader
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterAssets
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.github.sceneview.ar.ARSceneView
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import kotlin.math.cos
import kotlin.math.sin

class SceneChannel(
    private val context: Context,
    private val flutterAssets: FlutterAssets,
    private val mainScope: CoroutineScope,
    private val messenger: BinaryMessenger,
    private val sceneView: ARSceneView

) : MethodCallHandler, DefaultLifecycleObserver {

    companion object {
        private const val TAG = "SceneChannel"
    }

    private val _channel = MethodChannel(messenger, Channels.Companion.SCENE)
    private val engine = sceneView.engine
    private val entityManager = EntityManager.get()
    private val lightManager = engine.lightManager
    private val assetLoader = AssetLoader(context, flutterAssets)

    init {
        _channel.setMethodCallHandler(this)
        sceneView.lifecycle?.addObserver(this)
    }

    override fun onDestroy(owner: LifecycleOwner) {
        Log.i(TAG, "onDestroy")
        dispose()
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "takeSnapshot" -> {
                onTakeSnapshot(result)
                return
            }

            "dispose" -> {
                dispose()
                result.success(true)
                return
            }

            else -> result.notImplemented()
        }
    }

    private fun dispose() {
        _channel.setMethodCallHandler(null)
        sceneView.lifecycle?.removeObserver(this)
        // Clear any scene-specific resources, e.g., environment settings or shaders
        Log.i(TAG, "SceneChannel disposed")
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
        LightManager.Builder(LightManager.Type.DIRECTIONAL).castShadows(true)
            .color(color[0], color[1], color[2]).intensity(intensity)
            .direction(direction[0], direction[1], direction[2]).build(engine, fillEntity)

        sceneView.scene.addEntity(fillEntity)
    }


    fun enableEnvironment() {
        try {
            addSunLight(
                intensity = 37_000f,
                color = floatArrayOf(1.0f, 0.96f, 0.9f),
                direction = floatArrayOf(0.6f, -0.4f, -0.6f)
            )

            addFillLight(
                intensity = 50_000f,
                direction = floatArrayOf(-0.6f, 0.3f, 0.4f),
                color = floatArrayOf(1.0f, 0.95f, 0.75f),
            )

            // 1) Load the IBL / Skybox KTX file as ByteBuffer
            val iblBuffer = assetLoader.readAsset("ibl/crossroads_ibl.ktx")
            val skyboxBuffer = assetLoader.readAsset("ibl/crossroads_skybox.ktx")
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

            //5) Create & assign the unified Environment
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


    private fun onTakeSnapshot(result: MethodChannel.Result) {
        CoroutineScope(Dispatchers.Default).launch {
            try {
                val image: Image? = sceneView.frame?.acquireCameraImage()
                if (image != null) {
                    val bitmap = SnapshotUtils.convertYUVToBitmap(image)
                    image.close()

                    val portraitBitmap = SnapshotUtils.rotateToPortrait(bitmap)
                    val scaledBitmap =
                        SnapshotUtils.scaleBitmap(portraitBitmap, sceneView.width, sceneView.height)
                    val byteArray = SnapshotUtils.bitmapToByteArray(scaledBitmap)

                    withContext(Dispatchers.Main) {
                        result.success(byteArray)
                    }
                } else {
                    Log.w(TAG, "Failed snapshot, image created by the frame was null")
                    withContext(Dispatchers.Main) {
                        result.error("FAILED_SNAPSHOT_ERROR", "Image was null", null)
                    }
                }
            } catch (e: Exception) {
                Log.e(TAG, "Failed to create a scene snapshot: ${e.message}")
                withContext(Dispatchers.Main) {
                    result.error("FAILED_SNAPSHOT_ERROR", e.message ?: "Unknown error", null)
                }
            }
        }
    }

}
