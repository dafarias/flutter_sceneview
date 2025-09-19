import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sceneview/flutter_sceneview.dart';

import 'flutter_sceneview_platform_interface.dart';

/// An implementation of [FlutterSceneViewPlatform] that uses method channels.
class MethodChannelFlutterSceneView extends FlutterSceneViewPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_sceneview');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }

  @override
  Future<bool?> hasRegisteredView() async {
    final isReady = await methodChannel.invokeMethod<bool>('isReady');
    return isReady ?? true;
  }

  @override
  Future<bool?> checkPermissions() async {
    final hasCameraPermissions = await methodChannel.invokeMethod<bool>(
      'checkPermissions',
    );
    return hasCameraPermissions;
  }

  @override
  Future<ARCoreAvailability> checkARCoreStatus() async {
    final result = await methodChannel.invokeMethod('checkARCoreStatus');

    var availability = ARCoreAvailability.unknownError;

    if (result != null) {
      final statusString = result['status'] as String;
      availability = ARCoreAvailability.fromStatusString(statusString);
    }

    return availability;
  }

  @override
  Future<ARCoreInstallStatus> requestARCoreInstall() async {
    final result = await methodChannel.invokeMethod('requestARCoreInstall');
    if (result != null) {
      final statusString = result['status'] as String;
      return  ARCoreInstallStatus.fromStatusString(statusString);
    }

    return ARCoreInstallStatus.installRequested;
  }
}
