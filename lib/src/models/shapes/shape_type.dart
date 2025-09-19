import 'package:json_annotation/json_annotation.dart';

enum ShapeType {
  cube,
  sphere,
  torus,
  unknown;

  /// Returns the type name as UPPERCASE for consistency with Kotlin or backend expectations
  String get toUpper => name.toUpperCase();

  /// Parses a string into a Shapes enum value with normalization.
  /// Trims whitespace and converts to uppercase for comparison.
  /// Defaults to Shapes.sphere if not found.
  static ShapeType fromTypeName(String type) {
    final normalized = type.trim().toUpperCase();
    return ShapeType.values.firstWhere(
      (e) => e.toUpper == normalized,
      orElse: () => ShapeType.sphere,
    );
  }
}

class ShapeTypeConverter extends JsonConverter<ShapeType, String> {
  const ShapeTypeConverter();

  @override
  ShapeType fromJson(String json) => ShapeType.fromTypeName(json);

  @override
  String toJson(ShapeType object) => object.toUpper;
}
