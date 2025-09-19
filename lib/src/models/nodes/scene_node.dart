import 'package:flutter_sceneview/src/models/nodes/node_config.dart';
import 'package:flutter_sceneview/src/models/nodes/node_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:flutter/foundation.dart';

part 'scene_node.freezed.dart';
part 'scene_node.g.dart';

@freezed
abstract class SceneNode with _$SceneNode {

  @JsonSerializable(explicitToJson: true)
  const factory SceneNode({
    @Default("") String nodeId,
    @Default(null) String? parentId,
    @Vector3Converter() required Vector3 position,
    @Vector3Converter() Vector3? rotation,
    @Vector3Converter() Vector3? scale,
    @NodeTypeConverter() NodeType? type,
    @NodeConfigConverter() required NodeConfig config,
    @Default(false) bool isPlaced,
  }) = _SceneNode;

  const SceneNode._();

  factory SceneNode.fromJson(Map<String, dynamic> json) =>
      _$SceneNodeFromJson(json);

  bool get isEmpty => this == SceneNode.empty;

  bool get isNotEmpty => this != SceneNode.empty;

  static final empty = _SceneNode(
    position: Vector3.zero(),
    type: NodeType.unknown,
    config: NodeConfig.unknown()
  );
  
}

class Vector3Converter
    implements JsonConverter<Vector3, Map<Object?, Object?>> {
  const Vector3Converter();

  @override
  Vector3 fromJson(Object? json) {
    if (json == null) {
      throw ArgumentError('Expected non-null JSON for Vector3');
    }
    if (json is! Map) {
      throw ArgumentError(
        'Expected a Map for Vector3 but got ${json.runtimeType}',
      );
    }
    final map = Map<String, dynamic>.from(json);
    return Vector3(
      (map['x'] as num).toDouble(),
      (map['y'] as num).toDouble(),
      (map['z'] as num).toDouble(),
    );
  }

  @override
  Map<String, dynamic> toJson(Vector3 object) => {
    'x': object.x,
    'y': object.y,
    'z': object.z,
  };
}

class Vector4Converter
    implements JsonConverter<Vector4, Map<Object?, Object?>> {
  const Vector4Converter();

  @override
  Vector4 fromJson(Object? json) {
    if (json == null) {
      throw ArgumentError('Expected non-null JSON for Vector4');
    }
    if (json is! Map) {
      throw ArgumentError(
        'Expected a Map for Vector4 but got ${json.runtimeType}',
      );
    }
    final map = Map<String, dynamic>.from(json);
    return Vector4(
      (map['x'] as num).toDouble(),
      (map['y'] as num).toDouble(),
      (map['z'] as num).toDouble(),
      (map['w'] as num).toDouble(),
    );
  }

  @override
  Map<String, dynamic> toJson(Vector4 object) => {
    'x': object.x,
    'y': object.y,
    'z': object.z,
    'w': object.w,
  };
}
