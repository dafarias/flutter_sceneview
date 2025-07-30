import 'dart:ui';

class UltralyticsDetection {
  final int classIndex;
  final String className;
  final double confidence;

  // TODO: make new classes for boundingBox & normalizedBox
  final Rect boundingBox;

  // final Map<String, double> normalizedBox;

  UltralyticsDetection({
    required this.classIndex,
    required this.className,
    required this.confidence,
    required this.boundingBox,
  });

  factory UltralyticsDetection.fromJson(Map<String, dynamic> json) {
    return UltralyticsDetection(
      classIndex: (json['classIndex'] as num).toInt(),
      className: (json['className'] as String),
      confidence: (json['confidence'] as num).toDouble(),
      boundingBox: Rect.fromLTRB(
        (json['boundingBox']['left'] as num).toDouble(),
        (json['boundingBox']['top'] as num).toDouble(),
        (json['boundingBox']['right'] as num).toDouble(),
        (json['boundingBox']['bottom'] as num).toDouble(),
      ),
    );
  }
}
