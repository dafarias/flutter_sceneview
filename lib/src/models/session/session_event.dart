
import 'package:flutter_sceneview/src/models/session/tracking.dart';

class ARTrackingEvent {
  final TrackingState state;
  final TrackingFailure? failureReason;

  ARTrackingEvent({required this.state, this.failureReason});

  @override
  String toString() => 'ARTrackingEvent(state: $state, failureReason: $failureReason)';

}
