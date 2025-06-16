import 'package:flutter_sceneview/flutter_sceneview_platform_interface.dart';

class FlutterSceneview {
  Future<String?> getPlatformVersion() {
    return FlutterSceneviewPlatform.instance.getPlatformVersion();
  }

  // Future example:
  // Future<void> placeObject(ARObject object) {
  //   return FlutterSceneviewPlatform.instance.placeObject(object);
  // }
}
