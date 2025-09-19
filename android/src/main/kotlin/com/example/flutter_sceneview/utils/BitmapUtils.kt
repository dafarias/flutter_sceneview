package com.example.flutter_sceneview.utils

import android.content.Context
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.Typeface
import android.util.Log
import androidx.core.graphics.createBitmap
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterAssets

class BitmapUtils(private val context: Context, private val flutterAssets: FlutterAssets?) {

    companion object {
        private const val TAG = "BitmapUtils"
    }

    fun createTextBitmap(
        text: String,
        size: Float = 1f,
        fontFamily: String? = "",
        bitmapTextSize: Float = 200f,
        textColor: Int = Color.WHITE,
        pixelDensity: Int = 2000
    ): Bitmap {

        var typefaceAsset: Typeface? = null

        if (fontFamily != null && fontFamily.isNotEmpty()) {
            // Loads typeface from Flutter assets
            val fontPathInApk = flutterAssets?.getAssetFilePathByName(fontFamily)
            typefaceAsset = try {
                Typeface.createFromAsset(context.assets, fontPathInApk)
            } catch (e: Exception) {
                Log.e(TAG, "Failed to load font family or typeface: ${e.cause}")
                Typeface.DEFAULT // fallback if font fails to load
            }
        }


        // The text size is used to calculate the crispness / resolution
        // of the pixels used in the text
        val paint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
            textSize = bitmapTextSize
            color = textColor
            isAntiAlias = true
            isDither = true
            isFilterBitmap = true
            typeface = typefaceAsset
        }

        val targetWidthPx = (size * pixelDensity).toInt()

        //  Measure and adjust text size proportionally to fit target width
        val measuredWidth = paint.measureText(text)
        val proportionalSize = (targetWidthPx / measuredWidth) * paint.textSize
        paint.textSize = proportionalSize

        val textWidth = paint.measureText(text).toInt()
        val textHeight = (paint.descent() - paint.ascent()).toInt()

        val bitmap = createBitmap(textWidth + 40, textHeight + 40)
        val canvas = Canvas(bitmap)
        canvas.drawColor(Color.TRANSPARENT)
        canvas.drawText(text, 20f, textHeight.toFloat(), paint)

        return bitmap
    }
}