import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_sceneview/flutter_sceneview.dart';
import 'package:vector_math/vector_math.dart' hide Sphere;

void main() {
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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

    return Scaffold(
      appBar: AppBar(title: const Text('Plugin example app')),
      body: Center(
        child: SceneView(
          onViewCreated: (controller) => _controller = controller,
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // goToScene();
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

            ElevatedButton(onPressed: _handleHitTest, child: Text('Hit test')),
          ],
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

    final torus = Torus(
      node,
      material: material,
      majorRadius: 1,
      minorRadius: 0.05,
    );

    // The font family ha to be inside the flutter assets folder,
    // and the fontFamily has to be the location of the font + the font family name
    // Example: 'assets/fonts/BitcountPropSin_VariableFont.ttf'
    final textNode = await _flutterSceneviewPlugin.addTextNode(
      "Custom font text node",
      x: 400,
      y: 500,
      size: 2,
    );

    if (textNode != null) {
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
    final results = await _flutterSceneviewPlugin.performHitTest(250, 600);

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

  void goToScene() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Scene()),
    );
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
