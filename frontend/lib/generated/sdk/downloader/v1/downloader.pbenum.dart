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
  static const DownloadState Queued =
      DownloadState._(0, _omitEnumNames ? '' : 'Queued');
  static const DownloadState Downloading =
      DownloadState._(1, _omitEnumNames ? '' : 'Downloading');
  static const DownloadState Error =
      DownloadState._(2, _omitEnumNames ? '' : 'Error');
  static const DownloadState Complete =
      DownloadState._(3, _omitEnumNames ? '' : 'Complete');
  static const DownloadState Failed =
      DownloadState._(4, _omitEnumNames ? '' : 'Failed');
  static const DownloadState Canceled =
      DownloadState._(5, _omitEnumNames ? '' : 'Canceled');

  static const $core.List<DownloadState> values = <DownloadState>[
    Queued,
    Downloading,
    Error,
    Complete,
    Failed,
    Canceled,
  ];

  static final $core.List<DownloadState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static DownloadState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const DownloadState._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
