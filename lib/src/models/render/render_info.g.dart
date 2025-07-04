// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'render_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RenderInfo _$RenderInfoFromJson(Map<String, dynamic> json) => RenderInfo(
  position: const OffsetConverter().fromJson(
    json['position'] as Map<String, dynamic>,
  ),
  size: const SizeConverter().fromJson(json['size'] as Map<String, dynamic>),
  pixelRatio: (json['pixelRatio'] as num).toDouble(),
);

Map<String, dynamic> _$RenderInfoToJson(RenderInfo instance) =>
    <String, dynamic>{
      'position': const OffsetConverter().toJson(instance.position),
      'size': const SizeConverter().toJson(instance.size),
      'pixelRatio': instance.pixelRatio,
    };
