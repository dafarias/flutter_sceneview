import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'base_material.freezed.dart';
part 'base_material.g.dart';

@freezed
abstract class BaseMaterial with _$BaseMaterial {
  @JsonSerializable(explicitToJson: true)
  const factory BaseMaterial({
    @ColorConverter() Color? color,
    double? metallic,
    double? roughness,
    double? reflectance,
  }) = _BaseMaterial;

  const BaseMaterial._();

  factory BaseMaterial.fromJson(Map<String, dynamic> json) =>
      _$BaseMaterialFromJson(json);

  bool get isEmpty => this == BaseMaterial.empty;

  bool get isNotEmpty => this != BaseMaterial.empty;

  static final empty = _BaseMaterial();
}

class ColorConverter implements JsonConverter<Color, List<dynamic>> {
  const ColorConverter();

  @override
  Color fromJson(List<dynamic>? json) {
    if (json == null || json.length != 4) {
      throw ArgumentError(
        'Expected a list of 4 numbers [a, r, g, b] for Color',
      );
    }
    final argb = json.map((e) => (e as num).toInt()).toList();
    return Color.fromARGB(argb[0], argb[1], argb[2], argb[3]);
  }

  @override
  List<double> toJson(Color object) => [object.a, object.r, object.g, object.b];
}

class BaseMaterialConverter implements JsonConverter<BaseMaterial?, Object?> {
  const BaseMaterialConverter();

  @override
  BaseMaterial? fromJson(Object? json) {
    if (json == null) {
      throw ArgumentError('Expected non-null JSON for BaseMaterial');
    }
    if (json is! Map) {
      throw ArgumentError(
        'Expected a Map for BaseMaterial but got ${json.runtimeType}',
      );
    }

    return _$BaseMaterialFromJson(Map<String, dynamic>.from(json));
  }

  @override
  Map<String, dynamic>? toJson(BaseMaterial? object) {
    return object?.toJson();
  }
}
