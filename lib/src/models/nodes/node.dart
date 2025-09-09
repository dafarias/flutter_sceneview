import 'package:flutter_sceneview/src/models/nodes/scene_node.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:flutter/foundation.dart';


part 'node.freezed.dart';
part 'node.g.dart';

@freezed
abstract class Node with _$Node {
  @JsonSerializable(explicitToJson: true)
  const factory Node({
    @Default("") String nodeId,
    @Vector3Converter() required Vector3 position,
    @Vector3Converter() Vector3? rotation,
    @Vector3Converter() Vector3? scale,
  }) = _Node;

  const Node._();

  factory Node.fromJson(Map<String, dynamic> json) => _$NodeFromJson(json);

  bool get isEmpty => this == Node.empty;

  bool get isNotEmpty => this != Node.empty;

  static final empty = _Node(
    position: Vector3.zero(),
    rotation: Vector3.zero(),
    scale: Vector3.all(1.0),
  );
}