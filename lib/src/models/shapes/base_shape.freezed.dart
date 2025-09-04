// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'base_shape.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
BaseShape _$BaseShapeFromJson(
  Map<String, dynamic> json
) {
        switch (json['shapeType']) {
                  case 'generic':
          return GenericShape.fromJson(
            json
          );
                case 'sphere':
          return SphereShape.fromJson(
            json
          );
                case 'torus':
          return TorusShape.fromJson(
            json
          );
                case 'cube':
          return CubeShape.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'shapeType',
  'BaseShape',
  'Invalid union type "${json['shapeType']}"!'
);
        }
      
}

/// @nodoc
mixin _$BaseShape {

@ShapeTypeConverter() ShapeType get shapeType;
/// Create a copy of BaseShape
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BaseShapeCopyWith<BaseShape> get copyWith => _$BaseShapeCopyWithImpl<BaseShape>(this as BaseShape, _$identity);

  /// Serializes this BaseShape to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BaseShape&&(identical(other.shapeType, shapeType) || other.shapeType == shapeType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,shapeType);

@override
String toString() {
  return 'BaseShape(shapeType: $shapeType)';
}


}

/// @nodoc
abstract mixin class $BaseShapeCopyWith<$Res>  {
  factory $BaseShapeCopyWith(BaseShape value, $Res Function(BaseShape) _then) = _$BaseShapeCopyWithImpl;
@useResult
$Res call({
@ShapeTypeConverter() ShapeType shapeType
});




}
/// @nodoc
class _$BaseShapeCopyWithImpl<$Res>
    implements $BaseShapeCopyWith<$Res> {
  _$BaseShapeCopyWithImpl(this._self, this._then);

  final BaseShape _self;
  final $Res Function(BaseShape) _then;

/// Create a copy of BaseShape
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? shapeType = null,}) {
  return _then(_self.copyWith(
shapeType: null == shapeType ? _self.shapeType : shapeType // ignore: cast_nullable_to_non_nullable
as ShapeType,
  ));
}

}


/// Adds pattern-matching-related methods to [BaseShape].
extension BaseShapePatterns on BaseShape {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( GenericShape value)?  generic,TResult Function( SphereShape value)?  sphere,TResult Function( TorusShape value)?  torus,TResult Function( CubeShape value)?  cube,required TResult orElse(),}){
final _that = this;
switch (_that) {
case GenericShape() when generic != null:
return generic(_that);case SphereShape() when sphere != null:
return sphere(_that);case TorusShape() when torus != null:
return torus(_that);case CubeShape() when cube != null:
return cube(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( GenericShape value)  generic,required TResult Function( SphereShape value)  sphere,required TResult Function( TorusShape value)  torus,required TResult Function( CubeShape value)  cube,}){
final _that = this;
switch (_that) {
case GenericShape():
return generic(_that);case SphereShape():
return sphere(_that);case TorusShape():
return torus(_that);case CubeShape():
return cube(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( GenericShape value)?  generic,TResult? Function( SphereShape value)?  sphere,TResult? Function( TorusShape value)?  torus,TResult? Function( CubeShape value)?  cube,}){
final _that = this;
switch (_that) {
case GenericShape() when generic != null:
return generic(_that);case SphereShape() when sphere != null:
return sphere(_that);case TorusShape() when torus != null:
return torus(_that);case CubeShape() when cube != null:
return cube(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function(@ShapeTypeConverter()  ShapeType shapeType)?  generic,TResult Function(@ShapeTypeConverter()  ShapeType shapeType,  double radius)?  sphere,TResult Function(@ShapeTypeConverter()  ShapeType shapeType,  double majorRadius,  double minorRadius)?  torus,TResult Function(@ShapeTypeConverter()  ShapeType shapeType,  double size,  double dx,  double dy,  double center)?  cube,required TResult orElse(),}) {final _that = this;
switch (_that) {
case GenericShape() when generic != null:
return generic(_that.shapeType);case SphereShape() when sphere != null:
return sphere(_that.shapeType,_that.radius);case TorusShape() when torus != null:
return torus(_that.shapeType,_that.majorRadius,_that.minorRadius);case CubeShape() when cube != null:
return cube(_that.shapeType,_that.size,_that.dx,_that.dy,_that.center);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function(@ShapeTypeConverter()  ShapeType shapeType)  generic,required TResult Function(@ShapeTypeConverter()  ShapeType shapeType,  double radius)  sphere,required TResult Function(@ShapeTypeConverter()  ShapeType shapeType,  double majorRadius,  double minorRadius)  torus,required TResult Function(@ShapeTypeConverter()  ShapeType shapeType,  double size,  double dx,  double dy,  double center)  cube,}) {final _that = this;
switch (_that) {
case GenericShape():
return generic(_that.shapeType);case SphereShape():
return sphere(_that.shapeType,_that.radius);case TorusShape():
return torus(_that.shapeType,_that.majorRadius,_that.minorRadius);case CubeShape():
return cube(_that.shapeType,_that.size,_that.dx,_that.dy,_that.center);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function(@ShapeTypeConverter()  ShapeType shapeType)?  generic,TResult? Function(@ShapeTypeConverter()  ShapeType shapeType,  double radius)?  sphere,TResult? Function(@ShapeTypeConverter()  ShapeType shapeType,  double majorRadius,  double minorRadius)?  torus,TResult? Function(@ShapeTypeConverter()  ShapeType shapeType,  double size,  double dx,  double dy,  double center)?  cube,}) {final _that = this;
switch (_that) {
case GenericShape() when generic != null:
return generic(_that.shapeType);case SphereShape() when sphere != null:
return sphere(_that.shapeType,_that.radius);case TorusShape() when torus != null:
return torus(_that.shapeType,_that.majorRadius,_that.minorRadius);case CubeShape() when cube != null:
return cube(_that.shapeType,_that.size,_that.dx,_that.dy,_that.center);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class GenericShape implements BaseShape {
  const GenericShape({@ShapeTypeConverter() this.shapeType = ShapeType.unknown});
  factory GenericShape.fromJson(Map<String, dynamic> json) => _$GenericShapeFromJson(json);

@override@JsonKey()@ShapeTypeConverter() final  ShapeType shapeType;

/// Create a copy of BaseShape
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GenericShapeCopyWith<GenericShape> get copyWith => _$GenericShapeCopyWithImpl<GenericShape>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GenericShapeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GenericShape&&(identical(other.shapeType, shapeType) || other.shapeType == shapeType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,shapeType);

@override
String toString() {
  return 'BaseShape.generic(shapeType: $shapeType)';
}


}

/// @nodoc
abstract mixin class $GenericShapeCopyWith<$Res> implements $BaseShapeCopyWith<$Res> {
  factory $GenericShapeCopyWith(GenericShape value, $Res Function(GenericShape) _then) = _$GenericShapeCopyWithImpl;
@override @useResult
$Res call({
@ShapeTypeConverter() ShapeType shapeType
});




}
/// @nodoc
class _$GenericShapeCopyWithImpl<$Res>
    implements $GenericShapeCopyWith<$Res> {
  _$GenericShapeCopyWithImpl(this._self, this._then);

  final GenericShape _self;
  final $Res Function(GenericShape) _then;

/// Create a copy of BaseShape
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? shapeType = null,}) {
  return _then(GenericShape(
shapeType: null == shapeType ? _self.shapeType : shapeType // ignore: cast_nullable_to_non_nullable
as ShapeType,
  ));
}


}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class SphereShape implements BaseShape {
  const SphereShape({@ShapeTypeConverter() this.shapeType = ShapeType.sphere, this.radius = 0.5});
  factory SphereShape.fromJson(Map<String, dynamic> json) => _$SphereShapeFromJson(json);

@override@JsonKey()@ShapeTypeConverter() final  ShapeType shapeType;
@JsonKey() final  double radius;

/// Create a copy of BaseShape
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SphereShapeCopyWith<SphereShape> get copyWith => _$SphereShapeCopyWithImpl<SphereShape>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SphereShapeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SphereShape&&(identical(other.shapeType, shapeType) || other.shapeType == shapeType)&&(identical(other.radius, radius) || other.radius == radius));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,shapeType,radius);

@override
String toString() {
  return 'BaseShape.sphere(shapeType: $shapeType, radius: $radius)';
}


}

/// @nodoc
abstract mixin class $SphereShapeCopyWith<$Res> implements $BaseShapeCopyWith<$Res> {
  factory $SphereShapeCopyWith(SphereShape value, $Res Function(SphereShape) _then) = _$SphereShapeCopyWithImpl;
@override @useResult
$Res call({
@ShapeTypeConverter() ShapeType shapeType, double radius
});




}
/// @nodoc
class _$SphereShapeCopyWithImpl<$Res>
    implements $SphereShapeCopyWith<$Res> {
  _$SphereShapeCopyWithImpl(this._self, this._then);

  final SphereShape _self;
  final $Res Function(SphereShape) _then;

/// Create a copy of BaseShape
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? shapeType = null,Object? radius = null,}) {
  return _then(SphereShape(
shapeType: null == shapeType ? _self.shapeType : shapeType // ignore: cast_nullable_to_non_nullable
as ShapeType,radius: null == radius ? _self.radius : radius // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class TorusShape implements BaseShape {
  const TorusShape({@ShapeTypeConverter() this.shapeType = ShapeType.torus, this.majorRadius = 0.5, this.minorRadius = 0.1});
  factory TorusShape.fromJson(Map<String, dynamic> json) => _$TorusShapeFromJson(json);

@override@JsonKey()@ShapeTypeConverter() final  ShapeType shapeType;
@JsonKey() final  double majorRadius;
@JsonKey() final  double minorRadius;

/// Create a copy of BaseShape
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TorusShapeCopyWith<TorusShape> get copyWith => _$TorusShapeCopyWithImpl<TorusShape>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TorusShapeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TorusShape&&(identical(other.shapeType, shapeType) || other.shapeType == shapeType)&&(identical(other.majorRadius, majorRadius) || other.majorRadius == majorRadius)&&(identical(other.minorRadius, minorRadius) || other.minorRadius == minorRadius));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,shapeType,majorRadius,minorRadius);

@override
String toString() {
  return 'BaseShape.torus(shapeType: $shapeType, majorRadius: $majorRadius, minorRadius: $minorRadius)';
}


}

/// @nodoc
abstract mixin class $TorusShapeCopyWith<$Res> implements $BaseShapeCopyWith<$Res> {
  factory $TorusShapeCopyWith(TorusShape value, $Res Function(TorusShape) _then) = _$TorusShapeCopyWithImpl;
@override @useResult
$Res call({
@ShapeTypeConverter() ShapeType shapeType, double majorRadius, double minorRadius
});




}
/// @nodoc
class _$TorusShapeCopyWithImpl<$Res>
    implements $TorusShapeCopyWith<$Res> {
  _$TorusShapeCopyWithImpl(this._self, this._then);

  final TorusShape _self;
  final $Res Function(TorusShape) _then;

/// Create a copy of BaseShape
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? shapeType = null,Object? majorRadius = null,Object? minorRadius = null,}) {
  return _then(TorusShape(
shapeType: null == shapeType ? _self.shapeType : shapeType // ignore: cast_nullable_to_non_nullable
as ShapeType,majorRadius: null == majorRadius ? _self.majorRadius : majorRadius // ignore: cast_nullable_to_non_nullable
as double,minorRadius: null == minorRadius ? _self.minorRadius : minorRadius // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class CubeShape implements BaseShape {
  const CubeShape({@ShapeTypeConverter() this.shapeType = ShapeType.cube, this.size = 1.0, this.dx = 0.1, this.dy = 0.1, this.center = 0});
  factory CubeShape.fromJson(Map<String, dynamic> json) => _$CubeShapeFromJson(json);

@override@JsonKey()@ShapeTypeConverter() final  ShapeType shapeType;
@JsonKey() final  double size;
@JsonKey() final  double dx;
@JsonKey() final  double dy;
@JsonKey() final  double center;

/// Create a copy of BaseShape
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CubeShapeCopyWith<CubeShape> get copyWith => _$CubeShapeCopyWithImpl<CubeShape>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CubeShapeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CubeShape&&(identical(other.shapeType, shapeType) || other.shapeType == shapeType)&&(identical(other.size, size) || other.size == size)&&(identical(other.dx, dx) || other.dx == dx)&&(identical(other.dy, dy) || other.dy == dy)&&(identical(other.center, center) || other.center == center));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,shapeType,size,dx,dy,center);

@override
String toString() {
  return 'BaseShape.cube(shapeType: $shapeType, size: $size, dx: $dx, dy: $dy, center: $center)';
}


}

/// @nodoc
abstract mixin class $CubeShapeCopyWith<$Res> implements $BaseShapeCopyWith<$Res> {
  factory $CubeShapeCopyWith(CubeShape value, $Res Function(CubeShape) _then) = _$CubeShapeCopyWithImpl;
@override @useResult
$Res call({
@ShapeTypeConverter() ShapeType shapeType, double size, double dx, double dy, double center
});




}
/// @nodoc
class _$CubeShapeCopyWithImpl<$Res>
    implements $CubeShapeCopyWith<$Res> {
  _$CubeShapeCopyWithImpl(this._self, this._then);

  final CubeShape _self;
  final $Res Function(CubeShape) _then;

/// Create a copy of BaseShape
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? shapeType = null,Object? size = null,Object? dx = null,Object? dy = null,Object? center = null,}) {
  return _then(CubeShape(
shapeType: null == shapeType ? _self.shapeType : shapeType // ignore: cast_nullable_to_non_nullable
as ShapeType,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as double,dx: null == dx ? _self.dx : dx // ignore: cast_nullable_to_non_nullable
as double,dy: null == dy ? _self.dy : dy // ignore: cast_nullable_to_non_nullable
as double,center: null == center ? _self.center : center // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
