package com.example.flutter_sceneview.view

import android.content.Context
import android.view.View
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import io.flutter.plugin.common.StandardMessageCodec

class ARViewFactory : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    companion object {
        const val VIEW_TYPE = "flutter_sceneview/ar_view"
    }

    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        return object : PlatformView {
            private val arView = ARView(context)

            override fun getView(): View = arView

            override fun dispose() {
                arView.dispose()
            }
        }
    }
}
