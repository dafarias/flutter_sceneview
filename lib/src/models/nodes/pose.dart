import 'package:vector_math/vector_math.dart';

class Pose {
  late Vector3 translation;
  late Vector4 rotation;

  Pose.fromMap(Map<dynamic, dynamic> map) {
    translation = Vector3.array(map["translation"]);
    rotation = Vector4.array(map["rotation"]);
  }
}
