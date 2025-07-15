import 'base_shape.dart';

class Sphere extends BaseShape {
  Sphere(super.node, {this.radius = 0.5, required super.material});

  final double radius;

  @override
  Map<String, dynamic> toMap() =>
      <String, dynamic>{'radius': radius}..addAll(super.toMap());
}
