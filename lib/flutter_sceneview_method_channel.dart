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
  Future<Node?> addNode({double x = 0, double y = 0, String? fileName}) async {
    return await ARSceneController.instance.addNode(
      x: x,
      y: y,
      fileName: fileName,
    );
  }

  @override
  Future<Node?> addShapeNode(
    BaseShape shape, {
    double x = 0,
    double y = 0,
  }) async {
    return await ARSceneController.instance.addShapeNode(shape);
  }

  @override
  Future<bool?> checkPermissions() async {
    final hasCameraPermissions = await methodChannel.invokeMethod<bool>(
      'checkPermissions',
    );
    return hasCameraPermissions;
  }

  @override
  Future<Node?> addTextNode(
    String text, {
    double x = 0,
    double y = 0,
    double size = 1,
    String? fontFamily,
    bool normalize = false,
  }) async {
    return await ARSceneController.instance.addTextNode(
      text,
      x: x,
      y: y,
      size: size,
      fontFamily: fontFamily,
      normalize: normalize,
    );
  }

  @override
  Future<List<HitTestResult>> performHitTest(double x, double y) async {
    return await ARSceneController.instance.hitTest(x: x, y: y);
  }

  @Deprecated('Method will be replaced by the scene handled method')
  @override
  Future<Uint8List> sceneSnapshot() async {
    throw UnimplementedError('sceneSnapshot() has not been implemented.');
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
