import 'package:flutter/material.dart';
import 'package:flutter_sceneview/flutter_sceneview.dart';
import 'package:flutter_sceneview_example/examples/ultralytics_integration/ball_detection.dart';
import 'package:flutter_sceneview_example/examples/ultralytics_integration/detection_result.dart';
import 'package:flutter_sceneview_example/examples/ultralytics_integration/detection_service.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors, Sphere;

class UltralyticsIntegrationScreen extends StatefulWidget {
  const UltralyticsIntegrationScreen({super.key});

  @override
  State<UltralyticsIntegrationScreen> createState() => _UltralyticsIntegrationScreenState();
}

class _UltralyticsIntegrationScreenState extends State<UltralyticsIntegrationScreen> {
  DetectionService? _detectionService;

  // ignore: unused_field
  final _flutterSceneviewPlugin = FlutterSceneView();
  late final SceneViewController _sceneViewController;

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
            onViewCreated: (controller) => _sceneViewController = controller,
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
    await _sceneViewController.node.removeAllNodes();

    try {
      var imageBytes = await _sceneViewController.scene.sceneSnapshot();
      var detectionResult = await _detectionService!.analyseImage(imageBytes);
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
      final holeWorldPositions = await _sceneViewController.node.hitTest(
        x: detectedHolePosition!.dx,
        y: detectedHolePosition.dy,
      );

      if (holeWorldPositions.isEmpty) {
        throw Exception('No hole found');
      }

      final holePosition = holeWorldPositions.first.pose.position;

      await _placeArFlag(detectedHolePosition);
      await _placeArRings(holePosition);

      return await _placeArBalls(holePosition, detectionResult.balls);
    } catch (_) {
      return [];
    }
  }

  Future<void> _placeArFlag(Offset holePosition) async {
    try {
      await _sceneViewController.node.createAnchorNode(
        x: holePosition.dx,
        y: holePosition.dy,
        node: SceneNode(
          position: Vector3.all(0),
          type: NodeType.model,
          config: NodeConfig.model(fileName: 'golf_flag.glb'),
        ),
      );
    } catch (e) {
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
  }) async {
    final ring = SceneNode(
      position: worldPosition,
      type: NodeType.shape,
      config: NodeConfig.shape(
        material: BaseMaterial(color: Color.fromARGB(255, 255, 255, 255)),
        shape: BaseShape.torus(majorRadius: radius, minorRadius: 0.05),
      ),
    );

    _sceneViewController.node.addNode(node: ring);
  }

  Future<List<BallDetection>> _placeArBalls(
    Vector3 holePosition,
    List<BallDetection> balls,
  ) async {
    for (BallDetection ball in balls) {
      final ballPosition = ball.boundingBox?.center;

      final worldPositions = await _sceneViewController.node.hitTest(
        x: ballPosition!.dx,
        y: ballPosition.dy,
      );

      if (worldPositions.isEmpty) {
        continue;
      }

      final ballWorldPosition = worldPositions.first.pose.position;
      final ballRot = worldPositions.first.pose.rotation;
      final ballWorldRotation = ballRot;

      final shpere = SceneNode(
        position: ballWorldPosition,
        rotation: ballWorldRotation,
        type: NodeType.shape,
        config: NodeConfig.shape(
          material: BaseMaterial(color: Color.fromARGB(0, 0, 0, 0)),
          shape: BaseShape.sphere(radius: 0.025),
        ),
      );

      await _sceneViewController.node.addNode(node: shpere);

      double distance = _calculateDistanceBetweenPoints(
        holePosition,
        ballWorldPosition,
      );

      final text = SceneNode(
        position: ballWorldPosition..add(Vector3(0, 0.5, 0)),
        type: NodeType.shape,
        config: NodeConfig.text(
          text: '${distance.toStringAsFixed(2)}m',
          size: 0.5,
        ),
      );

      await _sceneViewController.node.addNode(node: text);

      ball.distanceToHole = distance;
    }

    return balls;
  }

  double _calculateDistanceBetweenPoints(Vector3 a, Vector3 b) {
    return a.distanceTo(b);
  }
}
