package com.example.flutter_sceneview.view

import android.content.Context
import android.view.View
import io.github.sceneview.ar.ARSceneView

class ARView(context: Context) : ARSceneView(context) {
    init {
        // You can configure your session here, or expose configuration methods
        this.configureSession()
    }

    private fun configureSession() {
        // For example, basic configuration can go here
        this.planeRenderer.isEnabled = true
    }

    fun dispose() {
        this.destroy()
    }
}
