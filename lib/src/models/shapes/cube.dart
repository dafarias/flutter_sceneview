import 'package:flutter_sceneview/src/models/shapes/base_shape.dart';
import 'package:flutter_sceneview/src/models/shapes/shapes.dart';

class Cube extends BaseShape {
  Cube(
    super.node, {
    this.dx = 0,
    this.dy = 0,
    this.center = 0,
    required super.material,
  });

  final double dx;
  final double dy;

  final double center;

  @override
  Shapes get shapeType => Shapes.cube;

  @override
  Map<String, dynamic> toMap() =>
      <String, dynamic>{'dx': dx, 'dy': dy, 'center': center}
        ..addAll(super.toMap());
}
