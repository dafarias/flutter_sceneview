import 'package:flutter_sceneview_example/examples/ultralytics_integration/detection_object.dart';

class BallDetection extends DetectedObject {
  BallDetection(
      {super.confidence,
        super.boundingBox,
        super.label = '',
        super.index = -1,
        this.distanceToHole = -1});
  double distanceToHole;
}

// Contains 'boxes' with class, confidence, and bounding box coordinates.
