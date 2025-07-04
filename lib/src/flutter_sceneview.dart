import 'package:flutter_sceneview/flutter_sceneview_platform_interface.dart';
import 'package:flutter_sceneview/src/models/nodes/node.dart';

// The methods defined here are the ones exposed into the
// final _flutterSceneviewPlugin = FlutterSceneview(); instance.

// Method defined inside MethodChannelFlutterSceneview are private to the
// internal implementation, and hidden to the app implementation side

//TODO: Public entry of the plugin
class FlutterSceneview {
  Future<String?> getPlatformVersion() {
    return FlutterSceneviewPlatform.instance.getPlatformVersion();
  }

  Future<bool?> hasRegisteredView() {
    return FlutterSceneviewPlatform.instance.hasRegisteredView();
  }

  Future<bool?> checkPermissions() {
    return FlutterSceneviewPlatform.instance.checkPermissions();
  }

  Future<Node?> addNode({double x = 0, double y = 0, String? fileName}) {
    return FlutterSceneviewPlatform.instance.addNode(
      x: x,
      y: y,
      fileName: fileName,
    );
  }
}
