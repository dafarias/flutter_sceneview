import 'package:flutter_sceneview/src/entities/arcore_hit_test_result.dart';
import 'package:flutter_sceneview/src/views/node.dart';
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

  Future<void> init(int sceneId) {
    throw UnimplementedError('init() has not been implemented.');
  }

  Future<bool?> hasRegisteredView() {
    throw UnimplementedError('hasRegisteredView() has not been implemented.');
  }

  Future<bool?> checkPermissions() {
    throw UnimplementedError('checkPermissions() has not been implemented.');
  }

  void addNode(SceneViewNode node) {
    throw UnimplementedError('addNode() has not been implemented.');
  }

  Future<List<ArCoreHitTestResult>> performHitTest(double x, double y) {
    throw UnimplementedError("performHitTest() has not been implemented");
  }

  void dispose(int sceneId){
    throw UnimplementedError('dispose() has not been implemented.');
  }
}
