// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'job.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UploadJob {

 String get id; UploadDto get dto; double get progress; String get status; String? get error; DateTime get createdAt;
/// Create a copy of UploadJob
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UploadJobCopyWith<UploadJob> get copyWith => _$UploadJobCopyWithImpl<UploadJob>(this as UploadJob, _$identity);

  /// Serializes this UploadJob to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UploadJob&&(identical(other.id, id) || other.id == id)&&(identical(other.dto, dto) || other.dto == dto)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.status, status) || other.status == status)&&(identical(other.error, error) || other.error == error)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,dto,progress,status,error,createdAt);

@override
String toString() {
  return 'UploadJob(id: $id, dto: $dto, progress: $progress, status: $status, error: $error, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $UploadJobCopyWith<$Res>  {
  factory $UploadJobCopyWith(UploadJob value, $Res Function(UploadJob) _then) = _$UploadJobCopyWithImpl;
@useResult
$Res call({
 String id, UploadDto dto, double progress, String status, String? error, DateTime createdAt
});


$UploadDtoCopyWith<$Res> get dto;

}
/// @nodoc
class _$UploadJobCopyWithImpl<$Res>
    implements $UploadJobCopyWith<$Res> {
  _$UploadJobCopyWithImpl(this._self, this._then);

  final UploadJob _self;
  final $Res Function(UploadJob) _then;

/// Create a copy of UploadJob
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? dto = null,Object? progress = null,Object? status = null,Object? error = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,dto: null == dto ? _self.dto : dto // ignore: cast_nullable_to_non_nullable
as UploadDto,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of UploadJob
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UploadDtoCopyWith<$Res> get dto {
  
  return $UploadDtoCopyWith<$Res>(_self.dto, (value) {
    return _then(_self.copyWith(dto: value));
  });
}
}


/// Adds pattern-matching-related methods to [UploadJob].
extension UploadJobPatterns on UploadJob {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UploadJob value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UploadJob() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UploadJob value)  $default,){
final _that = this;
switch (_that) {
case _UploadJob():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UploadJob value)?  $default,){
final _that = this;
switch (_that) {
case _UploadJob() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  UploadDto dto,  double progress,  String status,  String? error,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UploadJob() when $default != null:
return $default(_that.id,_that.dto,_that.progress,_that.status,_that.error,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  UploadDto dto,  double progress,  String status,  String? error,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _UploadJob():
return $default(_that.id,_that.dto,_that.progress,_that.status,_that.error,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  UploadDto dto,  double progress,  String status,  String? error,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _UploadJob() when $default != null:
return $default(_that.id,_that.dto,_that.progress,_that.status,_that.error,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UploadJob implements UploadJob {
  const _UploadJob({required this.id, required this.dto, this.progress = 0.0, this.status = 'pending', this.error, required this.createdAt});
  factory _UploadJob.fromJson(Map<String, dynamic> json) => _$UploadJobFromJson(json);

@override final  String id;
@override final  UploadDto dto;
@override@JsonKey() final  double progress;
@override@JsonKey() final  String status;
@override final  String? error;
@override final  DateTime createdAt;

/// Create a copy of UploadJob
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UploadJobCopyWith<_UploadJob> get copyWith => __$UploadJobCopyWithImpl<_UploadJob>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UploadJobToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UploadJob&&(identical(other.id, id) || other.id == id)&&(identical(other.dto, dto) || other.dto == dto)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.status, status) || other.status == status)&&(identical(other.error, error) || other.error == error)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,dto,progress,status,error,createdAt);

@override
String toString() {
  return 'UploadJob(id: $id, dto: $dto, progress: $progress, status: $status, error: $error, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$UploadJobCopyWith<$Res> implements $UploadJobCopyWith<$Res> {
  factory _$UploadJobCopyWith(_UploadJob value, $Res Function(_UploadJob) _then) = __$UploadJobCopyWithImpl;
@override @useResult
$Res call({
 String id, UploadDto dto, double progress, String status, String? error, DateTime createdAt
});


@override $UploadDtoCopyWith<$Res> get dto;

}
/// @nodoc
class __$UploadJobCopyWithImpl<$Res>
    implements _$UploadJobCopyWith<$Res> {
  __$UploadJobCopyWithImpl(this._self, this._then);

  final _UploadJob _self;
  final $Res Function(_UploadJob) _then;

/// Create a copy of UploadJob
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? dto = null,Object? progress = null,Object? status = null,Object? error = freezed,Object? createdAt = null,}) {
  return _then(_UploadJob(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,dto: null == dto ? _self.dto : dto // ignore: cast_nullable_to_non_nullable
as UploadDto,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of UploadJob
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UploadDtoCopyWith<$Res> get dto {
  
  return $UploadDtoCopyWith<$Res>(_self.dto, (value) {
    return _then(_self.copyWith(dto: value));
  });
}
}

// dart format on
