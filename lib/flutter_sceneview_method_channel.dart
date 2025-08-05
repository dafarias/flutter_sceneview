import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sceneview/flutter_sceneview.dart';

import 'flutter_sceneview_platform_interface.dart';

/// An implementation of [FlutterSceneviewPlatform] that uses method channels.
class MethodChannelFlutterSceneview extends FlutterSceneviewPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_sceneview');

  //Todo: Will be moved to its own method channel handler
  final sceneChannel = const MethodChannel('ar_scene');

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
    return isReady;
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

  @override
  Future<Uint8List> sceneSnapshot() async {
    final imageBytes = await sceneChannel.invokeMethod<Uint8List>(
      'takeSnapshot',
    );
    return imageBytes ?? Uint8List.fromList([]);
  }
}
