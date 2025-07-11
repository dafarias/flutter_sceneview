import 'package:flutter/material.dart';
import 'package:flutter_sceneview/src/models/models.dart';

import 'arcore_material.dart';

abstract class ArCoreShape {
  ArCoreShape(this.node, {required ArCoreMaterial material})
      : material = ValueNotifier(material);

  final ValueNotifier<ArCoreMaterial> material;
  final Node node;

  Map<String, dynamic> toMap() =>
      <String, dynamic>{
        'shapeType': runtimeType.toString(),
        'material': material.value.toMap(),
        'position': {
          'x': node.position.x,
          'y': node.position.y,
          'z': node.position.z,
        },
        'rotation': {
          'x': node.rotation?.x,
          'y': node.rotation?.y,
          'z': node.rotation?.z,
        },
        'scale': node.scale,
      }
        ..removeWhere((String k, dynamic v) => v == null);
}
