/// Describes the tracking state of the Trackable.
enum TrackingState {
  /// ARCore has paused tracking this instance but may resume tracking later.
  /// This may occur if device tracking is lost, user enters a new space, or the session is paused.
  paused,

  /// ARCore has stopped tracking this Trackable and will never resume tracking it.
  stopped,

  /// The Trackable is currently tracked and its pose is current.
  tracking;

  /// Returns the enum name in UPPERCASE (e.g., 'PAUSED') for consistency.
  String get toUpper => name.toUpperCase();

  String get _normalizedName {
    // Remove underscores, spaces, and convert to lowercase
    return name.replaceAll('_', '').replaceAll(' ', '').toLowerCase();
  }

  /// Parses a string into a [TrackingState] value with normalization.
  /// Trims whitespace and case-insensitive matching.
  /// Defaults to [TrackingState.paused] if not found.
  static TrackingState fromTypeName(String type) {
    if (type.isEmpty) {
      return TrackingState.stopped;
    }

    // Normalize input: remove underscores, spaces, and convert to lowercase
    final normalized = type
        .trim()
        .replaceAll('_', '')
        .replaceAll(' ', '')
        .toLowerCase();

    return TrackingState.values.firstWhere(
      (e) => e._normalizedName == normalized,
      orElse: () => TrackingState.paused,
    );
  }
}

/// Represents reasons why AR motion tracking may fail or be paused.
enum TrackingFailure {
  /// Motion tracking lost due to bad internal state.
  /// No specific user action is likely to resolve this issue.
  badState,

  /// Motion tracking paused because the camera is in use by another application.
  /// Tracking will resume once this app regains priority or once all higher priority
  /// apps stop using the camera.
  ///
  /// Prior to ARCore SDK 1.13, [TrackingFailure.none] was returned instead.
  cameraUnavailable,

  /// Motion tracking lost due to excessive motion.
  /// Ask the user to move the device more slowly.
  excessiveMotion,

  /// Motion tracking lost due to insufficient visual features.
  /// Ask the user to move to a different area and avoid blank walls or featureless surfaces.
  insufficientFeatures,

  /// Motion tracking lost due to poor lighting conditions.
  /// Ask the user to move to a more brightly lit area.
  ///
  /// On Android 12 (API level 31) or later, this may also occur if the user
  /// has disabled camera access, causing ARCore to receive a blank camera feed.
  insufficientLight,

  /// Indicates expected motion tracking behavior.
  /// Always returned when tracking state is [TrackingState.tracking].
  /// When tracking state is [TrackingState.paused], it indicates normal initialization.
  none;

  String get toUpper => name.toUpperCase();

  String get _normalizedName {
    // Remove underscores, spaces, and convert to lowercase
    return name.replaceAll('_', '').replaceAll(' ', '').toLowerCase();
  }

  static TrackingFailure fromTypeName(String type) {
    if (type.isEmpty) {
      return TrackingFailure.none;
    }

    // Normalize input: remove underscores, spaces, and convert to lowercase
    final normalized = type
        .trim()
        .replaceAll('_', '')
        .replaceAll(' ', '')
        .toLowerCase();

    return TrackingFailure.values.firstWhere(
      (e) => e._normalizedName == normalized,
      orElse: () => TrackingFailure.none,
    );
  }
}
