// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Node _$NodeFromJson(Map<String, dynamic> json) => _Node(
  nodeId: json['nodeId'] as String? ?? "",
  scale: (json['scale'] as num?)?.toDouble() ?? 0.1,
  position: const Vector3Converter().fromJson(json['position'] as Map),
  rotation: _$JsonConverterFromJson<Map<Object?, Object?>, Vector4>(
    json['rotation'],
    const Vector4Converter().fromJson,
  ),
);

Map<String, dynamic> _$NodeToJson(_Node instance) => <String, dynamic>{
  'nodeId': instance.nodeId,
  'scale': instance.scale,
  'position': const Vector3Converter().toJson(instance.position),
  'rotation': _$JsonConverterToJson<Map<Object?, Object?>, Vector4>(
    instance.rotation,
    const Vector4Converter().toJson,
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
