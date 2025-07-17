import 'package:flutter_sceneview/src/models/shapes/shapes.dart';
import 'base_shape.dart';

class Torus extends BaseShape {
  Torus(
    super.node, {
    this.majorRadius = 0.5,
    this.minorRadius = 0.1,
    required super.material,
  });

  final double majorRadius;
  final double minorRadius;

  @override
  Shapes get shapeType => Shapes.torus;

  @override
  Map<String, dynamic> toMap() =>
      <String, dynamic>{'majorRadius': majorRadius, 'minorRadius': minorRadius}
        ..addAll(super.toMap());
}
