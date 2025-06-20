import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_sceneview_platform_interface.dart';

/// An implementation of [FlutterSceneviewPlatform] that uses method channels.
class MethodChannelFlutterSceneview extends FlutterSceneviewPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_sceneview');
  final arViewChannel = MethodChannel('ar_view_wrapper');

  //Method calls should be placed inside this file
  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }

  @override
  Future<void> init(int sceneId) async {
    await arViewChannel.invokeMethod<String>('init');
  }

  @override
  Future<bool?> hasRegisteredView() async {
    final isReady = await methodChannel.invokeMethod<bool>('isReady');
    return isReady;
  }


  @override
  Future<bool?> checkPermissions() async {
    final hasCameraPermissions = await methodChannel.invokeMethod<bool>('checkPermissions');
    return hasCameraPermissions;
  }
}


