import 'package:flutter/material.dart';
import 'package:flutter_sceneview_example/utils/app_router.dart';

void main() {
  runApp(const FlutterSceneviewExampleApp());
}

class FlutterSceneviewExampleApp extends StatelessWidget {
  const FlutterSceneviewExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Sceneview Example App',
      debugShowCheckedModeBanner: false,
      onGenerateRoute: AppRouter.build,
      initialRoute: '/',
    );
  }
}

