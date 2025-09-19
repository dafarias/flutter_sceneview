import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class ViewChannel {
  final MethodChannel _channel;
  final int viewId;

  ViewChannel(this._channel, [this.viewId = 0]);

  Future<void> checkInitilization() async {
    await _channel.invokeMethod('init');
  }

  Future<void> dispose() async {
    try {
      await _channel.invokeMethod('dispose', viewId);
    } catch (e) {
      debugPrint('ViewChannel dispose error: $e');
    }
  }
}
