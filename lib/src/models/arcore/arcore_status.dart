/// Represents the availability status of ARCore on the device.
enum ARCoreAvailability {
  /// The device and Android version are supported, but the ARCore APK version is too old.
  supportedApkTooOld,

  /// ARCore is supported, installed, and available to use.
  supportedInstalled,

  /// The device and Android version are supported, but the ARCore APK is not installed.
  supportedNotInstalled,

  /// ARCore is not installed, and a query has been issued to check if ARCore is supported.
  unknownChecking,

  /// An internal error occurred while determining ARCore availability.
  unknownError,

  /// ARCore is not installed, and the query timed out, possibly due to being offline.
  unknownTimedOut,

  /// ARCore is not supported on this device.
  unsupportedDeviceNotCapable;

  /// Returns true if this is one of the SUPPORTED_... values.
  bool get isSupported => [
    ARCoreAvailability.supportedInstalled,
    ARCoreAvailability.supportedNotInstalled,
    ARCoreAvailability.supportedApkTooOld,
  ].contains(this);

  /// Returns true if this state is temporary and the application should check again soon.
  bool get isTransient => [ARCoreAvailability.unknownChecking].contains(this);

  /// Returns true if this is one of the UNKNOWN_... values.
  bool get isUnknown => [
    ARCoreAvailability.unknownChecking,
    ARCoreAvailability.unknownError,
    ARCoreAvailability.unknownTimedOut,
  ].contains(this);

  /// Returns true if this is one of the UNSUPPORTED_... values.
  bool get isUnsupported =>
      [ARCoreAvailability.unsupportedDeviceNotCapable].contains(this);

  /// Converts the enum to a string status compatible with the Kotlin return value.
  String toStatusString() => name
      .replaceFirstMapped(
        RegExp('([A-Z])'),
        (match) => '_${match.group(0)?.toLowerCase()}',
      )
      .substring(1);

  /// Parses a Kotlin-returned status string into an ArCoreAvailability enum.
  static ARCoreAvailability fromStatusString(String status) {
    // Map Kotlin snake_case strings to enum values
    const map = {
      'supported_apk_too_old': ARCoreAvailability.supportedApkTooOld,
      'supported_installed': ARCoreAvailability.supportedInstalled,
      'supported_not_installed': ARCoreAvailability.supportedNotInstalled,
      'unknown_checking': ARCoreAvailability.unknownChecking,
      'unknown_error': ARCoreAvailability.unknownError,
      'unknown_timed_out': ARCoreAvailability.unknownTimedOut,
      'unsupported_device': ARCoreAvailability.unsupportedDeviceNotCapable,
    };
    return map[status.toLowerCase()] ??
        ARCoreAvailability.unknownError; // Default to unknownError on mismatch
  }
}

/// Controls the behavior of the installation UI.
enum ARCoreInstallBehavior {
  /// Include Cancel button in initial prompt and allow easily backing out after installation.
  optional,

  /// Hide the Cancel button during initial prompt and prevent user from exiting via tap-outside.
  required,
}

/// Indicates the outcome of a call to requestInstall().
enum ARCoreInstallStatus {
  /// The requested resource is already installed.
  installed,

  /// Installation of the resource was requested. The current activity will be paused.
  installRequested;

  static ARCoreInstallStatus fromStatusString(String status) {
    // Map Kotlin snake_case strings to enum values
    const map = {
      'installed': ARCoreInstallStatus.installed,
      'install_requested': ARCoreInstallStatus.installRequested,
    };
    return map[status.toLowerCase()] ?? ARCoreInstallStatus.installRequested;
  }
}

/// Controls the message displayed by the installation UI.
enum ARCoreUserMessageType {
  /// Display a localized message like "This application requires ARCore...".
  application,

  /// Display a localized message like "This feature requires ARCore...".
  feature,

  /// Application has explained why ARCore is required, skip user education dialog.
  userAlreadyInformed,
}
