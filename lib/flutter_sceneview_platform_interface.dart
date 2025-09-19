import 'package:flutter_sceneview/flutter_sceneview.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'flutter_sceneview_method_channel.dart';

abstract class FlutterSceneViewPlatform extends PlatformInterface {
  /// Constructs a FlutterSceneviewPlatform.
  FlutterSceneViewPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterSceneViewPlatform _instance = MethodChannelFlutterSceneView();

  /// The default instance of [FlutterSceneViewPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterSceneView].
  static FlutterSceneViewPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterSceneViewPlatform] when
  /// they register themselves.
  static set instance(FlutterSceneViewPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> init(int sceneId) {
    throw UnimplementedError('init() has not been implemented.');
  }

  Future<bool?> hasRegisteredView() {
    throw UnimplementedError('hasRegisteredView() has not been implemented.');
  }

  Future<bool?> checkPermissions() {
    throw UnimplementedError('checkPermissions() has not been implemented.');
  }

  void dispose(int sceneId) {
    throw UnimplementedError('dispose() has not been implemented.');
  }

  Future<ARCoreAvailability> checkARCoreStatus() {
    throw UnimplementedError('checkARCoreStatus() has not been implemented.');
  }

  Future<ARCoreInstallStatus> requestARCoreInstall() {
    throw UnimplementedError('requestARCoreInstall() has not been implemented.');
  }
}
