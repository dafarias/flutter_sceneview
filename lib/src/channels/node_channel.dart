import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sceneview/src/models/models.dart';
import 'package:flutter_sceneview/src/utils/scene_render.dart';

class NodeChannel {
  final MethodChannel _channel;
  final int viewId;

  NodeChannel(this._channel, [this.viewId = 0]);

  Future<SceneNode?> addNode({
    SceneNode? node,
    bool testPlacement = false,
  }) async {
    final args = <String, dynamic>{};
    try {
      if (node == null) {
        throw Exception('addNode: Node is null. Cannot be added to the scene');
      }
      args['node'] = node.toJson();

      final result =
          await _channel.invokeMethod<Map<Object?, Object?>>('addNode', args)
              as Map;

      return SceneNode.fromJson(Map<String, dynamic>.from(result));
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  /// Adds a single node as child of an anchor or any other type of node. The
  /// parent will be used to search the node through all the tree. If not found then an
  /// exception will be thrown.
  ///
  /// The child node will have its [position] fixed or updated to match the
  /// transformation done by the parent node. The child node will also have its
  /// [parentId] and [isPlaced] updated if added successfully.
  Future<SceneNode?> addChildNode({
    required String parentId,
    required SceneNode child,
  }) async {
    final args = <String, dynamic>{};

    try {
      if (parentId.isEmpty) {
        throw Exception('addChildNode: Parent ID cannot be empty');
      }
      if (child.isEmpty) {
        throw Exception('addChildNode: Child node is empty');
      } else {
        args['parentId'] = parentId;
        args['child'] = child.toJson();
      }

      final result = await _channel.invokeMethod('addChildNode', args);
      if (result == null) {
        throw Exception('addChildNode: Null value returned as SceneNode');
      }

      return SceneNode.fromJson(Map<String, dynamic>.from(result));
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  /// Similar to [addChildNode], adds multiple nodes as children of an anchor or
  /// any type of node.
  ///
  /// All the children will have its [position] fixed or updated to match the
  /// transformation done by the parent node. This means that all
  /// nodes will also have its [parentId] and [isPlaced] updated if nodes were
  /// added successfully.
  Future<List<SceneNode>> addChildNodes({
    required String parentId,
    required List<SceneNode> children,
  }) async {
    final args = <String, dynamic>{};

    try {
      if (parentId.isNotEmpty && children.isNotEmpty) {
        args['parentId'] = parentId;
        args['children'] = args['children'] = children
            .map((node) => node.toJson())
            .toList();
      } else {
        throw Exception(
          'addChildNodes: Parent node has invalid id or children are empty',
        );
      }

      final result = await _channel.invokeMethod('addChildNodes', args);
      if (result == null) {
        throw Exception(
          'addChildNodes: Null value returned after adding'
          ' multiple children to a node',
        );
      }

      final nodes = (result as List<dynamic>)
          .map((e) => SceneNode.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();

      return nodes;
    } catch (e) {
      debugPrint(e.toString());
      return [];
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

  /// Creates an anchor node that is added  as direct child of the scene. After
  /// successful creation a child of the node type requested is created and
  /// added as a direct child of the anchor node.
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

  Future<bool> detachAnchor({String? anchorId}) async {
    try {
      final args = <String, dynamic>{};

      if (anchorId == null) {
        throw Exception('detachAnchor: Anchor Id cannot be null');
      }
      args['anchorId'] = anchorId;
      return await _channel.invokeMethod<bool>('detachAnchor', args) ?? true;
    } catch (e) {
      debugPrint("detachAnchor: $e");
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
        'hitTest',
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
      await _channel.invokeMethod('dispose', viewId);
    } catch (e) {
      debugPrint('NodeChannel dispose error: $e');
    }
    // _initialized = false;
  }
}
