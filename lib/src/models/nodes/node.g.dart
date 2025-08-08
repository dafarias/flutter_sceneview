// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Node _$NodeFromJson(Map<String, dynamic> json) => _Node(
  nodeId: json['nodeId'] as String? ?? "",
  position: const Vector3Converter().fromJson(json['position'] as Map),
  rotation: _$JsonConverterFromJson<Map<Object?, Object?>, Vector3>(
    json['rotation'],
    const Vector3Converter().fromJson,
  ),
  scale: _$JsonConverterFromJson<Map<Object?, Object?>, Vector3>(
    json['scale'],
    const Vector3Converter().fromJson,
  ),
);

Map<String, dynamic> _$NodeToJson(_Node instance) => <String, dynamic>{
  'nodeId': instance.nodeId,
  'position': const Vector3Converter().toJson(instance.position),
  'rotation': _$JsonConverterToJson<Map<Object?, Object?>, Vector3>(
    instance.rotation,
    const Vector3Converter().toJson,
  ),
  'scale': _$JsonConverterToJson<Map<Object?, Object?>, Vector3>(
    instance.scale,
    const Vector3Converter().toJson,
  ),
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
