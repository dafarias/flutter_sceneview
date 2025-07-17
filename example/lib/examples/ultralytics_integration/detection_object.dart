import 'package:flutter/material.dart';

class DetectedObject {
  DetectedObject({
    this.confidence = 0,
    this.boundingBox,
    this.label = '',
    this.index = -1,
  });

  double confidence;
  Rect? boundingBox;
  String label;
  double index;
}


class DetectionBox {
  final double x;
  final double xImg;

  final double y;
  final double yImg;

  final List<double> bbox;

  final double height;
  final double width;
  final double heightImg;
  final double widthImg;

  final String cls;
  final double index;
  final double confidence;

  DetectionBox(
      this.x,
      this.xImg,
      this.y,
      this.yImg,
      this.bbox,
      this.height,
      this.width,
      this.heightImg,
      this.widthImg,
      this.cls,
      this.index,
      this.confidence);

  factory DetectionBox.fromJson(Map<String, dynamic> json) {
    return DetectionBox(
      (json['x'] as num).toDouble(),
      (json['xImg'] as num).toDouble(),
      (json['y'] as num).toDouble(),
      (json['yImg'] as num).toDouble(),
      (json['bbox'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      (json['height'] as num).toDouble(),
      (json['width'] as num).toDouble(),
      (json['heightImg'] as num).toDouble(),
      (json['widthImg'] as num).toDouble(),
      json['cls'] as String,
      (json['index'] as num).toDouble(),
      (json['confidence'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'x': x,
      'xImg': xImg,
      'y': y,
      'yImg': yImg,
      'bbox': bbox,
      'height': height,
      'width': width,
      'heightImg': heightImg,
      'widthImg': widthImg,
      'cls': cls,
      'index': index,
      'confidence': confidence,
    };
  }
}
