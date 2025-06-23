import 'package:flutter_sceneview/flutter_sceneview_platform_interface.dart';
import 'package:flutter_sceneview/src/views/node.dart';

class SceneViewController {
  SceneViewController._({required this.sceneId});

  final int sceneId;

  static Future<SceneViewController> init(int sceneId) async {
    await FlutterSceneviewPlatform.instance.init(sceneId);
    return SceneViewController._(sceneId: sceneId);
  }

  void addNode(SceneViewNode node) {
    FlutterSceneviewPlatform.instance.addNode(node);
  }

  void addTestNode({String? fileName}) {
    FlutterSceneviewPlatform.instance.addTestNode(fileName: fileName);
  }

  void dispose() {
    FlutterSceneviewPlatform.instance.dispose(sceneId);
  }
}
