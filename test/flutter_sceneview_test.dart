import 'package:flutter_sceneview/src/entities/arcore_hit_test_result.dart';
import 'package:flutter_sceneview/src/flutter_sceneview.dart';
import 'package:flutter_sceneview/src/views/node.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_sceneview/flutter_sceneview_platform_interface.dart';
import 'package:flutter_sceneview/flutter_sceneview_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterSceneviewPlatform
    with MockPlatformInterfaceMixin
    implements FlutterSceneviewPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  void addNode(SceneViewNode node) {
    // TODO: implement addNode
  }

  @override
  void dispose(int sceneId) {
    // TODO: implement dispose
  }

  @override
  Future<void> init(int sceneId) {
    // TODO: implement init
    throw UnimplementedError();
  }
  
  @override
  Future<bool?> hasRegisteredView() {
    // TODO: implement hasRegisteredView
    throw UnimplementedError();
  }
  
  @override
  Future<bool?> checkPermissions() {
    // TODO: implement checkPermissions
    throw UnimplementedError();
  }

  @override
  Future<List<ArCoreHitTestResult>> performHitTest(double x, double y) {
    // TODO: implement performHitTest
    throw UnimplementedError();
  }
}

void main() {
  final FlutterSceneviewPlatform initialPlatform = FlutterSceneviewPlatform.instance;

  test('$MethodChannelFlutterSceneview is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterSceneview>());
  });

  test('getPlatformVersion', () async {
    FlutterSceneview flutterSceneviewPlugin = FlutterSceneview();
    MockFlutterSceneviewPlatform fakePlatform = MockFlutterSceneviewPlatform();
    FlutterSceneviewPlatform.instance = fakePlatform;

    expect(await flutterSceneviewPlugin.getPlatformVersion(), '42');
  });
}
