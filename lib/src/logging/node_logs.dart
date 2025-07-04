class MissingNodeException implements Exception {
  /// Creates a [MissingNodeException] with an optional human-readable
  /// error message.
  MissingNodeException([this.message]);

  /// A human-readable error message, possibly null.
  final String? message;

  @override
  String toString() => 'MissingNodeException($message)';
}


class MissingPositionException implements Exception {
  /// Creates a [MissingPositionException] with an optional human-readable
  /// error message.
  MissingPositionException([this.message]);

  /// A human-readable error message, possibly null.
  final String? message;

  @override
  String toString() => 'MissingPositionException($message)';
}
