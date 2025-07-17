import 'package:flutter_sceneview/src/models/shapes/shapes.dart';
import 'base_shape.dart';

class Sphere extends BaseShape {
  Sphere(super.node, {this.radius = 0.5, required super.material});

  final double radius;

  @override
  Shapes get shapeType => Shapes.sphere;

  @override
  Map<String, dynamic> toMap() =>
      <String, dynamic>{'radius': radius}..addAll(super.toMap());
}
