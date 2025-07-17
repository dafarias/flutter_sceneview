import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter_sceneview_example/examples/ultralytics_integration/detection_result.dart';
import 'package:flutter_sceneview_example/examples/ultralytics_integration/extensions.dart';
import 'package:gal/gal.dart';
import 'package:image/image.dart' as img;
import 'package:ultralytics_yolo/yolo.dart';
import 'package:ultralytics_yolo/yolo_view.dart';

class DetectionService {
  static final String _modelName = 'best_float32.tflite';

  late final YOLOViewController controller;
  late final YOLO _yolo;

  YOLO get instance => _yolo;

  DetectionService() {
    controller = YOLOViewController();
    _init();
  }

  void _init() async {
    try {
      final bool exists;
      final yolo = YOLO(
        modelPath: _modelName,
        task: YOLOTask.detect,
      );

      final modelInfo = await YOLO.checkModelExists(_modelName);
      exists = modelInfo['exists'];
      if (io.Platform.isIOS) {
        try {
          if (exists) {
            debugPrint(
                'iOS: Using local .mlpackage path: $_modelName. Model was found, but the current'
                    'YOLO implementation has issues sending back the right value');
          } else {
            debugPrint(
              'iOS: Failed to find .mlpackage or .mlmodel, using default asset path.',
            );
          }
        } catch (e) {
          debugPrint('Error during .mlpackage read iOS: $e');
        }
      }

      bool hasLoaded = await yolo.loadModel();
      // Current workaround to keep the flow going. If the model
      // fails to load on iOS it will throw an exception, so
      // if it gets untill here its safe to assume that it was loaded
      // without any issues because the model exists
      if (hasLoaded) {
        _yolo = yolo;
      } else if (!hasLoaded && exists && io.Platform.isIOS) {
        _yolo = yolo;
      } else {
        debugPrint('Failed to load model');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<DetectionResult> analyseImage(String imagePath) async {
    try {
      final file = io.File(imagePath);
      final fileBytes = await file.readAsBytes();
      final detectedObjects = await _yolo.predict(fileBytes);
      var detectionResult = detectedObjects.toDetectionResult();
      return detectionResult;
    } catch (e) {
      debugPrint(e.toString());
      return DetectionResult(
        hole: null,
        balls: [],
      );
    }
  }

  // TODO: remove if not needed
  // Future<String> _copyAsset(String assetPath) async {
  //   final path = '${(await getApplicationSupportDirectory()).path}/$assetPath';
  //   await io.Directory(dirname(path)).create(recursive: true);
  //   final file = io.File(path);
  //   if (!await file.exists()) {
  //     final byteData = await rootBundle.load(assetPath);
  //     await file.writeAsBytes(byteData.buffer
  //         .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
  //   }
  //   return file.path;
  // }

  // NOTE: used only for testing purposes to see detection results on image.
  // Enable it on the analyseImage method.
  Future<void> saveDetectionToGallery(
      String imagePath, DetectionResult detections) async {
    final image = await img.decodePngFile(imagePath);

    if (detections.hole != null) {
      final holeBoundingBox = detections.hole!.boundingBox!;
      img.drawRect(
        image!,
        x1: holeBoundingBox.left.toInt(),
        y1: holeBoundingBox.top.toInt(),
        x2: holeBoundingBox.right.toInt(),
        y2: holeBoundingBox.bottom.toInt(),
        color: img.ColorRgb8(0, 0, 255),
        thickness: 5,
      );
    }

    for (var ball in detections.balls) {
      final ballBoundingBox = ball.boundingBox!;
      img.drawRect(
        image!,
        x1: ballBoundingBox.left.toInt(),
        y1: ballBoundingBox.top.toInt(),
        x2: ballBoundingBox.right.toInt(),
        y2: ballBoundingBox.bottom.toInt(),
        color: img.ColorRgb8(255, 0, 0),
        thickness: 3,
      );
    }

    final finalImage = img.encodePng(image!);
    final dt = DateTime.now();
    await Gal.putImageBytes(finalImage,
        name: 'detection_${dt.hour}_${dt.minute}_${dt.second}');
  }
}
