import 'dart:ui';

class BaseMaterial {
  final Color? color;

  final double? metallic;

  final double? roughness;

  final double? reflectance;

  BaseMaterial({this.metallic, this.roughness, this.reflectance, this.color});


  Map<String, dynamic> toMap() => <String, dynamic>{
    'color': [color!.a, color!.r, color!.g, color!.b],
    'metallic': metallic,
    'roughness': roughness,
    'reflectance': reflectance,
  }..removeWhere((String k, dynamic v) => v == null);


}
