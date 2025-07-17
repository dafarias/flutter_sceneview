package com.example.flutter_sceneview.models.nodes

import com.example.flutter_sceneview.utils.Parsers
import io.github.sceneview.math.Scale

open class FlutterArCoreNode(nodeProps: Map<String, *>) {
    val position = (nodeProps["position"] as? Map<String, Double>)?.let {
        Parsers.Companion.parsePosition(
            it
        )
    }
    val rotation = (nodeProps["rotation"] as? Map<String, Double>)?.let {
        Parsers.Companion.parsePosition(
            it
        )
    }
    val scale = (nodeProps["scale"] as? Scale)
}


///TODO: Reference for future implementations

//        sceneView.onTouchEvent = { motionEvent, hitResult ->
//            if (motionEvent.action == MotionEvent.ACTION_UP && hitResult != null) {
//                // Convert hit position to SceneView world position
//                val hitPosition = hitResult.position
//
//                // Replace "Duck.glb" with a dynamic value if you send the model name from Flutter
////                val modelName = "Duck.glb"
//
//                _controller?.onTap(hitPosition, )
//
//                true // event was handled
//            } else {
//                false // let others handle it
//            }
//        }

//    private suspend fun buildNode(): ModelNode? { //flutterNode: FlutterSceneViewNode
/*  var model: ModelInstance? = null
          AnchorNode(sceneView.engine, anchor)
              .apply {
                  isEditable = true
                  //isLoading = true
                  sceneView.modelLoader.loadModelInstance(
                      "https://sceneview.github.io/assets/models/DamagedHelmet.glb"
                  )?.let { modelInstance ->
                      addChildNode(
                          ModelNode(
                              modelInstance = modelInstance,
                              // Scale to fit in a 0.5 meters cube
                              scaleToUnits = 0.5f,
                              // Bottom origin instead of center so the model base is on floor
                              centerOrigin = Position(y = -0.5f)
                          ).apply {
                              isEditable = true
                          }
                      )
                  }
                  //isLoading = false
                  anchorNode = this
              }*/

//        when (flutterNode) {
//            is FlutterReferenceNode -> {
//                val fileLocation = Utils.getFlutterAssetKey(activity, flutterNode.fileLocation)
//                Log.d("SceneViewWrapper", fileLocation)
//                model = sceneView.modelLoader.loadModelInstance(fileLocation)
//            }
//        }

//        if (model != null) {
//            val modelNode = ModelNode(modelInstance = model, scaleToUnits = 1.0f).apply {
//
////                transform(
////                    position = flutterNode.position,
////                    rotation = flutterNode.rotation,
////                    //scale = flutterNode.scale,
////                )
//                //scaleToUnitsCube(flutterNode.scaleUnits)
//                // TODO: Fix centerOrigin
//                //     centerOrigin(Position(x=-1.0f, y=-1.0f))
//                //playAnimation()
//            }
//            return modelNode
//        }
//        return null
//    }