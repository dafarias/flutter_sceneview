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
