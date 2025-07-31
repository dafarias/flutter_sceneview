import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sceneview/flutter_sceneview.dart';
import 'package:vector_math/vector_math.dart' hide Sphere;

class Playground extends StatefulWidget {
  const Playground({super.key});

  @override
  State<Playground> createState() => _PlaygroundState();
}

class _PlaygroundState extends State<Playground> {
  String _platformVersion = 'Unknown';
  final _flutterSceneviewPlugin = FlutterSceneview();

  late final ARSceneController _controller;

  final List<Node> placedNodes = [];

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
                  removeById(nodeId: placedNodes.firstOrNull?.nodeId ?? "");
                },
                child: Text('Remove by id'),
              ),

              SizedBox(width: 20),

              ElevatedButton(onPressed: onRemoveAll, child: Text('Remove all')),
              SizedBox(width: 20),

              ElevatedButton(
                onPressed: _handleHitTest,
                child: Text('Hit test'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void placeNode() async {
    final node = await _flutterSceneviewPlugin.addNode(
      x: 550,
      y: 550,
      fileName: 'golf_flag.glb',
    );

    //Todo: Fix node placement and removal logic
    if (node != null && node.isNotEmpty) {
      placedNodes.add(node);
    }
  }

  void placeShapeNode(Vector3 position, Vector3 rotation) async {
    final node = Node(position: position, rotation: rotation);
    final material = BaseMaterial(color: Color.fromARGB(255, 255, 255, 255));
    final sphere = Sphere(node, material: material, radius: 0.05);
    final sphereNode = await _flutterSceneviewPlugin.addShapeNode(sphere);

    if (sphereNode != null) {
      placedNodes.add(node);
    }
  }

  void removeById({required String nodeId}) {
    _controller.removeNode(nodeId: nodeId);
  }

  void onRemoveAll() {
    _controller.removeAllNodes();
  }

  void _handleHitTest() async {
    final results = await _flutterSceneviewPlugin.performHitTest(500, 500);

    if (results.isEmpty) {
      print('[Flutter] No hit test results');
      return;
    }

    final hitTestResult = results.first.pose;
    placeShapeNode(
      hitTestResult.translation,
      Vector3(
        hitTestResult.rotation.x,
        hitTestResult.rotation.y,
        hitTestResult.rotation.z,
      ),
    );
  }
}