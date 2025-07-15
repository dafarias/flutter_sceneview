import 'pose.dart';

class HitTestResult {
  late double distance;

  late String nodeName;

  late Pose pose;

  HitTestResult.fromMap(Map<dynamic, dynamic> map) {
    distance = map['distance'];
    pose = Pose.fromMap(map['pose']);
  }
}
