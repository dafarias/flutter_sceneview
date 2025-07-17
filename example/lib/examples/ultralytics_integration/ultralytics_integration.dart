import 'package:flutter/material.dart';
import 'package:flutter_sceneview/flutter_sceneview.dart';
import 'package:flutter_sceneview_example/examples/ultralytics_integration/ball_detection.dart';
import 'package:flutter_sceneview_example/examples/ultralytics_integration/detection_result.dart';
import 'package:flutter_sceneview_example/examples/ultralytics_integration/detection_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vector_math/vector_math.dart' hide Colors;

class UltralyticsIntegration extends StatefulWidget {
  const UltralyticsIntegration({super.key});

  @override
  State<UltralyticsIntegration> createState() => _UltralyticsIntegrationState();
}

class _UltralyticsIntegrationState extends State<UltralyticsIntegration> {
  DetectionService? _detectionService;

  final _flutterSceneviewPlugin = FlutterSceneview();
  late final ARSceneController _arSceneController;

  List<BallDetection> detectedBalls = [];

  @override
  void initState() {
    _detectionService = DetectionService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Example w/ ultralytics_yolo')),
        body: Center(
          child: SceneView(
            onViewCreated: (controller) => _arSceneController = controller,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: onCapturePressed,
          child: Icon(Icons.camera_alt),
        ),
      ),
    );
  }

  void onCapturePressed() async {
    // Clean up the scene if there's anything from a previous detection
    await _arSceneController.removeAllNodes();

    try {
      // TODO: add this when snapshot is available
      // var imageBytes = await _arSceneController.createBytesSnapshot();

      final tempDir = await getTemporaryDirectory();
      final filePath = "${tempDir.path}/ar_snapshot.png";

      var detectionResult = await _detectionService!.analyseImage(filePath);
      detectedBalls = await _handleDetections(detectionResult);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<List<BallDetection>> _handleDetections(
    DetectionResult detectionResult,
  ) async {
    try {
      if (detectionResult.hole == null) {
        return [];
      }

      final detectedHolePosition = detectionResult.hole?.boundingBox?.center;
      final holeWorldPositions = await _arSceneController.hitTest(
        x: detectedHolePosition!.dx,
        y: detectedHolePosition.dy,
      );

      if (holeWorldPositions.isEmpty) {
        throw Exception('No hole found');
      }

      final holePosition = holeWorldPositions.first.pose.translation;

      await _placeArFlag(detectedHolePosition);
      await _placeArRings(holePosition);

      return await _placeArBalls(holePosition, detectionResult.balls);
    } catch (_) {
      return [];
    }
  }

  Future<void> _placeArFlag(Offset holePosition) async {
    try {
      await _arSceneController.addNode(
        x: holePosition.dx,
        y: holePosition.dy,
        fileName: 'golf_flag.glb',
      );
    }
    catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _placeArRings(Vector3 holePosition) async {
    try {
      await _placeRing(worldPosition: holePosition, radius: 1);
      await _placeRing(worldPosition: holePosition, radius: 2);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _placeRing({
    required Vector3 worldPosition,
    required double radius,
  }) {
    // TODO: implement
    throw UnimplementedError();
  }

  Future<List<BallDetection>> _placeArBalls(
    Vector3 holePosition,
    List<BallDetection> balls,
  ) async {
    double arObjectScale = 0.01;

    for (BallDetection ball in balls) {
      final ballPosition = ball.boundingBox?.center;

      final worldPositions = await _arSceneController.hitTest(
        x: ballPosition!.dx,
        y: ballPosition.dy,
      );

      if (worldPositions.isEmpty) {
        continue;
      }

      final ballWorldPosition = worldPositions.first.pose.translation;
      double distance = _calculateDistanceBetweenPoints(
        holePosition,
        ballWorldPosition,
      );

      ball.distanceToHole = distance;
    }

    return balls;
  }

  double _calculateDistanceBetweenPoints(Vector3 a, Vector3 b) {
    return a.distanceTo(b);
  }
}
