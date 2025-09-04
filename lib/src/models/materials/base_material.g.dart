// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_material.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BaseMaterial _$BaseMaterialFromJson(Map<String, dynamic> json) =>
    _BaseMaterial(
      color: _$JsonConverterFromJson<List<dynamic>, Color>(
        json['color'],
        const ColorConverter().fromJson,
      ),
      metallic: (json['metallic'] as num?)?.toDouble(),
      roughness: (json['roughness'] as num?)?.toDouble(),
      reflectance: (json['reflectance'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$BaseMaterialToJson(_BaseMaterial instance) =>
    <String, dynamic>{
      'color': _$JsonConverterToJson<List<dynamic>, Color>(
        instance.color,
        const ColorConverter().toJson,
      ),
      'metallic': instance.metallic,
      'roughness': instance.roughness,
      'reflectance': instance.reflectance,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
