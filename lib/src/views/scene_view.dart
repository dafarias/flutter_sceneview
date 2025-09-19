import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_sceneview/flutter_sceneview.dart';
import 'package:flutter_sceneview/src/views/arcore_status_dialog.dart';
import 'package:flutter_sceneview/src/views/tutorial_overlay.dart';

class SceneView extends StatefulWidget {
  const SceneView({
    super.key,
    this.overlayBehavior = OverlayBehavior.showOnInitialization,
    this.onViewCreated,
  });

  final Function(SceneViewController)? onViewCreated;
  final OverlayBehavior overlayBehavior;

  @override
  State<SceneView> createState() => _SceneViewState();
}

class _SceneViewState extends State<SceneView> with WidgetsBindingObserver {
  final FlutterSceneView _sceneView = FlutterSceneView();

  bool _hasPermission = false;
  bool _showOverlay = true;
  bool _hasTrackedOnce = false;
  bool _isReady = false;

  Completer<SceneViewController> _controller = Completer<SceneViewController>();

  StreamSubscription<ARTrackingEvent>? _trackingSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkARCoreStatus();
  }

  // Remove or improve usage
  @Deprecated('The method should be removed or improve its usage')
  // ignore: unused_element
  Future<bool> _checkViewRegistration() async {
    final isReady = await _sceneView.hasRegisteredView() ?? false;
    debugPrint('AR View registered: $isReady');
    return isReady;
  }

  Future<void> _checkPermissions() async {
    try {
      final result = await _sceneView.checkPermissions() ?? false;
      if (result) {
        setState(() {
          _hasPermission = true;
        });

        _initializeView();
      } else {
        // Call settings to give permissions
      }
    } catch (e) {
      debugPrint('Error checking permissions: $e');
    }
  }

  Future<void> _checkARCoreStatus() async {
    try {
      final availability = await _sceneView.checkARCore();
      switch (availability) {
        case ARCoreAvailability.supportedInstalled:
          _checkPermissions();
          break;

        case ARCoreAvailability.supportedNotInstalled:
        case ARCoreAvailability.supportedApkTooOld:
          final installResult = await _sceneView.requestARCoreInstall();
          if (installResult == ARCoreInstallStatus.installed) {
            _checkPermissions();
          } else {
            _showARCoreDialog(availability);
          }
          break;

        case _:
          _showARCoreDialog(availability);
          break;
      }
    } catch (e) {
      debugPrint('Error checking arcore status: $e');
      _showARCoreDialog(null);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _trackingSubscription?.cancel();
    _disposeControllers();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      final installResult = await _sceneView.checkARCore();
      // User may have just installed or updated ARCore, re-check.
      if (!_isReady && installResult == ARCoreAvailability.supportedInstalled) {
        _retryLoading();
        _dismissDialog();
      }
    }
  }

  void _showARCoreDialog(ARCoreAvailability? availability) {
    ArcoreStatusDialog(
      status: availability,
      onRetry: () {
        _dismissDialog();
        _retryLoading();
      },
    ).showARCoreDialog(context);
  }

  void _dismissDialog() {
    ArcoreStatusDialog.closeARCoreDialog(context);
  }

  Future<void> _retryLoading() async {
    if (_controller.isCompleted) {
      _disposeControllers();
    }
    setState(() {
      _hasPermission = false;
      _isReady = false;
      _controller = Completer<SceneViewController>();
    });
    _checkARCoreStatus();
  }

  Future<void> _initializeView() async {
    try {
      final controller = await _controller.future;
      _trackingSubscription = controller.session.trackingEvents.listen(
        (event) {
          // Optional: Customize based on failure (e.g., update text for event.failureReason)
          // if (event.failureReason == TrackingFailure.excessiveMotion) { ...
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
          _isReady = true;
        },
        onError: (e) {
          debugPrint('Error getting session events: $e');
        },
        onDone: () {
          debugPrint('Tracking stream closed');
        },
      );
    } catch (e) {
      debugPrint('Error initializing view: $e');
      debugPrint('Error getting session ready: $e');
    }
  }

  Future<void> _disposeControllers() async {
    final SceneViewController sceneViewController = await _controller.future;
    sceneViewController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasPermission) {
      return Column(
        children: <Widget>[
          Expanded(
            child: ColoredBox(
              color: Colors.black87.withValues(alpha: 0.95),
              child: Center(
                child: Text(
                  "Waiting for camera permissions...",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      );
    }
    return Stack(
      children: <Widget>[
        // Mask used to hide Scaffold background and intermeadiate states
        // before the full loading of the AR View.
        if (!_isReady)
          Container(
            color: Colors.black.withValues(alpha: 0.85),
            child: const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ),

        _AndroidViewSurface(
          onControllersReady: (sceneViewController) {
            if (!_controller.isCompleted) {
              _controller.complete(sceneViewController);
              widget.onViewCreated?.call(sceneViewController);
            } else {
              // Optional: handle the “reload” case if  a fresh controller
              //  is needed
              debugPrint('Controller already completed - ignoring duplicate');
            }
          },
        ),

        TutorialOverlay(show: _showOverlay),
      ],
    );
  }
}

class _AndroidViewSurface extends StatefulWidget {
  // Callback to pass controllers back
  final Function(SceneViewController)? onControllersReady;

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
        return PlatformViewsService.initAndroidView(
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
    final controller = await SceneViewController.init(
      viewId: id,
      arViewKey: _arViewKey,
    );

    // Pass controllers back via callback
    widget.onControllersReady?.call(controller);
  }
}
