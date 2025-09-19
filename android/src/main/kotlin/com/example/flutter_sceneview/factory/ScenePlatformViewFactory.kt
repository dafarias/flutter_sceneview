package com.example.flutter_sceneview.factory


import android.content.Context
import android.util.Log
import androidx.lifecycle.Lifecycle
import com.example.flutter_sceneview.view.SceneViewWrapper
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class ScenePlatformViewFactory(
    private var lifecycle: Lifecycle, private var binding: FlutterPlugin.FlutterPluginBinding?
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {


    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        Log.d("Factory", "Creating new view instance")
        return SceneViewWrapper(context, binding!!, viewId, lifecycle)
    }
}