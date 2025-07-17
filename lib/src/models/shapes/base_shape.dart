import 'package:flutter/material.dart';
import 'package:flutter_sceneview/src/models/materials/base_material.dart';
import 'package:flutter_sceneview/src/models/nodes/node.dart';
import 'package:flutter_sceneview/src/models/shapes/shapes.dart';

abstract class BaseShape {
  BaseShape(this.node, {required BaseMaterial material})
    : material = ValueNotifier(material);

  final ValueNotifier<BaseMaterial> material;
  //Todo: I dont think the shape should depend on the node impl. In any case,
  // it could be the other way aroud. A node could be a shape node, and if it happens
  // then it should have a shape attached to it
  final Node node;

  Shapes get shapeType;

  Map<String, dynamic> toMap() => <String, dynamic>{
    'shapeType': shapeType.toUpper,
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
  }..removeWhere((String k, dynamic v) => v == null);
}
