package com.snt.flutter_sceneview.utils

import io.github.sceneview.SceneView
import io.github.sceneview.node.Node


fun Node.findNodeById(nodeId: String): Node? {
    if (this.name == nodeId) return this

    // childNodes might internally be a Set<Node>, so 'find' is O(1) on average
    val directMatch = childNodes.find { it.name == nodeId }
    if (directMatch != null) return directMatch

    for (child in childNodes) {
        val match = child.findNodeById(nodeId)
        if (match != null) return match
    }
    return null
}


fun SceneView.findNodeByName(nodeId: String): Node? {
    return childNodes.firstNotNullOfOrNull { it.findNodeById(nodeId) }
}
