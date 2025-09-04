package com.example.flutter_sceneview.utils

import android.content.Context
import android.util.Log
import android.view.View
import com.example.flutter_sceneview.FlutterSceneViewPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterAssets
import java.io.File
import java.io.FileNotFoundException
import java.io.FileOutputStream
import java.nio.ByteBuffer
import java.nio.ByteOrder

class AssetLoader(private val context: Context, private val flutterAssets: FlutterAssets?) {

    companion object {
        private const val TAG = "AssetLoader"
        private const val DEFAULT_MODEL = "models/Duck.glb"
    }

    val defaultModel: String
        get() = DEFAULT_MODEL

    fun resolveAssetPath(filePath: String?, loadDefaultGltf: Boolean = false): String {
        try {
            // Will load the default asset directly from plugin's assets (no copying)
            if (filePath.isNullOrEmpty() || loadDefaultGltf) {
                return DEFAULT_MODEL
            } else {
                val localFile = File(context.filesDir, filePath)
                if (!localFile.exists()) {
                    localFile.parentFile?.mkdirs()
                    val flutterAssetRelativePath =
                        flutterAssets!!.getAssetFilePathByName("assets/$filePath")

                    context.assets.open(flutterAssetRelativePath).use { input ->
                        FileOutputStream(localFile).use { output ->
                            input.copyTo(output)
                        }
                    }
                }
                return localFile.toURI().toString()
            }

        } catch (e: Exception) {
            Log.e(TAG, e.cause.toString())
            throw FileNotFoundException("FlutterAssets not available for $filePath")
        }
    }


    fun readAsset(assetName: String): ByteBuffer {
        return try {
            context.assets.open(assetName).use { input ->
                val bytes = input.readBytes()
                ByteBuffer.allocateDirect(bytes.size).apply {
                    put(bytes)
                    rewind()
                }
            }
        } catch (e: Exception) {
            Log.w(TAG, "Falling back to compressed stream for $assetName: ${e.message}")
            val asset = context.assets.open(assetName)
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
}