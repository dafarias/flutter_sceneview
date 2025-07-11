package com.example.flutter_sceneview.ar

import com.google.android.filament.*
import com.google.android.filament.utils.KTX1Loader
import io.github.sceneview.ar.ARSceneView
import java.nio.ByteBuffer
import java.nio.ByteOrder
import com.google.android.filament.EntityManager
import com.google.android.filament.IndirectLight
import com.google.android.filament.LightManager
import com.google.android.filament.Skybox

class ARScene(private val sceneView: ARSceneView) {

    private val engine = sceneView.engine
    private val entityManager = EntityManager.get()
    private val lightManager = engine.lightManager

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
            val skyboxTexture = KTX1Loader.createTexture(engine, readAsset("ibl/lightroom_14b_skybox.ktx"))
    }

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
}
