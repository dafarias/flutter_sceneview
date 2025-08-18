import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_sceneview/flutter_sceneview.dart';

class SceneView extends StatefulWidget {
  const SceneView({super.key, this.onViewCreated, this.sessionController});

  final Function(ARSceneController)? onViewCreated;
  final Function(ARSessionController)? sessionController;

  @override
  State<SceneView> createState() => _SceneViewState();
}

class _SceneViewState extends State<SceneView> {
  final Completer<ARSceneController> _controller =
      Completer<ARSceneController>();

  final Completer<ARSessionController> _sessionController =
      Completer<ARSessionController>();

  final GlobalKey _arViewKey = GlobalKey();

  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkViewRegistration() async {
    final isReady = await FlutterSceneview().hasRegisteredView() ?? false;
    if (isReady) {}
    debugPrint('AR View registered: $isReady');
  }

  Future<void> _checkPermissions() async {
    final result = await FlutterSceneview().checkPermissions() ?? false;
    if (result) {
      setState(() => _hasPermission = true);
      _checkViewRegistration();
    }
  }

  @override
  Widget build(BuildContext context) {
    // This is used in the platform side to register the view.
    const String viewType = 'flutter_sceneview/ar_view';
    // Pass parameters to the platform side.
    const Map<String, dynamic> creationParams = <String, dynamic>{};

    if (!_hasPermission) {
      return const Center(child: Text("Waiting for camera permissions..."));
    }

    return PlatformViewLink(
      viewType: viewType,
      surfaceFactory: (context, controller) {
        return AndroidViewSurface(
          key: _arViewKey,
          controller: controller as AndroidViewController,
          gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
          hitTestBehavior: PlatformViewHitTestBehavior.opaque,
        );
      },
      onCreatePlatformView: (params) {
        return PlatformViewsService.initExpensiveAndroidView(
            id: params.id,
            viewType: viewType,
            layoutDirection: TextDirection.ltr,
            creationParams: creationParams,
            creationParamsCodec: const StandardMessageCodec(),
            onFocus: () {
              params.onFocusChanged(true);
            },
          )
          ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
          ..addOnPlatformViewCreatedListener((id) {
            onPlatformViewCreated(id);
          });
      },
    );
  }

  Future<void> onPlatformViewCreated(int id) async {
    final controller = await ARSceneController.init(
      sceneId: id,
      arViewKey: _arViewKey,
    );
    final sessionController = await ARSessionController.init(sceneId: id);

    _controller.complete(controller);
    _sessionController.complete(sessionController);

    widget.onViewCreated?.call(controller);
    widget.sessionController?.call(sessionController);
  }

  @override
  void dispose() {
    _disposeController();
    super.dispose();
  }

  Future<void> _disposeController() async {
    final ARSceneController controller = await _controller.future;
    final ARSessionController sessionController =
        await _sessionController.future;

    controller.dispose();
    sessionController.dispose();
  }
}
