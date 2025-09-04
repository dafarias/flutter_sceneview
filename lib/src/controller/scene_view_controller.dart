import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sceneview/src/channels/node_channel.dart';
import 'package:flutter_sceneview/src/channels/scene_channel.dart';
import 'package:flutter_sceneview/src/channels/session_channel.dart';
import 'package:flutter_sceneview/src/channels/view_channel.dart';
import 'package:flutter_sceneview/src/utils/channels.dart';
import 'package:flutter_sceneview/src/utils/scene_render.dart';

class SceneViewController {
  final int _sceneId;
  bool _isDisposed = false;
  bool _initialized = false;

  final GlobalKey arViewKey;

  late final NodeChannel node;
  late final SceneChannel scene;
  late final SessionChannel session;
  late final ViewChannel view;

  static late SceneViewController instance;

  SceneViewController._(this._sceneId, {required this.arViewKey}) {
    //'${Channels.node}_$_sceneId
    node = NodeChannel(MethodChannel(Channels.node));
    scene = SceneChannel(MethodChannel(Channels.scene));
    session = SessionChannel(MethodChannel(Channels.session));
    view = ViewChannel(MethodChannel(Channels.view));
  }

  ///   Must be called before accessing [instance].
  static Future<SceneViewController> init({
    required int sceneId,
    required GlobalKey arViewKey,
  }) async {
    final controller = SceneViewController._(sceneId, arViewKey: arViewKey);
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
    _isDisposed = true;
    _initialized = false;
    // Optionally clean up nodes, listeners, etc.
  }
}
