package com.snt.flutter_sceneview.handlers

import android.Manifest
import android.app.Activity
import android.content.pm.PackageManager
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat


//TODO: Use the arcore bundled permission handler
class PermissionsHandler(private val activity: Activity) {
    companion object {
        const val CAMERA_PERMISSION = Manifest.permission.CAMERA
        const val REQUEST_CODE = 1001
    }

    private var onResult: ((granted: Boolean) -> Unit)? = null

    fun checkAndRequestPermission(onResult: (Boolean) -> Unit) {
        val granted = ContextCompat.checkSelfPermission(activity, CAMERA_PERMISSION) == PackageManager.PERMISSION_GRANTED
        if (granted) {
            onResult(true)
        } else {
            this.onResult = onResult
            ActivityCompat.requestPermissions(activity, arrayOf(CAMERA_PERMISSION), REQUEST_CODE)
        }
    }

    fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        if (requestCode == REQUEST_CODE) {
            onResult?.invoke(grantResults.firstOrNull() == PackageManager.PERMISSION_GRANTED)
            onResult = null
        }
    }
}
