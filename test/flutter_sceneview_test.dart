import 'package:flutter/foundation.dart';
import 'package:flutter_sceneview/flutter_sceneview.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_sceneview/flutter_sceneview_platform_interface.dart';
import 'package:flutter_sceneview/flutter_sceneview_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterSceneviewPlatform
    with MockPlatformInterfaceMixin
    implements FlutterSceneViewPlatform {
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

  @override
  Future<Node?> addShapeNode(BaseShape shape, {double x = 0, double y = 0}) {
    // TODO: implement addShapeNode
    throw UnimplementedError();
  }

  @override
  Future<List<HitTestResult>> performHitTest(double x, double y) {
    // TODO: implement performHitTest
    throw UnimplementedError();
  }

  @override
  Future<Uint8List> sceneSnapshot() {
    // TODO: implement sceneSnapshot
    throw UnimplementedError();
  }

  @override
  Future<Node?> addTextNode(
    String text, {
    double x = 0,
    double y = 0,
    double size = 1,
    String? fontFamily,
    bool normalize = false,
  }) {
    // TODO: implement addTextNode
    throw UnimplementedError();
  }
  
  @override
  Future<ARCoreAvailability> checkARCoreStatus() {
    // TODO: implement checkARCore
    throw UnimplementedError();
  }
  
  @override
  Future<ARCoreInstallStatus> requestARCoreInstall() {
    // TODO: implement requestARCoreInstall
    throw UnimplementedError();
  }
}

void main() {
  final FlutterSceneViewPlatform initialPlatform =
      FlutterSceneViewPlatform.instance;

  test('$MethodChannelFlutterSceneView is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterSceneView>());
  });

  test('getPlatformVersion', () async {
    FlutterSceneView flutterSceneviewPlugin = FlutterSceneView();
    MockFlutterSceneviewPlatform fakePlatform = MockFlutterSceneviewPlatform();
    FlutterSceneViewPlatform.instance = fakePlatform;

    expect(await flutterSceneviewPlugin.getPlatformVersion(), '42');
  });
}
