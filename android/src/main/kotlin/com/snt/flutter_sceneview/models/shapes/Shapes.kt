package com.snt.flutter_sceneview.models.shapes

enum class Shapes {
    CUBE, SPHERE, TORUS,
}

//Possible improvement if reused on many places
//fun String.toShapeOrDefault(default: Shapes = Shapes.SPHERE): Shapes =
//    try {
//        Shapes.valueOf(this.uppercase())
//    } catch (e: IllegalArgumentException) {
//        default
//    }