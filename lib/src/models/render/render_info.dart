// A simple helper class to hold widget info
import 'dart:ui';
import 'package:json_annotation/json_annotation.dart';

part 'render_info.g.dart';

@JsonSerializable()
class RenderInfo {

  @OffsetConverter()
  final Offset position;

  @SizeConverter()
  final Size size;
  final double pixelRatio;

  RenderInfo({
    required this.position,
    required this.size,
    required this.pixelRatio,
  });

  factory RenderInfo.fromJson(Map<String, dynamic> json) =>_$RenderInfoFromJson(json);

  Map<String, dynamic> toJson() => _$RenderInfoToJson(this);

}


class OffsetConverter implements JsonConverter<Offset, Map<String, dynamic>> {
  const OffsetConverter();

  @override
  Offset fromJson(Map<String, dynamic> json) {
    return Offset(
      (json['dx'] as num).toDouble(),
      (json['dy'] as num).toDouble(),
    );
  }

  @override
  Map<String, dynamic> toJson(Offset offset) => {
        'dx': offset.dx,
        'dy': offset.dy,
      };
}

class SizeConverter implements JsonConverter<Size, Map<String, dynamic>> {
  const SizeConverter();

  @override
  Size fromJson(Map<String, dynamic> json) {
    return Size(
      (json['width'] as num).toDouble(),
      (json['height'] as num).toDouble(),
    );
  }

  @override
  Map<String, dynamic> toJson(Size size) => {
        'width': size.width,
        'height': size.height,
      };
}