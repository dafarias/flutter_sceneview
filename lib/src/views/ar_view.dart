import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ARView extends StatelessWidget {
  const ARView({super.key});

  @override
  Widget build(BuildContext context) {
    const String viewType = 'flutter_sceneview/ar_view';

    if (defaultTargetPlatform == TargetPlatform.android) {
      return const AndroidView(
        viewType: viewType,
        layoutDirection: TextDirection.ltr,
        creationParams: <String, dynamic>{},
        creationParamsCodec: StandardMessageCodec(),
      );
    }

    return const Text('ARView is only supported on Android for now.');
  }
}
