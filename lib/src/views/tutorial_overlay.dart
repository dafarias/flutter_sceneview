import 'package:flutter/material.dart';

class TutorialOverlay extends StatefulWidget {
  const TutorialOverlay({super.key});

  @override
  State<StatefulWidget> createState() {
    return _TutorialOverlayState();
  }
}

// const SceneView({super.key, this.onViewCreated});

// final Function(ARSceneController)? onViewCreated;

// @override
// State<SceneView> createState() => _SceneViewState();

class _TutorialOverlayState extends State<TutorialOverlay> {
  bool _showTutorialOverlay = true;

  @override
  void initState() {
    _showTutorialOverlay = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _showTutorialOverlay
        ? Container(
            color: Colors.black.withValues(alpha: 0.5),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Replace with Lottie/Rive animation
                  Icon(Icons.pan_tool, color: Colors.white, size: 64),
                  const SizedBox(height: 20),
                  const Text(
                    "Move your phone to start tracking",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
          )
        : _EmptyOverlay();
  }
}

class _EmptyOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox.shrink();
  }
}


// controller.methodChannel.setMethodCallHandler((call) async {
//   if (call.method == "trackingStateChanged") {
//     final isTracking = call.arguments as bool;
//     controller.onTrackingStateChanged?.call(isTracking);
//   }
// });