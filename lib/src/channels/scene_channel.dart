import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class SceneChannel {
  final MethodChannel _channel;

  SceneChannel(this._channel);

  Future<Uint8List> sceneSnapshot() async {
    final imageBytes = await _channel.invokeMethod<Uint8List>('takeSnapshot');
    return imageBytes ?? Uint8List.fromList([]);
  }

  Future<void> dispose() async {
    try {
      await _channel.invokeMethod('dispose', "sceneId");
    } catch (e) {
      debugPrint('SceneChannel dispose error: $e');
    }
  }
}
