enum Shapes {
  cube,
  sphere,
  torus;

  /// Returns the type name as UPPERCASE for consistency with Kotlin or backend expectations
  String get toUpper => name.toUpperCase();

  /// Parses a string into a Shapes enum value with normalization.
  /// Trims whitespace and converts to uppercase for comparison.
  /// Defaults to Shapes.sphere if not found.
  static Shapes fromTypeName(String type) {
    final normalized = type.trim().toUpperCase();
    return Shapes.values.firstWhere(
      (e) => e.toUpper == normalized,
      orElse: () => Shapes.sphere,
    );
  }

}
