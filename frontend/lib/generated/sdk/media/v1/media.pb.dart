// This is a generated file - do not edit.
//
// Generated from media/v1/media.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'media.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'media.pbenum.dart';

class AddAndDownloadRequest extends $pb.GeneratedMessage {
  factory AddAndDownloadRequest({
    CreateMedia? media,
    $core.String? downloadLink,
  }) {
    final result = create();
    if (media != null) result.media = media;
    if (downloadLink != null) result.downloadLink = downloadLink;
    return result;
  }

  AddAndDownloadRequest._();

  factory AddAndDownloadRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddAndDownloadRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddAndDownloadRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'media.v1'),
      createEmptyInstance: create)
    ..aOM<CreateMedia>(1, _omitFieldNames ? '' : 'media',
        subBuilder: CreateMedia.create)
    ..aOS(2, _omitFieldNames ? '' : 'downloadLink', protoName: 'downloadLink')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddAndDownloadRequest clone() =>
      AddAndDownloadRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddAndDownloadRequest copyWith(
          void Function(AddAndDownloadRequest) updates) =>
      super.copyWith((message) => updates(message as AddAndDownloadRequest))
          as AddAndDownloadRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddAndDownloadRequest create() => AddAndDownloadRequest._();
  @$core.override
  AddAndDownloadRequest createEmptyInstance() => create();
  static $pb.PbList<AddAndDownloadRequest> createRepeated() =>
      $pb.PbList<AddAndDownloadRequest>();
  @$core.pragma('dart2js:noInline')
  static AddAndDownloadRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddAndDownloadRequest>(create);
  static AddAndDownloadRequest? _defaultInstance;

  @$pb.TagNumber(1)
  CreateMedia get media => $_getN(0);
  @$pb.TagNumber(1)
  set media(CreateMedia value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMedia() => $_has(0);
  @$pb.TagNumber(1)
  void clearMedia() => $_clearField(1);
  @$pb.TagNumber(1)
  CreateMedia ensureMedia() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get downloadLink => $_getSZ(1);
  @$pb.TagNumber(2)
  set downloadLink($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDownloadLink() => $_has(1);
  @$pb.TagNumber(2)
  void clearDownloadLink() => $_clearField(2);
}

class AddAndDownloadResponse extends $pb.GeneratedMessage {
  factory AddAndDownloadResponse() => create();

  AddAndDownloadResponse._();

  factory AddAndDownloadResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddAndDownloadResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddAndDownloadResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'media.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddAndDownloadResponse clone() =>
      AddAndDownloadResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddAndDownloadResponse copyWith(
          void Function(AddAndDownloadResponse) updates) =>
      super.copyWith((message) => updates(message as AddAndDownloadResponse))
          as AddAndDownloadResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddAndDownloadResponse create() => AddAndDownloadResponse._();
  @$core.override
  AddAndDownloadResponse createEmptyInstance() => create();
  static $pb.PbList<AddAndDownloadResponse> createRepeated() =>
      $pb.PbList<AddAndDownloadResponse>();
  @$core.pragma('dart2js:noInline')
  static AddAndDownloadResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddAndDownloadResponse>(create);
  static AddAndDownloadResponse? _defaultInstance;
}

class CreateContent extends $pb.GeneratedMessage {
  factory CreateContent({
    $core.String? title,
    $core.String? desc,
    ContentType? contentType,
  }) {
    final result = create();
    if (title != null) result.title = title;
    if (desc != null) result.desc = desc;
    if (contentType != null) result.contentType = contentType;
    return result;
  }

  CreateContent._();

  factory CreateContent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateContent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateContent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'media.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'desc')
    ..e<ContentType>(
        3, _omitFieldNames ? '' : 'contentType', $pb.PbFieldType.OE,
        defaultOrMaker: ContentType.CONTENT_TYPE_UNKNOWN,
        valueOf: ContentType.valueOf,
        enumValues: ContentType.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateContent clone() => CreateContent()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateContent copyWith(void Function(CreateContent) updates) =>
      super.copyWith((message) => updates(message as CreateContent))
          as CreateContent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateContent create() => CreateContent._();
  @$core.override
  CreateContent createEmptyInstance() => create();
  static $pb.PbList<CreateContent> createRepeated() =>
      $pb.PbList<CreateContent>();
  @$core.pragma('dart2js:noInline')
  static CreateContent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateContent>(create);
  static CreateContent? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get desc => $_getSZ(1);
  @$pb.TagNumber(2)
  set desc($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDesc() => $_has(1);
  @$pb.TagNumber(2)
  void clearDesc() => $_clearField(2);

  @$pb.TagNumber(3)
  ContentType get contentType => $_getN(2);
  @$pb.TagNumber(3)
  set contentType(ContentType value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasContentType() => $_has(2);
  @$pb.TagNumber(3)
  void clearContentType() => $_clearField(3);
}

class CreateMedia extends $pb.GeneratedMessage {
  factory CreateMedia({
    CreateContent? content,
    CreateAsset? asset,
  }) {
    final result = create();
    if (content != null) result.content = content;
    if (asset != null) result.asset = asset;
    return result;
  }

  CreateMedia._();

  factory CreateMedia.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateMedia.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateMedia',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'media.v1'),
      createEmptyInstance: create)
    ..aOM<CreateContent>(1, _omitFieldNames ? '' : 'content',
        subBuilder: CreateContent.create)
    ..aOM<CreateAsset>(2, _omitFieldNames ? '' : 'asset',
        subBuilder: CreateAsset.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateMedia clone() => CreateMedia()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateMedia copyWith(void Function(CreateMedia) updates) =>
      super.copyWith((message) => updates(message as CreateMedia))
          as CreateMedia;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateMedia create() => CreateMedia._();
  @$core.override
  CreateMedia createEmptyInstance() => create();
  static $pb.PbList<CreateMedia> createRepeated() => $pb.PbList<CreateMedia>();
  @$core.pragma('dart2js:noInline')
  static CreateMedia getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateMedia>(create);
  static CreateMedia? _defaultInstance;

  @$pb.TagNumber(1)
  CreateContent get content => $_getN(0);
  @$pb.TagNumber(1)
  set content(CreateContent value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContent() => $_has(0);
  @$pb.TagNumber(1)
  void clearContent() => $_clearField(1);
  @$pb.TagNumber(1)
  CreateContent ensureContent() => $_ensure(0);

  @$pb.TagNumber(2)
  CreateAsset get asset => $_getN(1);
  @$pb.TagNumber(2)
  set asset(CreateAsset value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasAsset() => $_has(1);
  @$pb.TagNumber(2)
  void clearAsset() => $_clearField(2);
  @$pb.TagNumber(2)
  CreateAsset ensureAsset() => $_ensure(1);
}

class CreateAsset extends $pb.GeneratedMessage {
  factory CreateAsset({
    AssetType? assetType,
    AssetRole? assetRole,
    $core.String? filepath,
  }) {
    final result = create();
    if (assetType != null) result.assetType = assetType;
    if (assetRole != null) result.assetRole = assetRole;
    if (filepath != null) result.filepath = filepath;
    return result;
  }

  CreateAsset._();

  factory CreateAsset.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateAsset.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateAsset',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'media.v1'),
      createEmptyInstance: create)
    ..e<AssetType>(1, _omitFieldNames ? '' : 'assetType', $pb.PbFieldType.OE,
        defaultOrMaker: AssetType.ASSET_TYPE_UNKNOWN,
        valueOf: AssetType.valueOf,
        enumValues: AssetType.values)
    ..e<AssetRole>(2, _omitFieldNames ? '' : 'assetRole', $pb.PbFieldType.OE,
        defaultOrMaker: AssetRole.ASSET_ROLE_MAIN,
        valueOf: AssetRole.valueOf,
        enumValues: AssetRole.values)
    ..aOS(3, _omitFieldNames ? '' : 'filepath')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateAsset clone() => CreateAsset()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateAsset copyWith(void Function(CreateAsset) updates) =>
      super.copyWith((message) => updates(message as CreateAsset))
          as CreateAsset;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateAsset create() => CreateAsset._();
  @$core.override
  CreateAsset createEmptyInstance() => create();
  static $pb.PbList<CreateAsset> createRepeated() => $pb.PbList<CreateAsset>();
  @$core.pragma('dart2js:noInline')
  static CreateAsset getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateAsset>(create);
  static CreateAsset? _defaultInstance;

  @$pb.TagNumber(1)
  AssetType get assetType => $_getN(0);
  @$pb.TagNumber(1)
  set assetType(AssetType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAssetType() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetType() => $_clearField(1);

  @$pb.TagNumber(2)
  AssetRole get assetRole => $_getN(1);
  @$pb.TagNumber(2)
  set assetRole(AssetRole value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasAssetRole() => $_has(1);
  @$pb.TagNumber(2)
  void clearAssetRole() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get filepath => $_getSZ(2);
  @$pb.TagNumber(3)
  set filepath($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFilepath() => $_has(2);
  @$pb.TagNumber(3)
  void clearFilepath() => $_clearField(3);
}

class MediaServiceApi {
  final $pb.RpcClient _client;

  MediaServiceApi(this._client);

  $async.Future<AddAndDownloadResponse> addAndDownload(
          $pb.ClientContext? ctx, AddAndDownloadRequest request) =>
      _client.invoke<AddAndDownloadResponse>(ctx, 'MediaService',
          'AddAndDownload', request, AddAndDownloadResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
