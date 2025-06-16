import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_sceneview_platform_interface.dart';

/// An implementation of [FlutterSceneviewPlatform] that uses method channels.
class MethodChannelFlutterSceneview extends FlutterSceneviewPlatform {
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

}

//Method calls should be placed inside this file