// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scene_node.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SceneNode implements DiagnosticableTreeMixin {

 String get nodeId; String? get parentId;@Vector3Converter() Vector3 get position;@Vector3Converter() Vector3? get rotation;@Vector3Converter() Vector3? get scale;@NodeTypeConverter() NodeType get type;@NodeConfigConverter() NodeConfig get config; bool get isPlaced;
/// Create a copy of SceneNode
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SceneNodeCopyWith<SceneNode> get copyWith => _$SceneNodeCopyWithImpl<SceneNode>(this as SceneNode, _$identity);

  /// Serializes this SceneNode to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'SceneNode'))
    ..add(DiagnosticsProperty('nodeId', nodeId))..add(DiagnosticsProperty('parentId', parentId))..add(DiagnosticsProperty('position', position))..add(DiagnosticsProperty('rotation', rotation))..add(DiagnosticsProperty('scale', scale))..add(DiagnosticsProperty('type', type))..add(DiagnosticsProperty('config', config))..add(DiagnosticsProperty('isPlaced', isPlaced));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SceneNode&&(identical(other.nodeId, nodeId) || other.nodeId == nodeId)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&(identical(other.position, position) || other.position == position)&&(identical(other.rotation, rotation) || other.rotation == rotation)&&(identical(other.scale, scale) || other.scale == scale)&&(identical(other.type, type) || other.type == type)&&(identical(other.config, config) || other.config == config)&&(identical(other.isPlaced, isPlaced) || other.isPlaced == isPlaced));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,nodeId,parentId,position,rotation,scale,type,config,isPlaced);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'SceneNode(nodeId: $nodeId, parentId: $parentId, position: $position, rotation: $rotation, scale: $scale, type: $type, config: $config, isPlaced: $isPlaced)';
}


}

/// @nodoc
abstract mixin class $SceneNodeCopyWith<$Res>  {
  factory $SceneNodeCopyWith(SceneNode value, $Res Function(SceneNode) _then) = _$SceneNodeCopyWithImpl;
@useResult
$Res call({
 String nodeId, String? parentId,@Vector3Converter() Vector3 position,@Vector3Converter() Vector3? rotation,@Vector3Converter() Vector3? scale,@NodeTypeConverter() NodeType type,@NodeConfigConverter() NodeConfig config, bool isPlaced
});


$NodeConfigCopyWith<$Res> get config;

}
/// @nodoc
class _$SceneNodeCopyWithImpl<$Res>
    implements $SceneNodeCopyWith<$Res> {
  _$SceneNodeCopyWithImpl(this._self, this._then);

  final SceneNode _self;
  final $Res Function(SceneNode) _then;

/// Create a copy of SceneNode
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? nodeId = null,Object? parentId = freezed,Object? position = null,Object? rotation = freezed,Object? scale = freezed,Object? type = null,Object? config = null,Object? isPlaced = null,}) {
  return _then(_self.copyWith(
nodeId: null == nodeId ? _self.nodeId : nodeId // ignore: cast_nullable_to_non_nullable
as String,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as String?,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Vector3,rotation: freezed == rotation ? _self.rotation : rotation // ignore: cast_nullable_to_non_nullable
as Vector3?,scale: freezed == scale ? _self.scale : scale // ignore: cast_nullable_to_non_nullable
as Vector3?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as NodeType,config: null == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as NodeConfig,isPlaced: null == isPlaced ? _self.isPlaced : isPlaced // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of SceneNode
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NodeConfigCopyWith<$Res> get config {
  
  return $NodeConfigCopyWith<$Res>(_self.config, (value) {
    return _then(_self.copyWith(config: value));
  });
}
}


/// Adds pattern-matching-related methods to [SceneNode].
extension SceneNodePatterns on SceneNode {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SceneNode value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SceneNode() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SceneNode value)  $default,){
final _that = this;
switch (_that) {
case _SceneNode():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SceneNode value)?  $default,){
final _that = this;
switch (_that) {
case _SceneNode() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String nodeId,  String? parentId, @Vector3Converter()  Vector3 position, @Vector3Converter()  Vector3? rotation, @Vector3Converter()  Vector3? scale, @NodeTypeConverter()  NodeType type, @NodeConfigConverter()  NodeConfig config,  bool isPlaced)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SceneNode() when $default != null:
return $default(_that.nodeId,_that.parentId,_that.position,_that.rotation,_that.scale,_that.type,_that.config,_that.isPlaced);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String nodeId,  String? parentId, @Vector3Converter()  Vector3 position, @Vector3Converter()  Vector3? rotation, @Vector3Converter()  Vector3? scale, @NodeTypeConverter()  NodeType type, @NodeConfigConverter()  NodeConfig config,  bool isPlaced)  $default,) {final _that = this;
switch (_that) {
case _SceneNode():
return $default(_that.nodeId,_that.parentId,_that.position,_that.rotation,_that.scale,_that.type,_that.config,_that.isPlaced);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String nodeId,  String? parentId, @Vector3Converter()  Vector3 position, @Vector3Converter()  Vector3? rotation, @Vector3Converter()  Vector3? scale, @NodeTypeConverter()  NodeType type, @NodeConfigConverter()  NodeConfig config,  bool isPlaced)?  $default,) {final _that = this;
switch (_that) {
case _SceneNode() when $default != null:
return $default(_that.nodeId,_that.parentId,_that.position,_that.rotation,_that.scale,_that.type,_that.config,_that.isPlaced);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _SceneNode extends SceneNode with DiagnosticableTreeMixin {
  const _SceneNode({this.nodeId = "", this.parentId = null, @Vector3Converter() required this.position, @Vector3Converter() this.rotation, @Vector3Converter() this.scale, @NodeTypeConverter() required this.type, @NodeConfigConverter() required this.config, this.isPlaced = false}): super._();
  factory _SceneNode.fromJson(Map<String, dynamic> json) => _$SceneNodeFromJson(json);

@override@JsonKey() final  String nodeId;
@override@JsonKey() final  String? parentId;
@override@Vector3Converter() final  Vector3 position;
@override@Vector3Converter() final  Vector3? rotation;
@override@Vector3Converter() final  Vector3? scale;
@override@NodeTypeConverter() final  NodeType type;
@override@NodeConfigConverter() final  NodeConfig config;
@override@JsonKey() final  bool isPlaced;

/// Create a copy of SceneNode
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SceneNodeCopyWith<_SceneNode> get copyWith => __$SceneNodeCopyWithImpl<_SceneNode>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SceneNodeToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'SceneNode'))
    ..add(DiagnosticsProperty('nodeId', nodeId))..add(DiagnosticsProperty('parentId', parentId))..add(DiagnosticsProperty('position', position))..add(DiagnosticsProperty('rotation', rotation))..add(DiagnosticsProperty('scale', scale))..add(DiagnosticsProperty('type', type))..add(DiagnosticsProperty('config', config))..add(DiagnosticsProperty('isPlaced', isPlaced));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SceneNode&&(identical(other.nodeId, nodeId) || other.nodeId == nodeId)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&(identical(other.position, position) || other.position == position)&&(identical(other.rotation, rotation) || other.rotation == rotation)&&(identical(other.scale, scale) || other.scale == scale)&&(identical(other.type, type) || other.type == type)&&(identical(other.config, config) || other.config == config)&&(identical(other.isPlaced, isPlaced) || other.isPlaced == isPlaced));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,nodeId,parentId,position,rotation,scale,type,config,isPlaced);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'SceneNode(nodeId: $nodeId, parentId: $parentId, position: $position, rotation: $rotation, scale: $scale, type: $type, config: $config, isPlaced: $isPlaced)';
}


}

/// @nodoc
abstract mixin class _$SceneNodeCopyWith<$Res> implements $SceneNodeCopyWith<$Res> {
  factory _$SceneNodeCopyWith(_SceneNode value, $Res Function(_SceneNode) _then) = __$SceneNodeCopyWithImpl;
@override @useResult
$Res call({
 String nodeId, String? parentId,@Vector3Converter() Vector3 position,@Vector3Converter() Vector3? rotation,@Vector3Converter() Vector3? scale,@NodeTypeConverter() NodeType type,@NodeConfigConverter() NodeConfig config, bool isPlaced
});


@override $NodeConfigCopyWith<$Res> get config;

}
/// @nodoc
class __$SceneNodeCopyWithImpl<$Res>
    implements _$SceneNodeCopyWith<$Res> {
  __$SceneNodeCopyWithImpl(this._self, this._then);

  final _SceneNode _self;
  final $Res Function(_SceneNode) _then;

/// Create a copy of SceneNode
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? nodeId = null,Object? parentId = freezed,Object? position = null,Object? rotation = freezed,Object? scale = freezed,Object? type = null,Object? config = null,Object? isPlaced = null,}) {
  return _then(_SceneNode(
nodeId: null == nodeId ? _self.nodeId : nodeId // ignore: cast_nullable_to_non_nullable
as String,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as String?,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Vector3,rotation: freezed == rotation ? _self.rotation : rotation // ignore: cast_nullable_to_non_nullable
as Vector3?,scale: freezed == scale ? _self.scale : scale // ignore: cast_nullable_to_non_nullable
as Vector3?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as NodeType,config: null == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as NodeConfig,isPlaced: null == isPlaced ? _self.isPlaced : isPlaced // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of SceneNode
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NodeConfigCopyWith<$Res> get config {
  
  return $NodeConfigCopyWith<$Res>(_self.config, (value) {
    return _then(_self.copyWith(config: value));
  });
}
}

// dart format on
