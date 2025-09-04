// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'node_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
NodeConfig _$NodeConfigFromJson(
  Map<String, dynamic> json
) {
        switch (json['type']) {
                  case 'model':
          return ModelConfig.fromJson(
            json
          );
                case 'shape':
          return ShapeConfig.fromJson(
            json
          );
                case 'text':
          return TextConfig.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'type',
  'NodeConfig',
  'Invalid union type "${json['type']}"!'
);
        }
      
}

/// @nodoc
mixin _$NodeConfig {



  /// Serializes this NodeConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NodeConfig);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NodeConfig()';
}


}

/// @nodoc
class $NodeConfigCopyWith<$Res>  {
$NodeConfigCopyWith(NodeConfig _, $Res Function(NodeConfig) __);
}


/// Adds pattern-matching-related methods to [NodeConfig].
extension NodeConfigPatterns on NodeConfig {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ModelConfig value)?  model,TResult Function( ShapeConfig value)?  shape,TResult Function( TextConfig value)?  text,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ModelConfig() when model != null:
return model(_that);case ShapeConfig() when shape != null:
return shape(_that);case TextConfig() when text != null:
return text(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ModelConfig value)  model,required TResult Function( ShapeConfig value)  shape,required TResult Function( TextConfig value)  text,}){
final _that = this;
switch (_that) {
case ModelConfig():
return model(_that);case ShapeConfig():
return shape(_that);case TextConfig():
return text(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ModelConfig value)?  model,TResult? Function( ShapeConfig value)?  shape,TResult? Function( TextConfig value)?  text,}){
final _that = this;
switch (_that) {
case ModelConfig() when model != null:
return model(_that);case ShapeConfig() when shape != null:
return shape(_that);case TextConfig() when text != null:
return text(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String? fileName,  bool loadDefault)?  model,TResult Function(@BaseShapeConverter()  BaseShape? shape, @BaseMaterialConverter()  BaseMaterial? material)?  shape,TResult Function( String text,  String? fontFamily, @ColorConverter()  Color textColor,  double size)?  text,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ModelConfig() when model != null:
return model(_that.fileName,_that.loadDefault);case ShapeConfig() when shape != null:
return shape(_that.shape,_that.material);case TextConfig() when text != null:
return text(_that.text,_that.fontFamily,_that.textColor,_that.size);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String? fileName,  bool loadDefault)  model,required TResult Function(@BaseShapeConverter()  BaseShape? shape, @BaseMaterialConverter()  BaseMaterial? material)  shape,required TResult Function( String text,  String? fontFamily, @ColorConverter()  Color textColor,  double size)  text,}) {final _that = this;
switch (_that) {
case ModelConfig():
return model(_that.fileName,_that.loadDefault);case ShapeConfig():
return shape(_that.shape,_that.material);case TextConfig():
return text(_that.text,_that.fontFamily,_that.textColor,_that.size);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String? fileName,  bool loadDefault)?  model,TResult? Function(@BaseShapeConverter()  BaseShape? shape, @BaseMaterialConverter()  BaseMaterial? material)?  shape,TResult? Function( String text,  String? fontFamily, @ColorConverter()  Color textColor,  double size)?  text,}) {final _that = this;
switch (_that) {
case ModelConfig() when model != null:
return model(_that.fileName,_that.loadDefault);case ShapeConfig() when shape != null:
return shape(_that.shape,_that.material);case TextConfig() when text != null:
return text(_that.text,_that.fontFamily,_that.textColor,_that.size);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class ModelConfig implements NodeConfig {
  const ModelConfig({this.fileName, this.loadDefault = false, final  String? $type}): $type = $type ?? 'model';
  factory ModelConfig.fromJson(Map<String, dynamic> json) => _$ModelConfigFromJson(json);

 final  String? fileName;
@JsonKey() final  bool loadDefault;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of NodeConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ModelConfigCopyWith<ModelConfig> get copyWith => _$ModelConfigCopyWithImpl<ModelConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ModelConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModelConfig&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.loadDefault, loadDefault) || other.loadDefault == loadDefault));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fileName,loadDefault);

@override
String toString() {
  return 'NodeConfig.model(fileName: $fileName, loadDefault: $loadDefault)';
}


}

/// @nodoc
abstract mixin class $ModelConfigCopyWith<$Res> implements $NodeConfigCopyWith<$Res> {
  factory $ModelConfigCopyWith(ModelConfig value, $Res Function(ModelConfig) _then) = _$ModelConfigCopyWithImpl;
@useResult
$Res call({
 String? fileName, bool loadDefault
});




}
/// @nodoc
class _$ModelConfigCopyWithImpl<$Res>
    implements $ModelConfigCopyWith<$Res> {
  _$ModelConfigCopyWithImpl(this._self, this._then);

  final ModelConfig _self;
  final $Res Function(ModelConfig) _then;

/// Create a copy of NodeConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? fileName = freezed,Object? loadDefault = null,}) {
  return _then(ModelConfig(
fileName: freezed == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String?,loadDefault: null == loadDefault ? _self.loadDefault : loadDefault // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class ShapeConfig implements NodeConfig {
  const ShapeConfig({@BaseShapeConverter() this.shape, @BaseMaterialConverter() this.material, final  String? $type}): $type = $type ?? 'shape';
  factory ShapeConfig.fromJson(Map<String, dynamic> json) => _$ShapeConfigFromJson(json);

@BaseShapeConverter() final  BaseShape? shape;
@BaseMaterialConverter() final  BaseMaterial? material;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of NodeConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShapeConfigCopyWith<ShapeConfig> get copyWith => _$ShapeConfigCopyWithImpl<ShapeConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ShapeConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShapeConfig&&(identical(other.shape, shape) || other.shape == shape)&&(identical(other.material, material) || other.material == material));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,shape,material);

@override
String toString() {
  return 'NodeConfig.shape(shape: $shape, material: $material)';
}


}

/// @nodoc
abstract mixin class $ShapeConfigCopyWith<$Res> implements $NodeConfigCopyWith<$Res> {
  factory $ShapeConfigCopyWith(ShapeConfig value, $Res Function(ShapeConfig) _then) = _$ShapeConfigCopyWithImpl;
@useResult
$Res call({
@BaseShapeConverter() BaseShape? shape,@BaseMaterialConverter() BaseMaterial? material
});


$BaseShapeCopyWith<$Res>? get shape;$BaseMaterialCopyWith<$Res>? get material;

}
/// @nodoc
class _$ShapeConfigCopyWithImpl<$Res>
    implements $ShapeConfigCopyWith<$Res> {
  _$ShapeConfigCopyWithImpl(this._self, this._then);

  final ShapeConfig _self;
  final $Res Function(ShapeConfig) _then;

/// Create a copy of NodeConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? shape = freezed,Object? material = freezed,}) {
  return _then(ShapeConfig(
shape: freezed == shape ? _self.shape : shape // ignore: cast_nullable_to_non_nullable
as BaseShape?,material: freezed == material ? _self.material : material // ignore: cast_nullable_to_non_nullable
as BaseMaterial?,
  ));
}

/// Create a copy of NodeConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BaseShapeCopyWith<$Res>? get shape {
    if (_self.shape == null) {
    return null;
  }

  return $BaseShapeCopyWith<$Res>(_self.shape!, (value) {
    return _then(_self.copyWith(shape: value));
  });
}/// Create a copy of NodeConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BaseMaterialCopyWith<$Res>? get material {
    if (_self.material == null) {
    return null;
  }

  return $BaseMaterialCopyWith<$Res>(_self.material!, (value) {
    return _then(_self.copyWith(material: value));
  });
}
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class TextConfig implements NodeConfig {
  const TextConfig({required this.text, this.fontFamily, @ColorConverter() this.textColor = Colors.white, this.size = 1.0, final  String? $type}): $type = $type ?? 'text';
  factory TextConfig.fromJson(Map<String, dynamic> json) => _$TextConfigFromJson(json);

 final  String text;
 final  String? fontFamily;
@JsonKey()@ColorConverter() final  Color textColor;
// Default to white
@JsonKey() final  double size;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of NodeConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TextConfigCopyWith<TextConfig> get copyWith => _$TextConfigCopyWithImpl<TextConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TextConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TextConfig&&(identical(other.text, text) || other.text == text)&&(identical(other.fontFamily, fontFamily) || other.fontFamily == fontFamily)&&(identical(other.textColor, textColor) || other.textColor == textColor)&&(identical(other.size, size) || other.size == size));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,fontFamily,textColor,size);

@override
String toString() {
  return 'NodeConfig.text(text: $text, fontFamily: $fontFamily, textColor: $textColor, size: $size)';
}


}

/// @nodoc
abstract mixin class $TextConfigCopyWith<$Res> implements $NodeConfigCopyWith<$Res> {
  factory $TextConfigCopyWith(TextConfig value, $Res Function(TextConfig) _then) = _$TextConfigCopyWithImpl;
@useResult
$Res call({
 String text, String? fontFamily,@ColorConverter() Color textColor, double size
});




}
/// @nodoc
class _$TextConfigCopyWithImpl<$Res>
    implements $TextConfigCopyWith<$Res> {
  _$TextConfigCopyWithImpl(this._self, this._then);

  final TextConfig _self;
  final $Res Function(TextConfig) _then;

/// Create a copy of NodeConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? text = null,Object? fontFamily = freezed,Object? textColor = null,Object? size = null,}) {
  return _then(TextConfig(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,fontFamily: freezed == fontFamily ? _self.fontFamily : fontFamily // ignore: cast_nullable_to_non_nullable
as String?,textColor: null == textColor ? _self.textColor : textColor // ignore: cast_nullable_to_non_nullable
as Color,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
