// This is a generated file - do not edit.
//
// Generated from downloader/v1/downloader.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class DownloadState extends $pb.ProtobufEnum {
  static const DownloadState DOWNLOAD_STATE_QUEUED =
      DownloadState._(0, _omitEnumNames ? '' : 'DOWNLOAD_STATE_QUEUED');
  static const DownloadState DOWNLOAD_STATE_DOWNLOADING =
      DownloadState._(1, _omitEnumNames ? '' : 'DOWNLOAD_STATE_DOWNLOADING');
  static const DownloadState DOWNLOAD_STATE_ERROR =
      DownloadState._(2, _omitEnumNames ? '' : 'DOWNLOAD_STATE_ERROR');
  static const DownloadState DOWNLOAD_STATE_SUCCESS =
      DownloadState._(3, _omitEnumNames ? '' : 'DOWNLOAD_STATE_SUCCESS');

  static const $core.List<DownloadState> values = <DownloadState>[
    DOWNLOAD_STATE_QUEUED,
    DOWNLOAD_STATE_DOWNLOADING,
    DOWNLOAD_STATE_ERROR,
    DOWNLOAD_STATE_SUCCESS,
  ];

  static final $core.List<DownloadState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static DownloadState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const DownloadState._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
