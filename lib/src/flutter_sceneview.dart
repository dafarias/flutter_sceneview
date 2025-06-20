import 'package:flutter_sceneview/flutter_sceneview_platform_interface.dart';

import 'entities/arcore_hit_test_result.dart';

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

  Future<List<ArCoreHitTestResult>> performHitTest(double x, double y) {
    return FlutterSceneviewPlatform.instance.performHitTest(x, y);
  }
}
