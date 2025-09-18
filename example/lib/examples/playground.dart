import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sceneview/flutter_sceneview.dart';
import 'package:vector_math/vector_math_64.dart' hide Sphere, Colors;

class Playground extends StatefulWidget {
  const Playground({super.key});

  @override
  State<Playground> createState() => _PlaygroundState();
}

class _PlaygroundState extends State<Playground> {
  String _platformVersion = 'Unknown';
  final _flutterSceneviewPlugin = FlutterSceneView();

  late final SceneViewController _controller;

  final List<Node> placedNodes = [];
  final List<SceneNode> nodes = [];

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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            placeNode();
          },
          child: Icon(Icons.place),
        ),

        bottomSheet: SizedBox(
          height: 60,
          child: Row(
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  final id = nodes.first.parentId;
                  removeById(nodeId: id ?? "");
                  // detachAnchor(anchorId: id ?? "");
                },
                child: Text('Remove by id'),
              ),

              SizedBox(width: 20),

              ElevatedButton(onPressed: onRemoveAll, child: Text('Remove all')),
              SizedBox(width: 20),

              ElevatedButton(
                onPressed: () {
                  createAnchor();
                },
                child: Text('Hit test'),
              ),
            ],
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
    final results = await hitTest();

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
        type: NodeType.shape,
        config: NodeConfig.shape(
          shape: BaseShape.sphere(radius: 0.1),
          material: BaseMaterial(color: Colors.lightBlueAccent, metallic: 0.7),
        ),
      ),
    );

    print(node);
  }

  void placeShapeNode(Vector3 position, Vector3 rotation) async {
    final node = Node(position: position, rotation: rotation);
    final material = BaseMaterial(color: Color.fromARGB(255, 255, 255, 255));

    // The shape should not depend on the node to be created
    final sphere = BaseShape.sphere(radius: 0.05);
    final torus = BaseShape.torus(majorRadius: 2, minorRadius: 0.05);
    final sphereNode = await _flutterSceneviewPlugin.addShapeNode(sphere);

    if (sphereNode != null) {
      placedNodes.add(node);
    }
  }

  void removeById({required String nodeId}) {
    _controller.node.removeNode(nodeId: nodeId);
  }

  void onRemoveAll() async {
    // final snap = await _controller.scene.sceneSnapshot();
    // print(snap);
    _controller.node.removeAllNodes();
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
    //Node can be created on the call and received if creeation was successful
    final result = await _controller.node.createAnchorNode(
      x: 300,
      y: 400,
      node: SceneNode(
        parentId: "anchor",
        nodeId: "child/flag",
        position: Vector3.all(0),

        type: NodeType.model,
        config: NodeConfig.model(fileName: 'models/golf_flag.glb'),
      ),
      normalize: true,
    );

    if (result != null && result.isPlaced) {
      nodes.add(result);
    }
  }

  void detachAnchor({required String anchorId}) {
    _controller.node.detachAnchor(anchorId: anchorId);
  }

  void addChild({required Pose pose}) async {
    final child = await _controller.node.addChildNode(
      parentId: nodes.first.parentId ?? "",
      child: SceneNode(
        position: pose.position,
        rotation: pose.rotation,
        type: NodeType.shape,
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
      parentId: nodes.first.parentId ?? "",
      children: [
        SceneNode(
          position: pose.position,
          rotation: pose.rotation,
          type: NodeType.shape,
          config: NodeConfig.shape(
            shape: BaseShape.sphere(radius: 0.1),
            material: BaseMaterial(color: Colors.purpleAccent, metallic: 0.7),
          ),
        ),

        SceneNode(
          position: pose.position.clone()..add((Vector3(0.2, 1, -0.35))),
          rotation: pose.rotation,
          type: NodeType.shape,
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
