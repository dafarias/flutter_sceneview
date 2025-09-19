import 'package:flutter/material.dart';
import 'package:flutter_sceneview_example/entry_screen.dart';
import 'package:flutter_sceneview_example/examples/playground.dart';
import 'package:flutter_sceneview_example/examples/ultralytics_integration/ultralytics_integration.dart';

class AppRoute {
  final String path;
  final String name;
  final WidgetBuilder builder;

  const AppRoute({
    required this.path,
    required this.name,
    required this.builder,
  });
}

class Routes {
  static final all = <AppRoute>[
    AppRoute(
      path: '/',
      name: 'Flutter Sceneview Example App',
      builder: (context) => const EntryScreen(),
    ),
    AppRoute(
      path: '/playground',
      name: 'Playground',
      builder: (context) => const PlaygroundScreen(),
    ),
    AppRoute(
      path: '/ultralytics-integration',
      name: 'Example w/ Ultralytics',
      builder: (context) => const UltralyticsIntegrationScreen(),
    ),
  ];
}