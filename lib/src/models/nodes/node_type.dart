import 'package:freezed_annotation/freezed_annotation.dart';

enum NodeType {
  model,

  shape,

  text,

  anchor,

  unknown;

  String get toUpper => name.toUpperCase();

  String get _normalizedName {
    // Remove underscores, spaces, and convert to lowercase
    return name.replaceAll('_', '').replaceAll(' ', '').toLowerCase();
  }

  static NodeType fromTypeName(String type) {
    if (type.isEmpty) {
      return NodeType.unknown;
    }

    // Normalize input: remove underscores, spaces, and convert to lowercase
    final normalized = type
        .trim()
        .replaceAll('_', '')
        .replaceAll(' ', '')
        .toLowerCase();

    return NodeType.values.firstWhere(
      (e) => e._normalizedName == normalized,
      orElse: () => NodeType.unknown,
    );
  }
}


class NodeTypeConverter extends JsonConverter<NodeType, String> {
  const NodeTypeConverter();

  @override
  NodeType fromJson(String json) => NodeType.fromTypeName(json);

  @override
  String toJson(NodeType object) => object.toUpper;
}
