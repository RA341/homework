// This is a generated file - do not edit.
//
// Generated from download/v1/download.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use downloadRequestDescriptor instead')
const DownloadRequest$json = {
  '1': 'DownloadRequest',
  '2': [
    {'1': 'url', '3': 1, '4': 1, '5': 9, '10': 'url'},
    {'1': 'path', '3': 2, '4': 1, '5': 9, '10': 'path'},
  ],
};

/// Descriptor for `DownloadRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List downloadRequestDescriptor = $convert.base64Decode(
    'Cg9Eb3dubG9hZFJlcXVlc3QSEAoDdXJsGAEgASgJUgN1cmwSEgoEcGF0aBgCIAEoCVIEcGF0aA'
    '==');

@$core.Deprecated('Use downloadResponseDescriptor instead')
const DownloadResponse$json = {
  '1': 'DownloadResponse',
};

/// Descriptor for `DownloadResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List downloadResponseDescriptor =
    $convert.base64Decode('ChBEb3dubG9hZFJlc3BvbnNl');

const $core.Map<$core.String, $core.dynamic> DownloadServiceBase$json = {
  '1': 'DownloadService',
  '2': [
    {
      '1': 'Download',
      '2': '.download.v1.DownloadRequest',
      '3': '.download.v1.DownloadResponse',
      '4': {}
    },
  ],
};

@$core.Deprecated('Use downloadServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    DownloadServiceBase$messageJson = {
  '.download.v1.DownloadRequest': DownloadRequest$json,
  '.download.v1.DownloadResponse': DownloadResponse$json,
};

/// Descriptor for `DownloadService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List downloadServiceDescriptor = $convert.base64Decode(
    'Cg9Eb3dubG9hZFNlcnZpY2USSQoIRG93bmxvYWQSHC5kb3dubG9hZC52MS5Eb3dubG9hZFJlcX'
    'Vlc3QaHS5kb3dubG9hZC52MS5Eb3dubG9hZFJlc3BvbnNlIgA=');
