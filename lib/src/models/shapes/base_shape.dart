import 'package:flutter_sceneview/src/models/shapes/shape_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'base_shape.freezed.dart';
part 'base_shape.g.dart';

@Freezed(unionKey: 'shapeType')
@freezed
abstract class BaseShape with _$BaseShape {
  @JsonSerializable(explicitToJson: true)
  const factory BaseShape.generic({
    @ShapeTypeConverter() @Default(ShapeType.unknown) ShapeType shapeType,
  }) = GenericShape;

  @JsonSerializable(explicitToJson: true)
  const factory BaseShape.sphere({
    @ShapeTypeConverter() @Default(ShapeType.sphere) ShapeType shapeType,
    @Default(0.5) double radius,
  }) = SphereShape;

  @JsonSerializable(explicitToJson: true)
  const factory BaseShape.torus({
    @ShapeTypeConverter() @Default(ShapeType.torus) ShapeType shapeType,
    @Default(0.5) double majorRadius,
    @Default(0.1) double minorRadius,
  }) = TorusShape;

  @JsonSerializable(explicitToJson: true)
  const factory BaseShape.cube({
    @ShapeTypeConverter() @Default(ShapeType.cube) ShapeType shapeType,
    @Default(1.0) double size,
    @Default(0.1) double dx,
    @Default(0.1) double dy,
    @Default(0) double center,
  }) = CubeShape;

  factory BaseShape.fromJson(Map<String, dynamic> json) =>
      _$BaseShapeFromJson(json);
}

class BaseShapeConverter implements JsonConverter<BaseShape?, Object?> {
  const BaseShapeConverter();

  @override
  BaseShape? fromJson(Object? json) {
    if (json == null) {
      throw ArgumentError('Expected non-null JSON for BaseShape');
    }
    if (json is! Map) {
      throw ArgumentError(
        'Expected a Map for BaseShape but got ${json.runtimeType}',
      );
    }
    return _$BaseShapeFromJson(Map<String, dynamic>.from(json));
  }

  @override
  Map<String, dynamic>? toJson(BaseShape? object) {
    return object?.toJson();
  }
}