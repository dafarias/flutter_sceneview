import 'package:flutter/material.dart';
import 'package:flutter_sceneview_example/utils/routes.dart';

class AppRouter {
  static Route<dynamic> build(RouteSettings settings) {
    final route = Routes.all.firstWhere(
      (r) => r.path == settings.name,
      orElse: () => AppRoute(
        path: '/404',
        name: 'Not Found',
        builder: (context) => Scaffold(
          body: Center(child: Text('No route defined for ${settings.name}')),
        ),
      ),
    );

    return MaterialPageRoute(builder: route.builder, settings: settings);
  }
}
