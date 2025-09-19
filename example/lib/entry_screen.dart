import 'package:flutter/material.dart';
import 'package:flutter_sceneview_example/utils/routes.dart';

class EntryScreen extends StatelessWidget {
  const EntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final routes = Routes.all.where((r) => r.path != '/');

    return Scaffold(
      appBar: AppBar(title: const Text("Flutter Sceneview Example App")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: routes.map((r) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: OutlinedButton(
                onPressed: () => Navigator.pushNamed(context, r.path),
                child: Text("Go to ${r.name}"),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
