import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_sceneview/flutter_sceneview.dart';

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

    if (node != null && node.isNotEmpty) {
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
