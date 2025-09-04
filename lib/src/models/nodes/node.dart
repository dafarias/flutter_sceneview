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

// class Vector3Converter implements JsonConverter<Vector3, Map<Object?, Object?>> {
//   const Vector3Converter();


//   @override
//   Vector3 fromJson(Object? json) {
//     if (json == null) {
//       throw ArgumentError('Expected non-null JSON for Vector3');
//     }
//     if (json is! Map) {
//       throw ArgumentError('Expected a Map for Vector3 but got ${json.runtimeType}');
//     }

//     final map = Map<String, dynamic>.from(json);
//     return Vector3(
//       (map['x'] as num).toDouble(),
//       (map['y'] as num).toDouble(),
//       (map['z'] as num).toDouble(),
//     );
//   }

//   @override
//   Map<String, dynamic> toJson(Vector3 object) => {
//     'x': object.x,
//     'y': object.y,
//     'z': object.z,
//   };
// }



// class Vector4Converter implements JsonConverter<Vector4, Map<Object?, Object?>> {
//   const Vector4Converter();

//   @override
//   Vector4 fromJson(Object? json) {
//     if (json == null) {
//       throw ArgumentError('Expected non-null JSON for Vector4');
//     }
//     if (json is! Map) {
//       throw ArgumentError('Expected a Map for Vector4 but got ${json.runtimeType}');
//     }

//     final map = Map<String, dynamic>.from(json);
//     return Vector4(
//       (map['x'] as num).toDouble(),
//       (map['y'] as num).toDouble(),
//       (map['z'] as num).toDouble(),
//       (map['w'] as num).toDouble(),
//     );
//   }

//   @override
//   Map<String, dynamic> toJson(Vector4 object) => {
//     'x': object.x,
//     'y': object.y,
//     'z': object.z,
//     'w': object.w,
//   };
// }