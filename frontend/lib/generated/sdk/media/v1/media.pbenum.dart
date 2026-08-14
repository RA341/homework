// This is a generated file - do not edit.
//
// Generated from media/v1/media.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class ContentType extends $pb.ProtobufEnum {
  static const ContentType CONTENT_TYPE_UNKNOWN =
      ContentType._(0, _omitEnumNames ? '' : 'CONTENT_TYPE_UNKNOWN');
  static const ContentType CONTENT_TYPE_MOVIE =
      ContentType._(1, _omitEnumNames ? '' : 'CONTENT_TYPE_MOVIE');
  static const ContentType CONTENT_TYPE_SERIES =
      ContentType._(2, _omitEnumNames ? '' : 'CONTENT_TYPE_SERIES');
  static const ContentType CONTENT_TYPE_EPISODE =
      ContentType._(3, _omitEnumNames ? '' : 'CONTENT_TYPE_EPISODE');
  static const ContentType CONTENT_TYPE_VIDEO =
      ContentType._(4, _omitEnumNames ? '' : 'CONTENT_TYPE_VIDEO');
  static const ContentType CONTENT_TYPE_IMAGE =
      ContentType._(5, _omitEnumNames ? '' : 'CONTENT_TYPE_IMAGE');
  static const ContentType CONTENT_TYPE_GALLERY =
      ContentType._(6, _omitEnumNames ? '' : 'CONTENT_TYPE_GALLERY');
  static const ContentType CONTENT_TYPE_SEASON =
      ContentType._(7, _omitEnumNames ? '' : 'CONTENT_TYPE_SEASON');

  static const $core.List<ContentType> values = <ContentType>[
    CONTENT_TYPE_UNKNOWN,
    CONTENT_TYPE_MOVIE,
    CONTENT_TYPE_SERIES,
    CONTENT_TYPE_EPISODE,
    CONTENT_TYPE_VIDEO,
    CONTENT_TYPE_IMAGE,
    CONTENT_TYPE_GALLERY,
    CONTENT_TYPE_SEASON,
  ];

  static final $core.List<ContentType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 7);
  static ContentType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ContentType._(super.value, super.name);
}

class AssetType extends $pb.ProtobufEnum {
  static const AssetType ASSET_TYPE_UNKNOWN =
      AssetType._(0, _omitEnumNames ? '' : 'ASSET_TYPE_UNKNOWN');
  static const AssetType ASSET_TYPE_VIDEO =
      AssetType._(1, _omitEnumNames ? '' : 'ASSET_TYPE_VIDEO');
  static const AssetType ASSET_TYPE_IMAGE =
      AssetType._(2, _omitEnumNames ? '' : 'ASSET_TYPE_IMAGE');
  static const AssetType ASSET_TYPE_SUBTITLE =
      AssetType._(3, _omitEnumNames ? '' : 'ASSET_TYPE_SUBTITLE');
  static const AssetType ASSET_TYPE_AUDIO =
      AssetType._(4, _omitEnumNames ? '' : 'ASSET_TYPE_AUDIO');

  static const $core.List<AssetType> values = <AssetType>[
    ASSET_TYPE_UNKNOWN,
    ASSET_TYPE_VIDEO,
    ASSET_TYPE_IMAGE,
    ASSET_TYPE_SUBTITLE,
    ASSET_TYPE_AUDIO,
  ];

  static final $core.List<AssetType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static AssetType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const AssetType._(super.value, super.name);
}

class AssetRole extends $pb.ProtobufEnum {
  static const AssetRole ASSET_ROLE_MAIN =
      AssetRole._(0, _omitEnumNames ? '' : 'ASSET_ROLE_MAIN');
  static const AssetRole ASSET_ROLE_THUMBNAIL =
      AssetRole._(1, _omitEnumNames ? '' : 'ASSET_ROLE_THUMBNAIL');
  static const AssetRole ASSET_ROLE_BACKDROP =
      AssetRole._(2, _omitEnumNames ? '' : 'ASSET_ROLE_BACKDROP');
  static const AssetRole ASSET_ROLE_TRAILER =
      AssetRole._(3, _omitEnumNames ? '' : 'ASSET_ROLE_TRAILER');
  static const AssetRole ASSET_ROLE_POSTER =
      AssetRole._(4, _omitEnumNames ? '' : 'ASSET_ROLE_POSTER');

  static const $core.List<AssetRole> values = <AssetRole>[
    ASSET_ROLE_MAIN,
    ASSET_ROLE_THUMBNAIL,
    ASSET_ROLE_BACKDROP,
    ASSET_ROLE_TRAILER,
    ASSET_ROLE_POSTER,
  ];

  static final $core.List<AssetRole?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static AssetRole? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const AssetRole._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
