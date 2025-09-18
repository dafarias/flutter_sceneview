import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sceneview/src/models/models.dart';

class SessionChannel {
  final MethodChannel _channel;
  final int viewId;

  SessionChannel(this._channel, [this.viewId = 0]) {
    _init();
  }

  final StreamController<ARTrackingEvent> _eventStreamController =
      StreamController.broadcast();

  /// Public stream to listen for session events
  Stream<ARTrackingEvent> get trackingEvents => _eventStreamController.stream;

  Future<void> _init() async {
    _trackSession();
  }

  Future<void> _trackSession() async {
    try {
      _channel.setMethodCallHandler(_onNativeCallback);
      await _channel.invokeMethod('trackSession');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  ///Todo: Not implemented yet
  Future<void> reloadSession() async {
    await _channel.invokeMethod('reloadSession');
  }


  Future<void> dispose() async {
    try {
      await _channel.invokeMethod('dispose', viewId);
      await _eventStreamController.close();
    } catch (e) {
      debugPrint('SessionChannel dispose error: $e');
    }
  }

  /// Handle events coming from Kotlin
  Future<void> _onNativeCallback(MethodCall call) async {
    switch (call.method) {
      case "trackingFailure":
        _onTrackingFailure(call);
        break;

      case "trackingChanged":
        _onTrackingChanged(call);
        break;

      default:
        debugPrint("Unknown method from native: ${call.method}");
    }
  }

  Future<void> _onTrackingChanged(MethodCall call) async {
    if (call.arguments == null) {
      debugPrint("_onTrackingChanged: No arguments provided");
      return;
    }
    try {
      // Expect call.arguments to be a Map<String, dynamic> from Kotlin
      final map = Map<String, dynamic>.from(call.arguments);

      // Parse state (required)
      final stateString = map['state'] as String?;
      if (stateString == null) {
        debugPrint("_onTrackingChanged: Missing state");
        return;
      }
      final trackingState = TrackingState.fromTypeName(stateString);

      // Parse reason (optional)
      final reasonString = map['reason'] as String?;
      final failureReason = reasonString != null
          ? TrackingFailure.fromTypeName(reasonString)
          : null;

      // Create and add event to stream
      final event = ARTrackingEvent(
        state: trackingState,
        failureReason: failureReason,
      );
      _eventStreamController.add(event);

      debugPrint("_onTrackingChanged: $event");
    } catch (e) {
      debugPrint("_onTrackingChanged: Error parsing arguments - $e");
    }
  }

  Future<void> _onTrackingFailure(MethodCall call) async {
    if (call.arguments == null) {
      debugPrint("_onTrackingFailure: No arguments provided");
      return;
    }
    try {
      final map = Map<String, dynamic>.from(call.arguments);
      final trackingState = TrackingState.fromTypeName(
        map['state'] as String? ?? "",
      );

      final reasonString = map['reason'] as String?;
      final failureReason = (reasonString) != null
          ? TrackingFailure.fromTypeName(reasonString)
          : null;

      final event = ARTrackingEvent(
        state: trackingState,
        failureReason: failureReason,
      );
      _eventStreamController.add(event);

      debugPrint("_onTrackingFailure: $event");
    } catch (e) {
      debugPrint("_onTrackingFailure: Error parsing arguments - $e");
    }
  }
}
