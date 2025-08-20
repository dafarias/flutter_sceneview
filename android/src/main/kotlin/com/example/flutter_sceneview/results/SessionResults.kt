package com.example.flutter_sceneview.results

import com.google.ar.core.TrackingFailureReason
import com.google.ar.core.TrackingState

// --- Sealed Result for Tracking ---
sealed interface TrackingResult : BaseResult {
    data class State(val state: TrackingState) : TrackingResult
    data class Failure(val reason: TrackingFailureReason?) : TrackingResult
}