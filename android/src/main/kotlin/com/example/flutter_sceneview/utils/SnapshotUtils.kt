package com.example.flutter_sceneview.utils

import android.app.Activity
import android.graphics.Bitmap
import android.graphics.Rect
import android.os.Handler
import android.os.Looper
import android.view.SurfaceView
import android.view.TextureView
import android.view.PixelCopy
import androidx.core.graphics.createBitmap
import java.io.ByteArrayOutputStream

object SnapshotUtils {
    fun takePixelCopySnapshot(activity: Activity, surfaceView: SurfaceView, onResult: (Bitmap?) -> Unit) {
        val bitmap = createBitmap(surfaceView.width, surfaceView.height)
        val location = IntArray(2)
        surfaceView.getLocationInWindow(location)

        PixelCopy.request(
            activity.window,
            Rect(location[0], location[1], location[0] + surfaceView.width, location[1] + surfaceView.height),
            bitmap,
            { result ->
                if (result == PixelCopy.SUCCESS) {
                    onResult(bitmap)
                } else {
                    onResult(null)
                }
            },
            Handler(Looper.getMainLooper())
        )
    }

    fun bitmapToByteArray(bitmap: Bitmap): ByteArray {
        val outputStream = ByteArrayOutputStream()
        bitmap.compress(Bitmap.CompressFormat.PNG, 100, outputStream)
        return outputStream.toByteArray()
    }
}
