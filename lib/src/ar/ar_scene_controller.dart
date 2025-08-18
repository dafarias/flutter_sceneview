import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sceneview/flutter_sceneview.dart';
import 'package:flutter_sceneview/src/logging/node_logs.dart';
import 'package:flutter_sceneview/src/utils/scene_render.dart';

class ARSceneController {
  final int sceneId;
  final GlobalKey arViewKey;
  final MethodChannel _arChannel = const MethodChannel('ar_view_wrapper');

  static late ARSceneController instance;
  bool _initialized = false;

  ARSceneController._({required this.sceneId, required this.arViewKey});

  bool get isInitialized => _initialized;

  RenderBox? get sceneRenderBox {
    return arViewKey.currentContext?.findRenderObject() as RenderBox?;
  }

  /// Must be called before accessing [instance].
  static Future<ARSceneController> init({
    required int sceneId,
    required GlobalKey arViewKey,
  }) async {
    final controller = ARSceneController._(
      sceneId: sceneId,
      arViewKey: arViewKey,
    );
    instance = controller;
    await controller._init();
    return controller;
  }

  Future<void> _init() async {
    if (isInitialized) return;

    SceneUtils.arViewKey = arViewKey;
    await _arChannel.invokeMethod('init');
    _initialized = true;
  }


  // TODO: Add node, and addNodeWithTransform. One uses the hit test
  // to place the node, and the other uses the provided transformation
  // Add transform node as well



  //TODO: Maybe its better to return null if the node is empty or if an exception
  // occurs, rather than returning an empty node
  Future<Node> addNode({
    double? x,
    double? y,
    String? fileName,
    bool test = false,
  }) async {
    final args = <String, dynamic>{};
    try {
      final info = SceneUtils.renderInfo;

      if (info == null) throw Exception("Missing render info");

      if (sceneRenderBox == null) {
        debugPrint("AR View RenderBox is null");
        return Node.empty;
      }

      if (test) {
        args['test'] = true;
        args['fileName'] = fileName;
      } else if (x != null && y != null) {
        args['fileName'] = fileName;
        args['x'] = x;
        args['y'] = y;
        args['renderInfo'] = info.toJson();
      } else {
        throw MissingPositionException(
          'Missing RenderInfo or invalid x/y coordinates',
        );
      }

      final result = await _arChannel.invokeMethod('addNode', args);
      return Node.fromJson(Map<String, dynamic>.from(result));
    } on PlatformException catch (e) {
      debugPrint("AR Platform Error: ${e.message}");
    } catch (e) {
      debugPrint("AR Controller error: $e");
    }

    return Node.empty;
  }

  Future<Node> addShapeNode(BaseShape shape) async {
    try {
      final shapeMap = shape.toMap();
      final result = await _arChannel.invokeMethod('addShapeNode', shapeMap);
      return Node.fromJson(Map<String, dynamic>.from(result));
    } catch (e) {
      debugPrint("Failed to place shape node in the AR scene: $e");
    }
    return Node.empty;
  }

  Future<Node> addTextNode(
    String text, {
    required double x,
    required double y,
    double size = 1,
    String? fontFamily,
  }) async {
    final args = <String, dynamic>{};
    try {
      assert(text.isNotEmpty, 'Text cannot be empty');
      assert(size > 0, 'Size must be positive and greater than 0');

      //Required arguments
      args['x'] = x;
      args['y'] = y;
      args['text'] = text;
      args['size'] = size;
      args['renderInfo'] = SceneUtils.renderInfo?.toJson();

      // Optional fontFamily
      if (fontFamily != null && fontFamily.isNotEmpty) {
        args['fontFamily'] = fontFamily;
      }

      final result = await _arChannel.invokeMethod('addTextNode', args);
      if (result == null) throw Exception('addTextNode returned null');

      return Node.fromJson(result);
    } catch (e) {
      debugPrint(e.toString());
      return Node.empty;
    }
  }

  // TODO: Return value if node was succesfully removed so people can
  // remove it from the list used to track placed nodes
  Future<void> removeNode({required String nodeId}) async {
    try {
      final args = <String, dynamic>{};
      args['nodeId'] = nodeId;
      await _arChannel.invokeMethod('removeNode', args);
    } catch (e) {
      debugPrint("AR Controller error: $e");
    }
  }

  Future<void> removeAllNodes() async {
    try {
      await _arChannel.invokeMethod('removeAllNodes');
    } catch (e) {
      debugPrint("AR Controller error: $e");
    }
  }

  Future<List<HitTestResult>> hitTest({
    required double x,
    required double y,
  }) async {
    try {
      final hitTestResultRaw = await _arChannel.invokeMethod<List<dynamic>?>(
        'performHitTest',
        {'x': x, 'y': y, 'renderInfo': SceneUtils.renderInfo?.toJson()},
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
      await _arChannel.invokeMethod('dispose', sceneId);
    } catch (e) {
      debugPrint('ARSceneController dispose error: $e');
    }
    _initialized = false;
  }
}
