// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'node.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Node implements DiagnosticableTreeMixin {

 String get nodeId; double get scale;@Vector3Converter() Vector3 get position;@Vector4Converter() Vector4? get rotation;
/// Create a copy of Node
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NodeCopyWith<Node> get copyWith => _$NodeCopyWithImpl<Node>(this as Node, _$identity);

  /// Serializes this Node to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'Node'))
    ..add(DiagnosticsProperty('nodeId', nodeId))..add(DiagnosticsProperty('scale', scale))..add(DiagnosticsProperty('position', position))..add(DiagnosticsProperty('rotation', rotation));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Node&&(identical(other.nodeId, nodeId) || other.nodeId == nodeId)&&(identical(other.scale, scale) || other.scale == scale)&&(identical(other.position, position) || other.position == position)&&(identical(other.rotation, rotation) || other.rotation == rotation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,nodeId,scale,position,rotation);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'Node(nodeId: $nodeId, scale: $scale, position: $position, rotation: $rotation)';
}


}

/// @nodoc
abstract mixin class $NodeCopyWith<$Res>  {
  factory $NodeCopyWith(Node value, $Res Function(Node) _then) = _$NodeCopyWithImpl;
@useResult
$Res call({
 String nodeId, double scale,@Vector3Converter() Vector3 position,@Vector4Converter() Vector4? rotation
});




}
/// @nodoc
class _$NodeCopyWithImpl<$Res>
    implements $NodeCopyWith<$Res> {
  _$NodeCopyWithImpl(this._self, this._then);

  final Node _self;
  final $Res Function(Node) _then;

/// Create a copy of Node
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? nodeId = null,Object? scale = null,Object? position = null,Object? rotation = freezed,}) {
  return _then(_self.copyWith(
nodeId: null == nodeId ? _self.nodeId : nodeId // ignore: cast_nullable_to_non_nullable
as String,scale: null == scale ? _self.scale : scale // ignore: cast_nullable_to_non_nullable
as double,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Vector3,rotation: freezed == rotation ? _self.rotation : rotation // ignore: cast_nullable_to_non_nullable
as Vector4?,
  ));
}

}


/// Adds pattern-matching-related methods to [Node].
extension NodePatterns on Node {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Node value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Node() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Node value)  $default,){
final _that = this;
switch (_that) {
case _Node():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Node value)?  $default,){
final _that = this;
switch (_that) {
case _Node() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String nodeId,  double scale, @Vector3Converter()  Vector3 position, @Vector4Converter()  Vector4? rotation)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Node() when $default != null:
return $default(_that.nodeId,_that.scale,_that.position,_that.rotation);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String nodeId,  double scale, @Vector3Converter()  Vector3 position, @Vector4Converter()  Vector4? rotation)  $default,) {final _that = this;
switch (_that) {
case _Node():
return $default(_that.nodeId,_that.scale,_that.position,_that.rotation);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String nodeId,  double scale, @Vector3Converter()  Vector3 position, @Vector4Converter()  Vector4? rotation)?  $default,) {final _that = this;
switch (_that) {
case _Node() when $default != null:
return $default(_that.nodeId,_that.scale,_that.position,_that.rotation);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _Node extends Node with DiagnosticableTreeMixin {
  const _Node({this.nodeId = "", this.scale = 0.1, @Vector3Converter() required this.position, @Vector4Converter() this.rotation}): super._();
  factory _Node.fromJson(Map<String, dynamic> json) => _$NodeFromJson(json);

@override@JsonKey() final  String nodeId;
@override@JsonKey() final  double scale;
@override@Vector3Converter() final  Vector3 position;
@override@Vector4Converter() final  Vector4? rotation;

/// Create a copy of Node
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NodeCopyWith<_Node> get copyWith => __$NodeCopyWithImpl<_Node>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NodeToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'Node'))
    ..add(DiagnosticsProperty('nodeId', nodeId))..add(DiagnosticsProperty('scale', scale))..add(DiagnosticsProperty('position', position))..add(DiagnosticsProperty('rotation', rotation));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Node&&(identical(other.nodeId, nodeId) || other.nodeId == nodeId)&&(identical(other.scale, scale) || other.scale == scale)&&(identical(other.position, position) || other.position == position)&&(identical(other.rotation, rotation) || other.rotation == rotation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,nodeId,scale,position,rotation);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'Node(nodeId: $nodeId, scale: $scale, position: $position, rotation: $rotation)';
}


}

/// @nodoc
abstract mixin class _$NodeCopyWith<$Res> implements $NodeCopyWith<$Res> {
  factory _$NodeCopyWith(_Node value, $Res Function(_Node) _then) = __$NodeCopyWithImpl;
@override @useResult
$Res call({
 String nodeId, double scale,@Vector3Converter() Vector3 position,@Vector4Converter() Vector4? rotation
});




}
/// @nodoc
class __$NodeCopyWithImpl<$Res>
    implements _$NodeCopyWith<$Res> {
  __$NodeCopyWithImpl(this._self, this._then);

  final _Node _self;
  final $Res Function(_Node) _then;

/// Create a copy of Node
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? nodeId = null,Object? scale = null,Object? position = null,Object? rotation = freezed,}) {
  return _then(_Node(
nodeId: null == nodeId ? _self.nodeId : nodeId // ignore: cast_nullable_to_non_nullable
as String,scale: null == scale ? _self.scale : scale // ignore: cast_nullable_to_non_nullable
as double,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Vector3,rotation: freezed == rotation ? _self.rotation : rotation // ignore: cast_nullable_to_non_nullable
as Vector4?,
  ));
}


}

// dart format on
