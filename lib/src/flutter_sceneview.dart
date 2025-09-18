import 'package:flutter/foundation.dart';
import 'package:flutter_sceneview/flutter_sceneview.dart';
import 'package:flutter_sceneview/flutter_sceneview_platform_interface.dart';

// The methods defined here are the ones exposed into the
// final _flutterSceneviewPlugin = FlutterSceneview(); instance.

// Method defined inside MethodChannelFlutterSceneview are private to the
// internal implementation, and hidden to the app implementation side

//TODO: Public entry of the plugin

class FlutterSceneView {
  Future<String?> getPlatformVersion() {
    return FlutterSceneViewPlatform.instance.getPlatformVersion();
  }

  Future<bool?> hasRegisteredView() {
    return FlutterSceneViewPlatform.instance.hasRegisteredView();
  }

  Future<bool?> checkPermissions() {
    return FlutterSceneViewPlatform.instance.checkPermissions();
  }

  Future<Node?> addNode({double x = 0, double y = 0, String? fileName}) {
    return FlutterSceneViewPlatform.instance.addNode(
      x: x,
      y: y,
      fileName: fileName,
    );
  }

  Future<Node?> addShapeNode(BaseShape shape, {double x = 0, double y = 0}) {
    return FlutterSceneViewPlatform.instance.addShapeNode(shape);
  }

  Future<Node?> addTextNode(
    String text, {
    double x = 0,
    double y = 0,
    double size = 1,
    String? fontFamily,
  }) {
    return FlutterSceneViewPlatform.instance.addTextNode(
      text,
      x: x,
      y: y,
      size: size,
      fontFamily: fontFamily,
    );
  }

  Future<List<HitTestResult>> performHitTest(double x, double y) {
    return FlutterSceneViewPlatform.instance.performHitTest(x, y);
  }

  Future<Uint8List> sceneSnapshot() {
    return FlutterSceneViewPlatform.instance.sceneSnapshot();
  }

  Future<ARCoreAvailability> checkARCore() async {
    return FlutterSceneViewPlatform.instance.checkARCoreStatus();
  }

  Future<ARCoreInstallStatus> requestARCoreInstall() async {
    return FlutterSceneViewPlatform.instance.requestARCoreInstall();
  }
}
