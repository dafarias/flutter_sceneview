import 'arcore_pose.dart';

class ArCoreHitTestResult {
  late double distance;

  late String nodeName;

  late ArCorePose pose;

  ArCoreHitTestResult.fromMap(Map<dynamic, dynamic> map) {
    distance = map['distance'];
    pose = ArCorePose.fromMap(map['pose']);
  }
}
