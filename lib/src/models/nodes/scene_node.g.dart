// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scene_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SceneNode _$SceneNodeFromJson(Map<String, dynamic> json) => _SceneNode(
  nodeId: json['nodeId'] as String? ?? "",
  parentId: json['parentId'] as String? ?? null,
  position: const Vector3Converter().fromJson(json['position'] as Map),
  rotation: _$JsonConverterFromJson<Map<Object?, Object?>, Vector3>(
    json['rotation'],
    const Vector3Converter().fromJson,
  ),
  scale: _$JsonConverterFromJson<Map<Object?, Object?>, Vector3>(
    json['scale'],
    const Vector3Converter().fromJson,
  ),
  type: _$JsonConverterFromJson<String, NodeType>(
    json['type'],
    const NodeTypeConverter().fromJson,
  ),
  config: const NodeConfigConverter().fromJson(json['config'] as Map),
  isPlaced: json['isPlaced'] as bool? ?? false,
);

Map<String, dynamic> _$SceneNodeToJson(_SceneNode instance) =>
    <String, dynamic>{
      'nodeId': instance.nodeId,
      'parentId': instance.parentId,
      'position': const Vector3Converter().toJson(instance.position),
      'rotation': _$JsonConverterToJson<Map<Object?, Object?>, Vector3>(
        instance.rotation,
        const Vector3Converter().toJson,
      ),
      'scale': _$JsonConverterToJson<Map<Object?, Object?>, Vector3>(
        instance.scale,
        const Vector3Converter().toJson,
      ),
      'type': _$JsonConverterToJson<String, NodeType>(
        instance.type,
        const NodeTypeConverter().toJson,
      ),
      'config': const NodeConfigConverter().toJson(instance.config),
      'isPlaced': instance.isPlaced,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
