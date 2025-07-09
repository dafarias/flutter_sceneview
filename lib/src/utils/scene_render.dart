import 'package:flutter/material.dart';
import 'package:flutter_sceneview/src/models/render/render_info.dart';

class SceneUtils {
  static GlobalKey? arViewKey;

  /// Returns RenderInfo (position, size, pixelRatio) or null if unavailable
  static RenderInfo? get renderInfo {
    if (arViewKey == null) {
      debugPrint("SceneUtils: Scene view global key is null. Initialize util");
      return null;
    }

    final context = arViewKey!.currentContext;
    if (context == null) {
      debugPrint("SceneUtils: context is null");
      return null;
    }

    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) {
      debugPrint("SceneUtils: RenderBox is null");
      return null;
    }

    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;
    final pixelRatio = MediaQuery.of(context).devicePixelRatio;

    return RenderInfo(position: position, size: size, pixelRatio: pixelRatio);
  }

  /// Normalizes an arbitrary logical (x, y) coordinate to the widget's local normalized coords (0..1)
  static Offset? normalizePoint(double xLogical, double yLogical) {
    final info = renderInfo;
    if (info == null) {
      debugPrint("SceneUtils: Cannot normalize point, renderInfo is null");
      return null;
    }

    final adjustedX = xLogical * info.pixelRatio;
    final adjustedY = yLogical * info.pixelRatio;

    final adjustedPosX = info.position.dx * info.pixelRatio;
    final adjustedPosY = info.position.dy * info.pixelRatio;

    final adjustedWidth = info.size.width * info.pixelRatio;
    final adjustedHeight = info.size.height * info.pixelRatio;

    final localX = ((adjustedX - adjustedPosX) / adjustedWidth).clamp(0.0, 1.0);
    final localY = ((adjustedY - adjustedPosY) / adjustedHeight).clamp(
      0.0,
      1.0,
    );

    return Offset(localX, localY);
  }

  /// Gets the normalized center point of the AR view widget (0.5, 0.5 if no offsets)
  static Offset? getNormalizedCenter() {
    final info = renderInfo;
    if (info == null) {
      debugPrint("SceneUtils: Cannot get center, renderInfo is null");
      return null;
    }

    final centerX = info.position.dx + info.size.width / 2;
    final centerY = info.position.dy + info.size.height / 2;

    return normalizePoint(centerX, centerY);
  }

}