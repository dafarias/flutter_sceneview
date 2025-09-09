import 'package:flutter/material.dart';
import 'package:flutter_sceneview/src/models/materials/base_material.dart';
import 'package:flutter_sceneview/src/models/shapes/base_shape.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'node_config.freezed.dart';
part 'node_config.g.dart';

@Freezed(unionKey: 'type')
@freezed
abstract class NodeConfig with _$NodeConfig {
  @JsonSerializable(explicitToJson: true)
  // if model is not empty, then the load default flag should be set
  // automatically
  const factory NodeConfig.model({
    String? fileName,
    @Default(false) bool loadDefault,
  }) = ModelConfig;

  @JsonSerializable(explicitToJson: true)
  const factory NodeConfig.shape({
    @BaseShapeConverter() BaseShape? shape,
    @BaseMaterialConverter() BaseMaterial? material,
  }) = ShapeConfig;

  @JsonSerializable(explicitToJson: true)
  const factory NodeConfig.text({
    required String text,
    String? fontFamily,
    @ColorConverter()
    @Default(Colors.white)
    Color textColor, // Default to white
    @Default(1.0) double size,
  }) = TextConfig;

  const factory NodeConfig.anchor({String? anchorId}) = AnchorConfig;

  const factory NodeConfig.unknown() = UnknownConfig;

  factory NodeConfig.fromJson(Map<String, dynamic> json) =>
      _$NodeConfigFromJson(json);
}

class NodeConfigConverter
    extends JsonConverter<NodeConfig, Map<Object?, Object?>> {
  const NodeConfigConverter();

  @override
  NodeConfig fromJson(Object? json) {
    if (json == null) {
      throw ArgumentError('Expected non-null JSON for NodeConfig');
    }
    if (json is! Map) {
      throw ArgumentError(
        'Expected a Map for NodeConfig but got ${json.runtimeType}',
      );
    }

    return NodeConfig.fromJson(Map<String, dynamic>.from(json));
  }

  @override
  Map<String, dynamic> toJson(NodeConfig object) => object.toJson();
}
