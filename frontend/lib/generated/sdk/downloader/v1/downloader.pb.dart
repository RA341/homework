// This is a generated file - do not edit.
//
// Generated from downloader/v1/downloader.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'downloader.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'downloader.pbenum.dart';

class RetryRequest extends $pb.GeneratedMessage {
  factory RetryRequest({
    $fixnum.Int64? id,
  }) {
    final result = create();
    if (id != null) result.id = id;
    return result;
  }

  RetryRequest._();

  factory RetryRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RetryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RetryRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'downloader.v1'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RetryRequest clone() => RetryRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RetryRequest copyWith(void Function(RetryRequest) updates) =>
      super.copyWith((message) => updates(message as RetryRequest))
          as RetryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RetryRequest create() => RetryRequest._();
  @$core.override
  RetryRequest createEmptyInstance() => create();
  static $pb.PbList<RetryRequest> createRepeated() =>
      $pb.PbList<RetryRequest>();
  @$core.pragma('dart2js:noInline')
  static RetryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RetryRequest>(create);
  static RetryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

class RetryResponse extends $pb.GeneratedMessage {
  factory RetryResponse() => create();

  RetryResponse._();

  factory RetryResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RetryResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RetryResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'downloader.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RetryResponse clone() => RetryResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RetryResponse copyWith(void Function(RetryResponse) updates) =>
      super.copyWith((message) => updates(message as RetryResponse))
          as RetryResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RetryResponse create() => RetryResponse._();
  @$core.override
  RetryResponse createEmptyInstance() => create();
  static $pb.PbList<RetryResponse> createRepeated() =>
      $pb.PbList<RetryResponse>();
  @$core.pragma('dart2js:noInline')
  static RetryResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RetryResponse>(create);
  static RetryResponse? _defaultInstance;
}

class DownloadRequest extends $pb.GeneratedMessage {
  factory DownloadRequest({
    $core.String? name,
    $core.String? downloadLink,
    $core.String? filepath,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (downloadLink != null) result.downloadLink = downloadLink;
    if (filepath != null) result.filepath = filepath;
    return result;
  }

  DownloadRequest._();

  factory DownloadRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DownloadRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DownloadRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'downloader.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'downloadLink')
    ..aOS(3, _omitFieldNames ? '' : 'filepath')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DownloadRequest clone() => DownloadRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DownloadRequest copyWith(void Function(DownloadRequest) updates) =>
      super.copyWith((message) => updates(message as DownloadRequest))
          as DownloadRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DownloadRequest create() => DownloadRequest._();
  @$core.override
  DownloadRequest createEmptyInstance() => create();
  static $pb.PbList<DownloadRequest> createRepeated() =>
      $pb.PbList<DownloadRequest>();
  @$core.pragma('dart2js:noInline')
  static DownloadRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DownloadRequest>(create);
  static DownloadRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get downloadLink => $_getSZ(1);
  @$pb.TagNumber(2)
  set downloadLink($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDownloadLink() => $_has(1);
  @$pb.TagNumber(2)
  void clearDownloadLink() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get filepath => $_getSZ(2);
  @$pb.TagNumber(3)
  set filepath($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFilepath() => $_has(2);
  @$pb.TagNumber(3)
  void clearFilepath() => $_clearField(3);
}

class DownloadResponse extends $pb.GeneratedMessage {
  factory DownloadResponse() => create();

  DownloadResponse._();

  factory DownloadResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DownloadResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DownloadResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'downloader.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DownloadResponse clone() => DownloadResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DownloadResponse copyWith(void Function(DownloadResponse) updates) =>
      super.copyWith((message) => updates(message as DownloadResponse))
          as DownloadResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DownloadResponse create() => DownloadResponse._();
  @$core.override
  DownloadResponse createEmptyInstance() => create();
  static $pb.PbList<DownloadResponse> createRepeated() =>
      $pb.PbList<DownloadResponse>();
  @$core.pragma('dart2js:noInline')
  static DownloadResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DownloadResponse>(create);
  static DownloadResponse? _defaultInstance;
}

class ListRequest extends $pb.GeneratedMessage {
  factory ListRequest({
    $core.String? before,
    $core.String? query,
    $core.String? after,
    $fixnum.Int64? limit,
  }) {
    final result = create();
    if (before != null) result.before = before;
    if (query != null) result.query = query;
    if (after != null) result.after = after;
    if (limit != null) result.limit = limit;
    return result;
  }

  ListRequest._();

  factory ListRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'downloader.v1'),
      createEmptyInstance: create)
    ..aOS(2, _omitFieldNames ? '' : 'before')
    ..aOS(3, _omitFieldNames ? '' : 'query')
    ..aOS(4, _omitFieldNames ? '' : 'after')
    ..a<$fixnum.Int64>(5, _omitFieldNames ? '' : 'limit', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRequest clone() => ListRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRequest copyWith(void Function(ListRequest) updates) =>
      super.copyWith((message) => updates(message as ListRequest))
          as ListRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListRequest create() => ListRequest._();
  @$core.override
  ListRequest createEmptyInstance() => create();
  static $pb.PbList<ListRequest> createRepeated() => $pb.PbList<ListRequest>();
  @$core.pragma('dart2js:noInline')
  static ListRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListRequest>(create);
  static ListRequest? _defaultInstance;

  @$pb.TagNumber(2)
  $core.String get before => $_getSZ(0);
  @$pb.TagNumber(2)
  set before($core.String value) => $_setString(0, value);
  @$pb.TagNumber(2)
  $core.bool hasBefore() => $_has(0);
  @$pb.TagNumber(2)
  void clearBefore() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get query => $_getSZ(1);
  @$pb.TagNumber(3)
  set query($core.String value) => $_setString(1, value);
  @$pb.TagNumber(3)
  $core.bool hasQuery() => $_has(1);
  @$pb.TagNumber(3)
  void clearQuery() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get after => $_getSZ(2);
  @$pb.TagNumber(4)
  set after($core.String value) => $_setString(2, value);
  @$pb.TagNumber(4)
  $core.bool hasAfter() => $_has(2);
  @$pb.TagNumber(4)
  void clearAfter() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get limit => $_getI64(3);
  @$pb.TagNumber(5)
  set limit($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(5)
  $core.bool hasLimit() => $_has(3);
  @$pb.TagNumber(5)
  void clearLimit() => $_clearField(5);
}

class ListResponse extends $pb.GeneratedMessage {
  factory ListResponse({
    Result_Download? value1,
  }) {
    final result = create();
    if (value1 != null) result.value1 = value1;
    return result;
  }

  ListResponse._();

  factory ListResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'downloader.v1'),
      createEmptyInstance: create)
    ..aOM<Result_Download>(1, _omitFieldNames ? '' : 'value1',
        subBuilder: Result_Download.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListResponse clone() => ListResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListResponse copyWith(void Function(ListResponse) updates) =>
      super.copyWith((message) => updates(message as ListResponse))
          as ListResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListResponse create() => ListResponse._();
  @$core.override
  ListResponse createEmptyInstance() => create();
  static $pb.PbList<ListResponse> createRepeated() =>
      $pb.PbList<ListResponse>();
  @$core.pragma('dart2js:noInline')
  static ListResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListResponse>(create);
  static ListResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Result_Download get value1 => $_getN(0);
  @$pb.TagNumber(1)
  set value1(Result_Download value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasValue1() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue1() => $_clearField(1);
  @$pb.TagNumber(1)
  Result_Download ensureValue1() => $_ensure(0);
}

class Base_string extends $pb.GeneratedMessage {
  factory Base_string({
    $core.String? params,
    $core.int? after,
    $core.int? before,
    $core.int? limit,
  }) {
    final result = create();
    if (params != null) result.params = params;
    if (after != null) result.after = after;
    if (before != null) result.before = before;
    if (limit != null) result.limit = limit;
    return result;
  }

  Base_string._();

  factory Base_string.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Base_string.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Base_string',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'downloader.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'params')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'after', $pb.PbFieldType.OU3)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'before', $pb.PbFieldType.OU3)
    ..a<$core.int>(4, _omitFieldNames ? '' : 'limit', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Base_string clone() => Base_string()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Base_string copyWith(void Function(Base_string) updates) =>
      super.copyWith((message) => updates(message as Base_string))
          as Base_string;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Base_string create() => Base_string._();
  @$core.override
  Base_string createEmptyInstance() => create();
  static $pb.PbList<Base_string> createRepeated() => $pb.PbList<Base_string>();
  @$core.pragma('dart2js:noInline')
  static Base_string getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Base_string>(create);
  static Base_string? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get params => $_getSZ(0);
  @$pb.TagNumber(1)
  set params($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasParams() => $_has(0);
  @$pb.TagNumber(1)
  void clearParams() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get after => $_getIZ(1);
  @$pb.TagNumber(2)
  set after($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAfter() => $_has(1);
  @$pb.TagNumber(2)
  void clearAfter() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get before => $_getIZ(2);
  @$pb.TagNumber(3)
  set before($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBefore() => $_has(2);
  @$pb.TagNumber(3)
  void clearBefore() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get limit => $_getIZ(3);
  @$pb.TagNumber(4)
  set limit($core.int value) => $_setUnsignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLimit() => $_has(3);
  @$pb.TagNumber(4)
  void clearLimit() => $_clearField(4);
}

class Download extends $pb.GeneratedMessage {
  factory Download({
    $fixnum.Int64? id,
    $core.String? name,
    $core.String? downloadLink,
    DownloadState? status,
    $core.String? error,
    $core.String? downloadPath,
    $fixnum.Int64? createdAtSec,
    $fixnum.Int64? updatedAtSec,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    if (downloadLink != null) result.downloadLink = downloadLink;
    if (status != null) result.status = status;
    if (error != null) result.error = error;
    if (downloadPath != null) result.downloadPath = downloadPath;
    if (createdAtSec != null) result.createdAtSec = createdAtSec;
    if (updatedAtSec != null) result.updatedAtSec = updatedAtSec;
    return result;
  }

  Download._();

  factory Download.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Download.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Download',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'downloader.v1'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'downloadLink')
    ..e<DownloadState>(4, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OE,
        defaultOrMaker: DownloadState.DOWNLOAD_STATE_QUEUED,
        valueOf: DownloadState.valueOf,
        enumValues: DownloadState.values)
    ..aOS(5, _omitFieldNames ? '' : 'error')
    ..aOS(6, _omitFieldNames ? '' : 'downloadPath')
    ..a<$fixnum.Int64>(
        7, _omitFieldNames ? '' : 'createdAtSec', $pb.PbFieldType.OU6,
        protoName: 'createdAtSec', defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        8, _omitFieldNames ? '' : 'updatedAtSec', $pb.PbFieldType.OU6,
        protoName: 'updatedAtSec', defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Download clone() => Download()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Download copyWith(void Function(Download) updates) =>
      super.copyWith((message) => updates(message as Download)) as Download;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Download create() => Download._();
  @$core.override
  Download createEmptyInstance() => create();
  static $pb.PbList<Download> createRepeated() => $pb.PbList<Download>();
  @$core.pragma('dart2js:noInline')
  static Download getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Download>(create);
  static Download? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get downloadLink => $_getSZ(2);
  @$pb.TagNumber(3)
  set downloadLink($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDownloadLink() => $_has(2);
  @$pb.TagNumber(3)
  void clearDownloadLink() => $_clearField(3);

  @$pb.TagNumber(4)
  DownloadState get status => $_getN(3);
  @$pb.TagNumber(4)
  set status(DownloadState value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasStatus() => $_has(3);
  @$pb.TagNumber(4)
  void clearStatus() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get error => $_getSZ(4);
  @$pb.TagNumber(5)
  set error($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasError() => $_has(4);
  @$pb.TagNumber(5)
  void clearError() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get downloadPath => $_getSZ(5);
  @$pb.TagNumber(6)
  set downloadPath($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDownloadPath() => $_has(5);
  @$pb.TagNumber(6)
  void clearDownloadPath() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get createdAtSec => $_getI64(6);
  @$pb.TagNumber(7)
  set createdAtSec($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCreatedAtSec() => $_has(6);
  @$pb.TagNumber(7)
  void clearCreatedAtSec() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get updatedAtSec => $_getI64(7);
  @$pb.TagNumber(8)
  set updatedAtSec($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasUpdatedAtSec() => $_has(7);
  @$pb.TagNumber(8)
  void clearUpdatedAtSec() => $_clearField(8);
}

class Result_Download extends $pb.GeneratedMessage {
  factory Result_Download({
    $core.Iterable<Download>? results,
    $core.int? after,
    $core.int? before,
    $core.int? count,
  }) {
    final result = create();
    if (results != null) result.results.addAll(results);
    if (after != null) result.after = after;
    if (before != null) result.before = before;
    if (count != null) result.count = count;
    return result;
  }

  Result_Download._();

  factory Result_Download.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Result_Download.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Result_Download',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'downloader.v1'),
      createEmptyInstance: create)
    ..pc<Download>(1, _omitFieldNames ? '' : 'results', $pb.PbFieldType.PM,
        subBuilder: Download.create)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'after', $pb.PbFieldType.OU3)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'before', $pb.PbFieldType.OU3)
    ..a<$core.int>(4, _omitFieldNames ? '' : 'count', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Result_Download clone() => Result_Download()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Result_Download copyWith(void Function(Result_Download) updates) =>
      super.copyWith((message) => updates(message as Result_Download))
          as Result_Download;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Result_Download create() => Result_Download._();
  @$core.override
  Result_Download createEmptyInstance() => create();
  static $pb.PbList<Result_Download> createRepeated() =>
      $pb.PbList<Result_Download>();
  @$core.pragma('dart2js:noInline')
  static Result_Download getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Result_Download>(create);
  static Result_Download? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Download> get results => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get after => $_getIZ(1);
  @$pb.TagNumber(2)
  set after($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAfter() => $_has(1);
  @$pb.TagNumber(2)
  void clearAfter() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get before => $_getIZ(2);
  @$pb.TagNumber(3)
  set before($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBefore() => $_has(2);
  @$pb.TagNumber(3)
  void clearBefore() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get count => $_getIZ(3);
  @$pb.TagNumber(4)
  set count($core.int value) => $_setUnsignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCount() => $_has(3);
  @$pb.TagNumber(4)
  void clearCount() => $_clearField(4);
}

class DownloaderServiceApi {
  final $pb.RpcClient _client;

  DownloaderServiceApi(this._client);

  $async.Future<RetryResponse> retry(
          $pb.ClientContext? ctx, RetryRequest request) =>
      _client.invoke<RetryResponse>(
          ctx, 'DownloaderService', 'Retry', request, RetryResponse());
  $async.Future<DownloadResponse> download(
          $pb.ClientContext? ctx, DownloadRequest request) =>
      _client.invoke<DownloadResponse>(
          ctx, 'DownloaderService', 'Download', request, DownloadResponse());
  $async.Future<ListResponse> list(
          $pb.ClientContext? ctx, ListRequest request) =>
      _client.invoke<ListResponse>(
          ctx, 'DownloaderService', 'List', request, ListResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
