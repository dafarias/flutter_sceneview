import 'package:flutter/services.dart';

class ViewChannel {
  final MethodChannel _channel;

  ViewChannel(this._channel);

  Future<void> checkInitilization() async {
    _channel.invokeMethod('init');
  }
}
