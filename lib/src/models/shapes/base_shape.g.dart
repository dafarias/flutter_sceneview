// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_shape.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenericShape _$GenericShapeFromJson(Map<String, dynamic> json) => GenericShape(
  shapeType: json['shapeType'] == null
      ? ShapeType.unknown
      : const ShapeTypeConverter().fromJson(json['shapeType'] as String),
);

Map<String, dynamic> _$GenericShapeToJson(GenericShape instance) =>
    <String, dynamic>{
      'shapeType': const ShapeTypeConverter().toJson(instance.shapeType),
    };

SphereShape _$SphereShapeFromJson(Map<String, dynamic> json) => SphereShape(
  shapeType: json['shapeType'] == null
      ? ShapeType.sphere
      : const ShapeTypeConverter().fromJson(json['shapeType'] as String),
  radius: (json['radius'] as num?)?.toDouble() ?? 0.5,
);

Map<String, dynamic> _$SphereShapeToJson(SphereShape instance) =>
    <String, dynamic>{
      'shapeType': const ShapeTypeConverter().toJson(instance.shapeType),
      'radius': instance.radius,
    };

TorusShape _$TorusShapeFromJson(Map<String, dynamic> json) => TorusShape(
  shapeType: json['shapeType'] == null
      ? ShapeType.torus
      : const ShapeTypeConverter().fromJson(json['shapeType'] as String),
  majorRadius: (json['majorRadius'] as num?)?.toDouble() ?? 0.5,
  minorRadius: (json['minorRadius'] as num?)?.toDouble() ?? 0.1,
);

Map<String, dynamic> _$TorusShapeToJson(TorusShape instance) =>
    <String, dynamic>{
      'shapeType': const ShapeTypeConverter().toJson(instance.shapeType),
      'majorRadius': instance.majorRadius,
      'minorRadius': instance.minorRadius,
    };

CubeShape _$CubeShapeFromJson(Map<String, dynamic> json) => CubeShape(
  shapeType: json['shapeType'] == null
      ? ShapeType.cube
      : const ShapeTypeConverter().fromJson(json['shapeType'] as String),
  size: (json['size'] as num?)?.toDouble() ?? 1.0,
  dx: (json['dx'] as num?)?.toDouble() ?? 0.1,
  dy: (json['dy'] as num?)?.toDouble() ?? 0.1,
  center: (json['center'] as num?)?.toDouble() ?? 0,
);

Map<String, dynamic> _$CubeShapeToJson(CubeShape instance) => <String, dynamic>{
  'shapeType': const ShapeTypeConverter().toJson(instance.shapeType),
  'size': instance.size,
  'dx': instance.dx,
  'dy': instance.dy,
  'center': instance.center,
};
