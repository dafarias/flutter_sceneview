import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_sceneview/flutter_sceneview.dart';
import 'package:flutter_sceneview/src/views/tutorial_overlay.dart';

class SceneView extends StatefulWidget {
  const SceneView({
    super.key,
    this.onViewCreated,
    this.sessionController,
    this.overlayBehavior = OverlayBehavior.showOnInitialization,
  });

  final Function(ARSceneController)? onViewCreated;
  final Function(ARSessionController)? sessionController;
  final OverlayBehavior overlayBehavior;

  @override
  State<SceneView> createState() => _SceneViewState();
}

class _SceneViewState extends State<SceneView> {
  final Completer<ARSceneController> _controller =
      Completer<ARSceneController>();
  final Completer<ARSessionController> _sessionController =
      Completer<ARSessionController>();

  bool _hasPermission = false;
  bool _showOverlay = true;
  bool _hasTrackedOnce = false;
  bool _isReady = false;

  StreamSubscription<ARTrackingEvent>? _trackingSubscription;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  // Remove or improve usage
  @Deprecated('The method should be removed or improve its usage')
  Future<bool> _checkViewRegistration() async {
    final isReady = await FlutterSceneview().hasRegisteredView() ?? false;
    debugPrint('AR View registered: $isReady');
    return isReady;
  }

  Future<void> _checkPermissions() async {
    final result = await FlutterSceneview().checkPermissions() ?? false;
    if (result) {
      setState(() => _hasPermission = true);
      // After permissions, wait for session controller and start listening to events
      _sessionController.future
          .then((controller) {
            _trackingSubscription = controller.trackingEvents.listen((event) {
              setState(() {
                if (event.state == TrackingState.tracking) {
                  _hasTrackedOnce = true;
                }
                _showOverlay =
                    widget.overlayBehavior ==
                        OverlayBehavior.showAlwaysOnTrackingChanged
                    ? event.state != TrackingState.tracking
                    : !_hasTrackedOnce && event.state != TrackingState.tracking;
              });
              // Optional: Customize based on failure (e.g., update text for event.failureReason)
              // if (event.failureReason == TrackingFailure.excessiveMotion) { ... }

              _isReady = true;
            });
          })
          .catchError((e) {
            debugPrint('Error getting session controller: $e');
          });
    }
  }

  @override
  void dispose() {
    _trackingSubscription?.cancel();
    _disposeControllers();
    super.dispose();
  }

  Future<void> _disposeControllers() async {
    final ARSceneController controller = await _controller.future;
    final ARSessionController sessionController =
        await _sessionController.future;

    controller.dispose();
    sessionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasPermission) {
      return const Center(child: Text("Waiting for camera permissions..."));
    }
    return Stack(
      children: <Widget>[
        // Mask used to hide Scaffold background and intermeadiate states
        // before the full loading of the AR View.
        if (!_isReady)
          Container(
            color: Colors.black.withValues(alpha: 0.9),
            child: const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ),

        _AndroidViewSurface(
          onControllersReady: (sceneController, sessionController) {
            _controller.complete(sceneController);
            _sessionController.complete(sessionController);
            widget.onViewCreated?.call(sceneController);
            widget.sessionController?.call(sessionController);
          },
        ),

        TutorialOverlay(show: _showOverlay),
      ],
    );
  }
}

class _AndroidViewSurface extends StatefulWidget {
  // Callback to pass controllers back
  final Function(ARSceneController, ARSessionController)? onControllersReady;

  const _AndroidViewSurface({this.onControllersReady});

  @override
  State<StatefulWidget> createState() {
    return _AndroidViewSurfaceState();
  }
}

class _AndroidViewSurfaceState extends State<_AndroidViewSurface> {
  final GlobalKey _arViewKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    // This is used in the platform side to register the view.
    const String viewType = 'flutter_sceneview/ar_view';
    // Pass parameters to the platform side.
    const Map<String, dynamic> creationParams = <String, dynamic>{};

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

    // Pass controllers back via callback
    widget.onControllersReady?.call(controller, sessionController);
  }
}
