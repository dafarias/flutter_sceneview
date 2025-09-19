import 'package:flutter_sceneview/flutter_sceneview.dart';
import 'package:flutter_sceneview/flutter_sceneview_platform_interface.dart';

// The methods defined here are the ones exposed into the
// final _flutterSceneviewPlugin = FlutterSceneview(); instance.

// Methods defined inside MethodChannelFlutterSceneview are private to the
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

  Future<ARCoreAvailability> checkARCore() async {
    return FlutterSceneViewPlatform.instance.checkARCoreStatus();
  }

  Future<ARCoreInstallStatus> requestARCoreInstall() async {
    return FlutterSceneViewPlatform.instance.requestARCoreInstall();
  }
}
