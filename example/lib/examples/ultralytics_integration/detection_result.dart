import 'package:flutter_sceneview_example/examples/ultralytics_integration/ball_detection.dart';
import 'package:flutter_sceneview_example/examples/ultralytics_integration/detection_object.dart';

class DetectionResult {
  DetectionResult({required this.hole, required this.balls});

  final List<BallDetection> balls;
  final DetectedObject? hole;
}