import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sceneview/flutter_sceneview.dart';
//todo: add import to barrel file
import 'package:flutter_sceneview/src/entities/arcore_hit_test_result.dart';

import 'flutter_sceneview_platform_interface.dart';

/// An implementation of [FlutterSceneviewPlatform] that uses method channels.
class MethodChannelFlutterSceneview extends FlutterSceneviewPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_sceneview');
  final arViewChannel = MethodChannel('ar_view_wrapper');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }

  @override
  Future<bool?> hasRegisteredView() async {
    final isReady = await methodChannel.invokeMethod<bool>('isReady');
    return isReady;
  }

  @override
  Future<bool?> checkPermissions() async {
    final hasCameraPermissions = await methodChannel.invokeMethod<bool>(
      'checkPermissions',
    );
    return hasCameraPermissions;
  }

  @override
  Future<Node?> addNode({double x = 0, double y = 0, String? fileName}) async {
    return await ARSceneController.instance.addNode(x: x, y: y, fileName: fileName);
  }

  @override
  Future<List<ArCoreHitTestResult>> performHitTest(double x, double y) async {
    final hitTestResultRaw = await arViewChannel.invokeMethod<List<dynamic>?>(
      'performHitTest',
      {'x': x, 'y': y},
    );

    final hitTestResult =
        hitTestResultRaw
            ?.map((item) => ArCoreHitTestResult.fromMap(item))
            .toList() ??
        [];
    return hitTestResult;
  }
}
