package com.example.flutter_sceneview.models.session

import com.google.ar.core.TrackingFailureReason
import com.google.ar.core.TrackingState
import dev.romainguy.kotlin.math.Quaternion
import io.github.sceneview.math.Position

fun TrackingState.toMap(failureReason: TrackingFailureReason? = null): Map<String, Any?> = mapOf(
    "state" to name,
    "reason" to failureReason?.name
)