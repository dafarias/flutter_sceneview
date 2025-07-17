import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter_sceneview_example/examples/ultralytics_integration/detection_object.dart';
import 'package:flutter_sceneview_example/examples/ultralytics_integration/detection_result.dart';
import 'package:flutter_sceneview_example/examples/ultralytics_integration/ball_detection.dart';

extension DetectedObjectExtensions on Map<String, dynamic>? {
  DetectionResult toDetectionResult(
      {double minBallConfidence = 0.5, double minHoleConfidence = 0.3}) {
    final empty = DetectionResult(hole: null, balls: []);
    try {
      const ballDetectionIndex = 0;
      const holeDetectionIndex = 1;

      final detections = this?['boxes'] as List<Map<String, dynamic>>?;

      if (detections != null) {
        final detectedHole = detections
            .map((e) => DetectionBox.fromJson(e))
            .where((x) =>
        x.index == holeDetectionIndex &&
            x.confidence >= minHoleConfidence)
            .sorted((a, b) => b.confidence.compareTo(a.confidence))
            .firstOrNull;

        // The current API returns the bounding box as a List of values. To know
        // what those values stand for, we just need to look at the returned fields
        // with an 'Img' name on it.
        // To build  a bounding box we could use the raw values, and we need to follow
        // the order using the Rect.LTWH constructor: example
        // boundingBox: Rect.fromLTWH(e.xImg, e.yImg, e.widthImg, e.heightImg),
        final ballDetections = detections
            .map((e) => DetectionBox.fromJson(e))
            .where((x) =>
        x.index == ballDetectionIndex &&
            x.confidence >= minBallConfidence)
            .map(
              (e) => BallDetection(
            confidence: e.confidence,
            boundingBox:
            Rect.fromLTWH(e.bbox[0], e.bbox[1], e.bbox[2], e.bbox[3]),
            index: e.index,
            label: e.cls,
            distanceToHole: 0,
          ),
        )
            .toList(growable: false);

        final hole = detectedHole != null
            ? DetectedObject(
            confidence: detectedHole.confidence,
            boundingBox: Rect.fromLTWH(
                detectedHole.bbox[0],
                detectedHole.bbox[1],
                detectedHole.bbox[2],
                detectedHole.bbox[3]),
            label: detectedHole.cls,
            index: detectedHole.index)
            : null;

        return DetectionResult(hole: hole, balls: ballDetections);
      }
      return empty;
    } catch (e) {
      debugPrint(e.toString());
      return empty;
    }
  }
}