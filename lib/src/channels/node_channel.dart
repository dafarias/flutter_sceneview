import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sceneview/src/models/models.dart';
import 'package:flutter_sceneview/src/utils/scene_render.dart';

class NodeChannel {
  final MethodChannel _channel;

  NodeChannel(this._channel);

  Future<SceneNode?> createAnchorNode({
    required double x,
    required double y,
    SceneNode? node,
    bool normalize = false,
  }) async {
    final args = <String, dynamic>{};
    try {
      args['node'] = node?.toJson();
      args['x'] = x;
      args['y'] = y;

      if (normalize) {
        args['normalize'] = true;
        args['renderInfo'] = SceneUtils.renderInfo?.toJson();
      }

      final result = await _channel.invokeMethod('createAnchorNode', args);
      if (result == null) {
        throw Exception('createAnchorNode: Null value returned as SceneNode');
      }

      return SceneNode.fromJson(Map<String, dynamic>.from(result));
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<void> createNode({
    required double x,
    required double y,
    SceneNode? node,
  }) async {
    final args = <String, dynamic>{};
    try {
      args['node'] = node?.toJson();
      args['x'] = x;
      args['y'] = y;

      await _channel.invokeMethod('createNode', args);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> testMethod({bool ex = false}) async {
    final args = <String, dynamic>{};
    try {
      await _channel.invokeMethod('testAnchor', args);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> addNode({SceneNode? node, bool testPlacement = false}) async {
    final args = <String, dynamic>{};
    try {
      await _channel.invokeMethod('addNode', args);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> addChildNode({SceneNode? parent, SceneNode? child}) async {
    final args = <String, dynamic>{};
    try {
      await _channel.invokeMethod('addChildNode', args);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<bool> removeNode({required String nodeId}) async {
    try {
      final args = <String, dynamic>{};
      args['nodeId'] = nodeId;
      await _channel.invokeMethod('removeNode', args);
      return true;
    } catch (e) {
      debugPrint("removeNode with id: $nodeId: $e");
      return false;
    }
  }

  Future<bool> removeAllNodes() async {
    try {
      await _channel.invokeMethod('removeAllNodes');
      return true;
    } catch (e) {
      debugPrint("removeAllNodes: $e");
      return false;
    }
  }

  Future<List<HitTestResult>> hitTest({
    required double x,
    required double y,
    bool normalize = false,
    bool withFrame = true,
  }) async {
    try {
      final args = <String, dynamic>{};

      args['x'] = x;
      args['y'] = y;

      if (normalize) {
        args['normalize'] = true;
        args['renderInfo'] = SceneUtils.renderInfo?.toJson();
      }

      final hitTestResultRaw = await _channel.invokeMethod<List<dynamic>?>(
        'performHitTest',
        args,
      );

      final hitTestResult =
          hitTestResultRaw
              ?.map((item) => HitTestResult.fromMap(item))
              .toList() ??
          [];
      return hitTestResult;
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<void> dispose() async {
    try {
      await _channel.invokeMethod('dispose', "sceneId");
    } catch (e) {
      debugPrint('NodeChannel dispose error: $e');
    }
    // _initialized = false;
  }
}
