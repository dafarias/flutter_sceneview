import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sceneview/src/models/session/session_event.dart';
import 'package:flutter_sceneview/src/models/session/tracking.dart';

class ARSessionController {
  final int sceneId;
  final MethodChannel _sessionChannel = const MethodChannel('ar_session');

  static late ARSessionController instance;

  ARSessionController._({required this.sceneId});

  final StreamController<ARTrackingEvent> _eventStreamController =
      StreamController.broadcast();

  /// Public stream to listen for session events
  Stream<ARTrackingEvent> get trackingEvents => _eventStreamController.stream;

  /// Must be called before accessing [instance].
  static Future<ARSessionController> init({required int sceneId}) async {
    final controller = ARSessionController._(sceneId: sceneId);
    instance = controller;
    await controller._init();
    return controller;
  }

  Future<void> _init() async {
    _trackSession();
  }

  Future<void> _trackSession() async {
    try {
      _sessionChannel.setMethodCallHandler(_onNativeCallback);
      await _sessionChannel.invokeMethod('trackSession');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> dispose() async {
    try {
      await _sessionChannel.invokeMethod('dispose', sceneId);
      await _eventStreamController.close();
    } catch (e) {
      debugPrint('ARSessionController dispose error: $e');
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
