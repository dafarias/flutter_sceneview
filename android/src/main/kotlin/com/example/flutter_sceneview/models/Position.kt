package com.example.flutter_sceneview.models

import io.github.sceneview.math.Position

fun Position.toMap(): Map<String, Float> = mapOf(
    "x" to x,
    "y" to y,
    "z" to z,
)