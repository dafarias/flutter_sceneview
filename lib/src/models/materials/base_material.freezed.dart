// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'base_material.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BaseMaterial {

@ColorConverter() Color? get color; double? get metallic; double? get roughness; double? get reflectance;
/// Create a copy of BaseMaterial
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BaseMaterialCopyWith<BaseMaterial> get copyWith => _$BaseMaterialCopyWithImpl<BaseMaterial>(this as BaseMaterial, _$identity);

  /// Serializes this BaseMaterial to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BaseMaterial&&(identical(other.color, color) || other.color == color)&&(identical(other.metallic, metallic) || other.metallic == metallic)&&(identical(other.roughness, roughness) || other.roughness == roughness)&&(identical(other.reflectance, reflectance) || other.reflectance == reflectance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,color,metallic,roughness,reflectance);

@override
String toString() {
  return 'BaseMaterial(color: $color, metallic: $metallic, roughness: $roughness, reflectance: $reflectance)';
}


}

/// @nodoc
abstract mixin class $BaseMaterialCopyWith<$Res>  {
  factory $BaseMaterialCopyWith(BaseMaterial value, $Res Function(BaseMaterial) _then) = _$BaseMaterialCopyWithImpl;
@useResult
$Res call({
@ColorConverter() Color? color, double? metallic, double? roughness, double? reflectance
});




}
/// @nodoc
class _$BaseMaterialCopyWithImpl<$Res>
    implements $BaseMaterialCopyWith<$Res> {
  _$BaseMaterialCopyWithImpl(this._self, this._then);

  final BaseMaterial _self;
  final $Res Function(BaseMaterial) _then;

/// Create a copy of BaseMaterial
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? color = freezed,Object? metallic = freezed,Object? roughness = freezed,Object? reflectance = freezed,}) {
  return _then(_self.copyWith(
color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as Color?,metallic: freezed == metallic ? _self.metallic : metallic // ignore: cast_nullable_to_non_nullable
as double?,roughness: freezed == roughness ? _self.roughness : roughness // ignore: cast_nullable_to_non_nullable
as double?,reflectance: freezed == reflectance ? _self.reflectance : reflectance // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [BaseMaterial].
extension BaseMaterialPatterns on BaseMaterial {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BaseMaterial value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BaseMaterial() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BaseMaterial value)  $default,){
final _that = this;
switch (_that) {
case _BaseMaterial():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BaseMaterial value)?  $default,){
final _that = this;
switch (_that) {
case _BaseMaterial() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@ColorConverter()  Color? color,  double? metallic,  double? roughness,  double? reflectance)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BaseMaterial() when $default != null:
return $default(_that.color,_that.metallic,_that.roughness,_that.reflectance);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@ColorConverter()  Color? color,  double? metallic,  double? roughness,  double? reflectance)  $default,) {final _that = this;
switch (_that) {
case _BaseMaterial():
return $default(_that.color,_that.metallic,_that.roughness,_that.reflectance);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@ColorConverter()  Color? color,  double? metallic,  double? roughness,  double? reflectance)?  $default,) {final _that = this;
switch (_that) {
case _BaseMaterial() when $default != null:
return $default(_that.color,_that.metallic,_that.roughness,_that.reflectance);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _BaseMaterial extends BaseMaterial {
  const _BaseMaterial({@ColorConverter() this.color, this.metallic, this.roughness, this.reflectance}): super._();
  factory _BaseMaterial.fromJson(Map<String, dynamic> json) => _$BaseMaterialFromJson(json);

@override@ColorConverter() final  Color? color;
@override final  double? metallic;
@override final  double? roughness;
@override final  double? reflectance;

/// Create a copy of BaseMaterial
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BaseMaterialCopyWith<_BaseMaterial> get copyWith => __$BaseMaterialCopyWithImpl<_BaseMaterial>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BaseMaterialToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BaseMaterial&&(identical(other.color, color) || other.color == color)&&(identical(other.metallic, metallic) || other.metallic == metallic)&&(identical(other.roughness, roughness) || other.roughness == roughness)&&(identical(other.reflectance, reflectance) || other.reflectance == reflectance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,color,metallic,roughness,reflectance);

@override
String toString() {
  return 'BaseMaterial(color: $color, metallic: $metallic, roughness: $roughness, reflectance: $reflectance)';
}


}

/// @nodoc
abstract mixin class _$BaseMaterialCopyWith<$Res> implements $BaseMaterialCopyWith<$Res> {
  factory _$BaseMaterialCopyWith(_BaseMaterial value, $Res Function(_BaseMaterial) _then) = __$BaseMaterialCopyWithImpl;
@override @useResult
$Res call({
@ColorConverter() Color? color, double? metallic, double? roughness, double? reflectance
});




}
/// @nodoc
class __$BaseMaterialCopyWithImpl<$Res>
    implements _$BaseMaterialCopyWith<$Res> {
  __$BaseMaterialCopyWithImpl(this._self, this._then);

  final _BaseMaterial _self;
  final $Res Function(_BaseMaterial) _then;

/// Create a copy of BaseMaterial
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? color = freezed,Object? metallic = freezed,Object? roughness = freezed,Object? reflectance = freezed,}) {
  return _then(_BaseMaterial(
color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as Color?,metallic: freezed == metallic ? _self.metallic : metallic // ignore: cast_nullable_to_non_nullable
as double?,roughness: freezed == roughness ? _self.roughness : roughness // ignore: cast_nullable_to_non_nullable
as double?,reflectance: freezed == reflectance ? _self.reflectance : reflectance // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
