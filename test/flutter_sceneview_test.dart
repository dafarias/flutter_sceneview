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
