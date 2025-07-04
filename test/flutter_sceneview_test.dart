import 'package:flutter_sceneview/flutter_sceneview.dart';
import 'package:flutter_sceneview/src/flutter_sceneview.dart';
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
  Future<Node> addNode({double x = 0, double y = 0, String? fileName}) {
    // TODO: implement addNode
    throw UnimplementedError();
  }

  @override
  Future<void> removeAllNodes() {
    // TODO: implement removeAllNodes
    throw UnimplementedError();
  }

  @override
  Future<void> removeNode({required String nodeId}) {
    // TODO: implement removeNode
    throw UnimplementedError();
  }
}

void main() {
  final FlutterSceneviewPlatform initialPlatform =
      FlutterSceneviewPlatform.instance;

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
