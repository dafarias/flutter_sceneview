import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sceneview/src/channels/node_channel.dart';
import 'package:flutter_sceneview/src/channels/scene_channel.dart';
import 'package:flutter_sceneview/src/channels/session_channel.dart';
import 'package:flutter_sceneview/src/channels/view_channel.dart';
import 'package:flutter_sceneview/src/utils/channels.dart';
import 'package:flutter_sceneview/src/utils/scene_render.dart';

class SceneViewController {
  final int _viewId;
  bool _isDisposed = false;
  bool _initialized = false;

  final GlobalKey arViewKey;

  late final NodeChannel node;
  late final SceneChannel scene;
  late final SessionChannel session;
  late final ViewChannel view;

  static late SceneViewController instance;

  bool get isDisposed => _isDisposed;

  SceneViewController._(this._viewId, {required this.arViewKey}) {
    //'${Channels.node}_$_sceneId
    node = NodeChannel(MethodChannel(Channels.node), _viewId);
    scene = SceneChannel(MethodChannel(Channels.scene), _viewId);
    session = SessionChannel(MethodChannel(Channels.session), _viewId);
    view = ViewChannel(MethodChannel(Channels.view), _viewId);
  }

  ///   Must be called before accessing [instance].
  static Future<SceneViewController> init({
    required int viewId,
    required GlobalKey arViewKey,
  }) async {
    final controller = SceneViewController._(viewId, arViewKey: arViewKey);
    instance = controller;
    await controller._init();
    return controller;
  }

  Future<void> _init() async {
    //Initialize all the method channels here
    if (_initialized) return;

    SceneUtils.arViewKey = arViewKey;
    await view.checkInitilization();
    _initialized = true;
  }

  void dispose() {
    node.dispose();
    scene.dispose();
    session.dispose();
    view.dispose();

    _isDisposed = true;
    _initialized = false;
    // Optionally clean up nodes, listeners, etc.
  }
}
