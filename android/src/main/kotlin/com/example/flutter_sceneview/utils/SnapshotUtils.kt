package com.example.flutter_sceneview.utils

import android.graphics.Bitmap
import android.os.Handler
import android.os.Looper
import android.view.Choreographer
import android.view.PixelCopy
import android.view.SurfaceView
import java.io.ByteArrayOutputStream
import androidx.core.graphics.createBitmap

object SnapshotUtils {
    fun pixelCopyBitmap(sceneView: SurfaceView, onResult: (Bitmap?) -> Unit) {
        val bitmap = createBitmap(sceneView.width, sceneView.height)

        Choreographer.getInstance().postFrameCallback {
            PixelCopy.request(sceneView, bitmap, { copyResult ->
                if (copyResult == PixelCopy.SUCCESS) {
                    onResult(bitmap)
                } else {
                    onResult(null)
                }
            }, Handler(Looper.getMainLooper()))
        }
    }

    fun bitmapToByteArray(bitmap: Bitmap, bitmapQuality: Int = 100): ByteArray {
        val outputStream = ByteArrayOutputStream()
        bitmap.compress(Bitmap.CompressFormat.PNG, bitmapQuality, outputStream)
        return outputStream.toByteArray()
    }
}
