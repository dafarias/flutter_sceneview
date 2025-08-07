import 'package:vector_math/vector_math_64.dart';

class Pose {
  late Vector3 position;
  late Vector3 rotation;
  late Vector4 quaternion;

  Pose.fromMap(Map<dynamic, dynamic> map) {
    position = Vector3.array(map["position"]);
    rotation = Vector3.array(map["rotation"]);
    quaternion = Vector4.array(map["quaternion"]);
  }
}
