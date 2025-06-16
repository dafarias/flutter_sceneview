import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_sceneview_method_channel.dart';

abstract class FlutterSceneviewPlatform extends PlatformInterface {
  /// Constructs a FlutterSceneviewPlatform.
  FlutterSceneviewPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterSceneviewPlatform _instance = MethodChannelFlutterSceneview();

  /// The default instance of [FlutterSceneviewPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterSceneview].
  static FlutterSceneviewPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterSceneviewPlatform] when
  /// they register themselves.
  static set instance(FlutterSceneviewPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
