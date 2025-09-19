import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class SceneChannel {
  final MethodChannel _channel;
  final int viewId;

  SceneChannel(this._channel, [this.viewId = 0]);


  Future<Uint8List> sceneSnapshot() async {
    final imageBytes = await _channel.invokeMethod<Uint8List>('takeSnapshot');
    return imageBytes ?? Uint8List.fromList([]);
  }

  Future<void> dispose() async {
    try {
      await _channel.invokeMethod('dispose', viewId);
    } catch (e) {
      debugPrint('SceneChannel dispose error: $e');
    }
  }
}
