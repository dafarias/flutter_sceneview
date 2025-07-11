package com.example.flutter_sceneview.entities.flutter

import com.example.flutter_sceneview.utils.Parsers.Companion.parsePosition
import io.github.sceneview.math.Scale

open class FlutterArCoreNode(nodeProps: Map<String, *>) {
    val position = (nodeProps["position"] as? Map<String, Double>)?.let { parsePosition(it) }
    val rotation = (nodeProps["rotation"] as? Map<String, Double>)?.let { parsePosition(it) }
    val scale = (nodeProps["scale"] as? Scale)
}