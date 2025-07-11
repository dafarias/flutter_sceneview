import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_sceneview/flutter_sceneview.dart';
import 'package:vector_math/vector_math.dart';

void main() {
  runApp(const MyApp());
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
            // placeNode();
            placeShapeNode();
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
            ],
          ),
        ),
      ),
    );
  }

  void placeNode() async {
    final node = await _flutterSceneviewPlugin.addNode(
      x: 0,
      y: 0,
      fileName: 'golf_flag.glb',
    );

    //Todo: Fix node placement and removal logic
    if (node != null && node.isNotEmpty) {
       placedNodes.add(node);
    }
  }

  void placeShapeNode() async {
    final node = Node(position: Vector3(0, -1, 0), rotation: Vector3(0, 0, 0));
    final material = ArCoreMaterial(color: Color.fromARGB(255, 255, 255, 255));
    final sphere = ArCoreSphere(node, material: material, radius: 0.05);
    final sphereNode = await _flutterSceneviewPlugin.addShapeNode(sphere);

    if(sphereNode != null) {
      placedNodes.add(node);
    }
  }

  void removeById({required String nodeId}) {
    _controller.removeNode(nodeId: nodeId);
  }

  void onRemoveAll() {
    _controller.removeAllNodes();
  }
}
