import 'arcore_shape.dart';

class ArCoreSphere extends ArCoreShape {
  ArCoreSphere(super.node, {this.radius = 0.5, required super.material});

  final double radius;

  @override
  Map<String, dynamic> toMap() =>
      <String, dynamic>{'radius': radius}..addAll(super.toMap());
}
