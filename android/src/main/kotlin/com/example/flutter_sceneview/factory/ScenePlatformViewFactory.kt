package com.example.flutter_sceneview.factory


import android.app.Activity
import android.content.Context
import android.util.Log
import androidx.lifecycle.Lifecycle
import com.example.flutter_sceneview.view.SceneViewWrapper
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class ScenePlatformViewFactory(
    private var activity: Activity,
    private val messenger: BinaryMessenger,
    private var lifecycle: Lifecycle,
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    companion object {
        const val VIEW_TYPE = "flutter_sceneview/ar_view"
    }

    fun setActivityAndLifecycle(activity: Activity, lifecycle: Lifecycle) {
        this.activity = activity
        this.lifecycle = lifecycle
    }

    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        Log.d("Factory", "Creating new view instance")
        return SceneViewWrapper(context, lifecycle, messenger, viewId);
    }
}