import 'package:flutter/services.dart';
import 'package:flutter_sceneview/src/models/render/render_info.dart';
import 'package:flutter_sceneview/src/utils/channels.dart';

class NodeChannel {
  static final _channel = MethodChannel(Channels.node);

  //NodeResult
  Future<void> addNode({
    required String fileName,
    required double x,
    required double y,
    required RenderInfo renderInfo,
    bool testPlacement = false,
  }) async {
    try {
      final result = await _channel
          .invokeMethod<Map<dynamic, dynamic>>('addNode', {
            'fileName': fileName,
            'x': x,
            'y': y,
            'renderInfo': renderInfo.toJson(),
            'test': testPlacement,
          });
      // return NodeResult.fromMap(result ?? {});
    } catch (e) {
      // return NodeResult.failed(e.toString());
    }
  }

  // Similarly for addShapeNode, removeNode, removeAllNodes, hitTest, addTextNode
  // Example for removeNode:
  Future<bool> removeNode(String nodeId) async {
    try {
      await _channel.invokeMethod('removeNode', {'nodeId': nodeId});
      return true;
    } catch (e) {
      return false;
    }
  }
}
