// This is a generated file - do not edit.
//
// Generated from downloader/v1/downloader.proto.

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
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'download_link', '3': 2, '4': 1, '5': 9, '10': 'downloadLink'},
    {'1': 'filepath', '3': 3, '4': 1, '5': 9, '10': 'filepath'},
  ],
};

/// Descriptor for `DownloadRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List downloadRequestDescriptor = $convert.base64Decode(
    'Cg9Eb3dubG9hZFJlcXVlc3QSEgoEbmFtZRgBIAEoCVIEbmFtZRIjCg1kb3dubG9hZF9saW5rGA'
    'IgASgJUgxkb3dubG9hZExpbmsSGgoIZmlsZXBhdGgYAyABKAlSCGZpbGVwYXRo');

@$core.Deprecated('Use downloadResponseDescriptor instead')
const DownloadResponse$json = {
  '1': 'DownloadResponse',
};

/// Descriptor for `DownloadResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List downloadResponseDescriptor =
    $convert.base64Decode('ChBEb3dubG9hZFJlc3BvbnNl');

const $core.Map<$core.String, $core.dynamic> DownloaderServiceBase$json = {
  '1': 'DownloaderService',
  '2': [
    {
      '1': 'Download',
      '2': '.downloader.v1.DownloadRequest',
      '3': '.downloader.v1.DownloadResponse'
    },
  ],
};

@$core.Deprecated('Use downloaderServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    DownloaderServiceBase$messageJson = {
  '.downloader.v1.DownloadRequest': DownloadRequest$json,
  '.downloader.v1.DownloadResponse': DownloadResponse$json,
};

/// Descriptor for `DownloaderService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List downloaderServiceDescriptor = $convert.base64Decode(
    'ChFEb3dubG9hZGVyU2VydmljZRJLCghEb3dubG9hZBIeLmRvd25sb2FkZXIudjEuRG93bmxvYW'
    'RSZXF1ZXN0Gh8uZG93bmxvYWRlci52MS5Eb3dubG9hZFJlc3BvbnNl');
