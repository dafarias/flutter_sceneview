import 'package:flutter/material.dart';
import 'package:flutter_sceneview/src/models/arcore/arcore_status.dart';

class ArcoreStatusDialog extends StatelessWidget {
  final ARCoreAvailability? status;
  final VoidCallback? onRetry;

  const ArcoreStatusDialog({super.key, required this.status, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return SizedBox();
  }

  Future<void> showARCoreDialog(BuildContext context) {
    return showAdaptiveDialog<Widget>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(_getDialogTitle(status)),
          content: Text(_getDialogMessage(status)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
            if (status == ARCoreAvailability.supportedNotInstalled ||
                status == ARCoreAvailability.supportedApkTooOld)
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  if (onRetry != null) {
                    onRetry!();
                  }
                },
                child: const Text('Retry'),
              ),
          ],
        );
      },
    );
  }

  static Future<void> closeARCoreDialog(BuildContext context) async {
    Navigator.of(context, rootNavigator: true).maybePop<dynamic>();
  }

  String _getDialogTitle(ARCoreAvailability? availability) {
    switch (availability) {
      case ARCoreAvailability.unsupportedDeviceNotCapable:
        return 'Unsupported Device';
      case ARCoreAvailability.supportedNotInstalled:
      case ARCoreAvailability.supportedApkTooOld:
        return 'ARCore Required';
      case ARCoreAvailability.unknownError:
      case ARCoreAvailability.unknownTimedOut:
        return 'ARCore Check Failed';
      case ARCoreAvailability.unknownChecking:
        return 'Checking ARCore...';
      case null:
        return 'Error';
      default:
        return 'ARCore Status';
    }
  }

  String _getDialogMessage(ARCoreAvailability? availability) {
    switch (availability) {
      case ARCoreAvailability.unsupportedDeviceNotCapable:
        return 'This device does not support ARCore.';
      case ARCoreAvailability.supportedNotInstalled:
        return 'ARCore is not installed. Please install it from the Play Store to use AR features.';
      case ARCoreAvailability.supportedApkTooOld:
        return 'Your ARCore version is outdated. Please update it from the Play Store.';
      case ARCoreAvailability.unknownError:
        return 'An error occurred while checking ARCore. Check logs for details.';
      case ARCoreAvailability.unknownTimedOut:
        return 'ARCore check timed out, possibly due to no internet connection.';
      case ARCoreAvailability.unknownChecking:
        return 'Please wait while we check ARCore compatibility...';
      case null:
        return 'An unexpected error occurred. Please try again.';
      default:
        return 'Unknown ARCore status.';
    }
  }
}
