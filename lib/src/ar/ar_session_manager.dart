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
    try {
      
      if (call.arguments == null) {
        debugPrint("TAG _onTrackingChanged: No arguments provided");
        return;
      }

      // Convert arguments to Map<String, dynamic>
      //TODO: WORKS
    // final Map<String, dynamic> map;
    // if (call.arguments is Map) {
    //   // Cast to Map<Object?, Object?> first, then convert keys and values
    //   map = (call.arguments as Map).cast<String, dynamic>();
    // } else {
    //   debugPrint("TAG _onTrackingChanged: Arguments are not a Map");
    //   return;
    // }


      // Expect call.arguments to be a Map<String, dynamic> from Kotlin
      final map = Map<String, dynamic>.from(call.arguments);
      // if (map == null) {
      //   debugPrint("TAG _onTrackingChanged: No arguments provided");
      //   return;
      // }

      // Parse state (required)
      final stateString = map['state'] as String?;
      if (stateString == null) {
        debugPrint("TAG _onTrackingChanged: Missing state");
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

      debugPrint("TAG _onTrackingChanged: $event");
    } catch (e) {
      debugPrint("TAG _onTrackingChanged error: $e");
    }
  }

  Future<void> _onTrackingFailure(MethodCall call) async {
    try {
      debugPrint("TAG ${call.method}");
    } catch (e) {
      debugPrint("TAG ${e.toString()}");
    }
  }
}