// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'upload.provider.dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UploadDto {

 String get title; String get desc; String get fileName; String get assetType; String get assetRole; String get contentType; String get filePath;
/// Create a copy of UploadDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UploadDtoCopyWith<UploadDto> get copyWith => _$UploadDtoCopyWithImpl<UploadDto>(this as UploadDto, _$identity);

  /// Serializes this UploadDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UploadDto&&(identical(other.title, title) || other.title == title)&&(identical(other.desc, desc) || other.desc == desc)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.assetType, assetType) || other.assetType == assetType)&&(identical(other.assetRole, assetRole) || other.assetRole == assetRole)&&(identical(other.contentType, contentType) || other.contentType == contentType)&&(identical(other.filePath, filePath) || other.filePath == filePath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,desc,fileName,assetType,assetRole,contentType,filePath);

@override
String toString() {
  return 'UploadDto(title: $title, desc: $desc, fileName: $fileName, assetType: $assetType, assetRole: $assetRole, contentType: $contentType, filePath: $filePath)';
}


}

/// @nodoc
abstract mixin class $UploadDtoCopyWith<$Res>  {
  factory $UploadDtoCopyWith(UploadDto value, $Res Function(UploadDto) _then) = _$UploadDtoCopyWithImpl;
@useResult
$Res call({
 String title, String desc, String fileName, String assetType, String assetRole, String contentType, String filePath
});




}
/// @nodoc
class _$UploadDtoCopyWithImpl<$Res>
    implements $UploadDtoCopyWith<$Res> {
  _$UploadDtoCopyWithImpl(this._self, this._then);

  final UploadDto _self;
  final $Res Function(UploadDto) _then;

/// Create a copy of UploadDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? desc = null,Object? fileName = null,Object? assetType = null,Object? assetRole = null,Object? contentType = null,Object? filePath = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,desc: null == desc ? _self.desc : desc // ignore: cast_nullable_to_non_nullable
as String,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,assetType: null == assetType ? _self.assetType : assetType // ignore: cast_nullable_to_non_nullable
as String,assetRole: null == assetRole ? _self.assetRole : assetRole // ignore: cast_nullable_to_non_nullable
as String,contentType: null == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as String,filePath: null == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [UploadDto].
extension UploadDtoPatterns on UploadDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UploadDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UploadDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UploadDto value)  $default,){
final _that = this;
switch (_that) {
case _UploadDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UploadDto value)?  $default,){
final _that = this;
switch (_that) {
case _UploadDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String desc,  String fileName,  String assetType,  String assetRole,  String contentType,  String filePath)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UploadDto() when $default != null:
return $default(_that.title,_that.desc,_that.fileName,_that.assetType,_that.assetRole,_that.contentType,_that.filePath);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String desc,  String fileName,  String assetType,  String assetRole,  String contentType,  String filePath)  $default,) {final _that = this;
switch (_that) {
case _UploadDto():
return $default(_that.title,_that.desc,_that.fileName,_that.assetType,_that.assetRole,_that.contentType,_that.filePath);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String desc,  String fileName,  String assetType,  String assetRole,  String contentType,  String filePath)?  $default,) {final _that = this;
switch (_that) {
case _UploadDto() when $default != null:
return $default(_that.title,_that.desc,_that.fileName,_that.assetType,_that.assetRole,_that.contentType,_that.filePath);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UploadDto implements UploadDto {
  const _UploadDto({required this.title, required this.desc, required this.fileName, required this.assetType, required this.assetRole, required this.contentType, required this.filePath});
  factory _UploadDto.fromJson(Map<String, dynamic> json) => _$UploadDtoFromJson(json);

@override final  String title;
@override final  String desc;
@override final  String fileName;
@override final  String assetType;
@override final  String assetRole;
@override final  String contentType;
@override final  String filePath;

/// Create a copy of UploadDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UploadDtoCopyWith<_UploadDto> get copyWith => __$UploadDtoCopyWithImpl<_UploadDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UploadDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UploadDto&&(identical(other.title, title) || other.title == title)&&(identical(other.desc, desc) || other.desc == desc)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.assetType, assetType) || other.assetType == assetType)&&(identical(other.assetRole, assetRole) || other.assetRole == assetRole)&&(identical(other.contentType, contentType) || other.contentType == contentType)&&(identical(other.filePath, filePath) || other.filePath == filePath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,desc,fileName,assetType,assetRole,contentType,filePath);

@override
String toString() {
  return 'UploadDto(title: $title, desc: $desc, fileName: $fileName, assetType: $assetType, assetRole: $assetRole, contentType: $contentType, filePath: $filePath)';
}


}

/// @nodoc
abstract mixin class _$UploadDtoCopyWith<$Res> implements $UploadDtoCopyWith<$Res> {
  factory _$UploadDtoCopyWith(_UploadDto value, $Res Function(_UploadDto) _then) = __$UploadDtoCopyWithImpl;
@override @useResult
$Res call({
 String title, String desc, String fileName, String assetType, String assetRole, String contentType, String filePath
});




}
/// @nodoc
class __$UploadDtoCopyWithImpl<$Res>
    implements _$UploadDtoCopyWith<$Res> {
  __$UploadDtoCopyWithImpl(this._self, this._then);

  final _UploadDto _self;
  final $Res Function(_UploadDto) _then;

/// Create a copy of UploadDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? desc = null,Object? fileName = null,Object? assetType = null,Object? assetRole = null,Object? contentType = null,Object? filePath = null,}) {
  return _then(_UploadDto(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,desc: null == desc ? _self.desc : desc // ignore: cast_nullable_to_non_nullable
as String,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,assetType: null == assetType ? _self.assetType : assetType // ignore: cast_nullable_to_non_nullable
as String,assetRole: null == assetRole ? _self.assetRole : assetRole // ignore: cast_nullable_to_non_nullable
as String,contentType: null == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as String,filePath: null == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
