// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'node_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModelConfig _$ModelConfigFromJson(Map<String, dynamic> json) => ModelConfig(
  fileName: json['fileName'] as String?,
  loadDefault: json['loadDefault'] as bool? ?? false,
  $type: json['type'] as String?,
);

Map<String, dynamic> _$ModelConfigToJson(ModelConfig instance) =>
    <String, dynamic>{
      'fileName': instance.fileName,
      'loadDefault': instance.loadDefault,
      'type': instance.$type,
    };

ShapeConfig _$ShapeConfigFromJson(Map<String, dynamic> json) => ShapeConfig(
  shape: const BaseShapeConverter().fromJson(json['shape']),
  material: const BaseMaterialConverter().fromJson(json['material']),
  $type: json['type'] as String?,
);

Map<String, dynamic> _$ShapeConfigToJson(ShapeConfig instance) =>
    <String, dynamic>{
      'shape': const BaseShapeConverter().toJson(instance.shape),
      'material': const BaseMaterialConverter().toJson(instance.material),
      'type': instance.$type,
    };

TextConfig _$TextConfigFromJson(Map<String, dynamic> json) => TextConfig(
  text: json['text'] as String,
  fontFamily: json['fontFamily'] as String?,
  textColor: json['textColor'] == null
      ? Colors.white
      : const ColorConverter().fromJson(json['textColor'] as List),
  size: (json['size'] as num?)?.toDouble() ?? 1.0,
  $type: json['type'] as String?,
);

Map<String, dynamic> _$TextConfigToJson(TextConfig instance) =>
    <String, dynamic>{
      'text': instance.text,
      'fontFamily': instance.fontFamily,
      'textColor': const ColorConverter().toJson(instance.textColor),
      'size': instance.size,
      'type': instance.$type,
    };

AnchorConfig _$AnchorConfigFromJson(Map<String, dynamic> json) => AnchorConfig(
  anchorId: json['anchorId'] as String?,
  $type: json['type'] as String?,
);

Map<String, dynamic> _$AnchorConfigToJson(AnchorConfig instance) =>
    <String, dynamic>{'anchorId': instance.anchorId, 'type': instance.$type};

UnknownConfig _$UnknownConfigFromJson(Map<String, dynamic> json) =>
    UnknownConfig($type: json['type'] as String?);

Map<String, dynamic> _$UnknownConfigToJson(UnknownConfig instance) =>
    <String, dynamic>{'type': instance.$type};
