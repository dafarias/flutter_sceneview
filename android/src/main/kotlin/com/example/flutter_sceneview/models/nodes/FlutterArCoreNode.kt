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