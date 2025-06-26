import 'package:flutter_sceneview/flutter_sceneview_platform_interface.dart';

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
}
