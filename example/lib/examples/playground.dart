import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sceneview/flutter_sceneview.dart';
import 'package:vector_math/vector_math_64.dart' hide Sphere, Colors;

class PlaygroundScreen extends StatefulWidget {
  const PlaygroundScreen({super.key});

  @override
  State<PlaygroundScreen> createState() => _PlaygroundScreenState();
}

class _PlaygroundScreenState extends State<PlaygroundScreen> {
  String _platformVersion = 'Unknown';
  final _flutterSceneviewPlugin = FlutterSceneView();

  late final SceneViewController _controller;

  final List<SceneNode> placedNodes = [];

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await _flutterSceneviewPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Running on: $_platformVersion\n');
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Plugin example app')),
        body: Center(
          child: SceneView(
            onViewCreated: (controller) => _controller = controller,
            overlayBehavior: OverlayBehavior.showAlwaysOnTrackingChanged,
          ),
        ),
        bottomSheet: Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final maxWidth = constraints.maxWidth;

              const spacing = 12.0;
              final buttonWidth = (maxWidth - (spacing * 2)) / 3;

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: [
                  SizedBox(
                    width: buttonWidth,
                    child: ElevatedButton(
                      onPressed: () {
                        removeById(
                          nodeId: placedNodes.firstOrNull?.parentId ?? "",
                        );
                      },
                      child: const Text('Remove by id'),
                    ),
                  ),
                  SizedBox(
                    width: buttonWidth,
                    child: ElevatedButton(
                      onPressed: onRemoveAll,
                      child: const Text('Remove all'),
                    ),
                  ),
                  SizedBox(
                    width: buttonWidth,
                    child: ElevatedButton(
                      onPressed: getAllNodes,
                      child: const Text('Get all'),
                    ),
                  ),
                  SizedBox(
                    width: buttonWidth,
                    child: ElevatedButton(
                      onPressed: () {
                        placeNode(toRoot: true);
                      },
                      child: const Text('Hit test'),
                    ),
                  ),
                  SizedBox(
                    width: buttonWidth,
                    child: ElevatedButton(
                      onPressed: createAnchor,
                      child: const Icon(Icons.flag),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void placeNode({
    bool toRoot = false,
    bool asChild = false,
    bool asChildren = false,
  }) async {
    final value = MediaQuery.of(context).size;
    final results = await hitTest(
      x: value.width / 2,
      y: value.height / 2,
      normalize: true,
    );

    if (results.isNotEmpty) {
      if (toRoot) addNode(pose: results.first.pose);
      if (asChild) addChild(pose: results.first.pose);
      if (asChildren) addChildren(pose: results.first.pose);
    }
  }

  void addNode({required Pose pose}) async {
    final node = await _controller.node.addNode(
      node: SceneNode(
        position: pose.position,
        rotation: pose.rotation,
        config: NodeConfig.shape(
          shape: BaseShape.sphere(radius: 0.1),
          material: BaseMaterial(color: Colors.lightBlueAccent, metallic: 0.7),
        ),
      ),
    );
    if (node != null) {
      placedNodes.add(node);
    }

    debugPrint(node.toString());
  }

  void placeShapeNode(Vector3 position, Vector3 rotation) async {
    final node = SceneNode(
      position: position,
      rotation: rotation,
      config: NodeConfig.shape(
        material: BaseMaterial(color: Color.fromARGB(255, 255, 255, 255)),
        shape: BaseShape.sphere(radius: 0.05),
      ),
    );

    final _ = BaseShape.torus(majorRadius: 2, minorRadius: 0.05);
    final sphereNode = await _controller.node.addNode(node: node);

    if (sphereNode != null) {
      placedNodes.add(sphereNode);
    }
  }

  void removeById({required String nodeId}) {
    _controller.node.removeNode(nodeId: nodeId);
  }

  void onRemoveAll() async {
    _controller.node.removeAllNodes();
  }

  void getAllNodes() async {
    final nodes = await _controller.node.getAllNodes();
    debugPrint('Nodes on scene [${nodes.length}]:');

    for (final node in nodes) {
      debugPrint(
        '${node.nodeId}: ${node.position} | ${node.rotation} | ${node.scale}',
      );
    }
  }

  Future<List<HitTestResult>> hitTest({
    double? x,
    double? y,
    bool normalize = true,
  }) async {
    final results = await _controller.node.hitTest(
      x: x ?? 200,
      y: y ?? 600,
      normalize: normalize,
    );

    if (results.isEmpty) {
      debugPrint('[Flutter] No hit test results');
      return [];
    }

    return results;
  }

  void createAnchor() async {
    final result = await _controller.node.createAnchorNode(
      x: 300,
      y: 400,
      node: SceneNode(
        parentId: "anchor",
        nodeId: "child/flag",
        position: Vector3.all(0),
        config: NodeConfig.model(fileName: 'models/golf_flag.glb'),
      ),
      normalize: true,
    );

    if (result != null && result.isPlaced) {
      placedNodes.add(result);
    }
  }

  void detachAnchor({required String anchorId}) {
    _controller.node.detachAnchor(anchorId: anchorId);
  }

  void addChild({required Pose pose}) async {
    final child = await _controller.node.addChildNode(
      parentId: placedNodes.first.parentId ?? "",
      child: SceneNode(
        position: pose.position,
        rotation: pose.rotation,
        config: NodeConfig.shape(
          shape: BaseShape.sphere(radius: 0.1),
          material: BaseMaterial(color: Colors.purpleAccent, metallic: 0.7),
        ),
      ),
    );

    debugPrint(child.toString());
  }

  void addChildren({required Pose pose}) async {
    final children = await _controller.node.addChildNodes(
      parentId: placedNodes.first.parentId ?? "",
      children: [
        SceneNode(
          position: pose.position,
          rotation: pose.rotation,
          config: NodeConfig.shape(
            shape: BaseShape.sphere(radius: 0.1),
            material: BaseMaterial(color: Colors.purpleAccent, metallic: 0.7),
          ),
        ),

        SceneNode(
          position: pose.position.clone()..add((Vector3(0.2, 1, -0.35))),
          rotation: pose.rotation,
          config: NodeConfig.shape(
            shape: BaseShape.torus(majorRadius: 0.5, minorRadius: 0.05),
            material: BaseMaterial(
              color: Colors.deepOrangeAccent,
              metallic: 0.7,
            ),
          ),
        ),
      ],
    );

    debugPrint(children.toString());
  }

  void goToScene() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Scene()),
    );
  }

  void checkEvents() {
    _controller.session.trackingEvents.listen((event) {
      debugPrint(event.toString());
    });
  }
}

/// In case we need to test the life cycle events we can just create
/// a scene widget on a new page and then detect the changes based on the
/// behavior of the navigation
class Scene extends StatelessWidget {
  const Scene({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scene view screen')),
      body: SceneView(),
    );
  }
}
