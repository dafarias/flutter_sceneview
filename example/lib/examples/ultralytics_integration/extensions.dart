import 'package:collection/collection.dart';
import 'package:flutter_sceneview_example/examples/ultralytics_integration/detection_object.dart';
import 'package:flutter_sceneview_example/examples/ultralytics_integration/detection_result.dart';
import 'package:flutter_sceneview_example/examples/ultralytics_integration/ball_detection.dart';
import 'package:flutter_sceneview_example/examples/ultralytics_integration/ultralytics_detection.dart';

extension DetectedObjectExtensions on Map<String, dynamic>? {
  DetectionResult toDetectionResult({
    double minBallConfidence = 0.3,
    double minHoleConfidence = 0.3,
  }) {
    const ballDetectionIndex = 0;
    const holeDetectionIndex = 1;

    final detections = this?['detections'] as List<Map<String, dynamic>>?;

    if (detections != null) {
      final mappedDetections = detections.map(
        (e) => UltralyticsDetection.fromJson(e),
      );

      final detectedHole = mappedDetections.findMaxDetection(
        index: holeDetectionIndex,
        minConfidence: minHoleConfidence,
      );

      final hole = detectedHole != null
          ? DetectedObject(
              confidence: detectedHole.confidence,
              boundingBox: detectedHole.boundingBox,
              label: detectedHole.className,
            )
          : null;

      final ballDetections = mappedDetections
          .findAllDetections(
            index: ballDetectionIndex,
            minConfidence: minBallConfidence,
          )
          .map(
            (e) => BallDetection(
              confidence: e.confidence,
              boundingBox: e.boundingBox,
              distanceToHole: 0,
            ),
          )
          .toList(growable: false);

      return DetectionResult(hole: hole, balls: ballDetections);
    }

    return DetectionResult.empty();
  }
}

extension UltralyticsDetectionExtesnions on Iterable<UltralyticsDetection> {
  UltralyticsDetection? findMaxDetection({
    required int index,
    required double minConfidence,
  }) {
    return findAllDetections(
      index: index,
      minConfidence: minConfidence,
    ).sorted((a, b) => b.confidence.compareTo(a.confidence)).firstOrNull;
  }

  Iterable<UltralyticsDetection> findAllDetections({
    required int index,
    required double minConfidence,
  }) {
    return where((x) => x.classIndex == index && x.confidence >= minConfidence);
  }
}
