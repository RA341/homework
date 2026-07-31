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

@$core.Deprecated('Use downloadStateDescriptor instead')
const DownloadState$json = {
  '1': 'DownloadState',
  '2': [
    {'1': 'DOWNLOAD_STATE_QUEUED', '2': 0},
    {'1': 'DOWNLOAD_STATE_DOWNLOADING', '2': 1},
    {'1': 'DOWNLOAD_STATE_ERROR', '2': 2},
    {'1': 'DOWNLOAD_STATE_SUCCESS', '2': 3},
  ],
};

/// Descriptor for `DownloadState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List downloadStateDescriptor = $convert.base64Decode(
    'Cg1Eb3dubG9hZFN0YXRlEhkKFURPV05MT0FEX1NUQVRFX1FVRVVFRBAAEh4KGkRPV05MT0FEX1'
    'NUQVRFX0RPV05MT0FESU5HEAESGAoURE9XTkxPQURfU1RBVEVfRVJST1IQAhIaChZET1dOTE9B'
    'RF9TVEFURV9TVUNDRVNTEAM=');

@$core.Deprecated('Use retryRequestDescriptor instead')
const RetryRequest$json = {
  '1': 'RetryRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 4, '10': 'id'},
  ],
};

/// Descriptor for `RetryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List retryRequestDescriptor =
    $convert.base64Decode('CgxSZXRyeVJlcXVlc3QSDgoCaWQYASABKARSAmlk');

@$core.Deprecated('Use retryResponseDescriptor instead')
const RetryResponse$json = {
  '1': 'RetryResponse',
};

/// Descriptor for `RetryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List retryResponseDescriptor =
    $convert.base64Decode('Cg1SZXRyeVJlc3BvbnNl');

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

@$core.Deprecated('Use listRequestDescriptor instead')
const ListRequest$json = {
  '1': 'ListRequest',
  '2': [
    {'1': 'query', '3': 3, '4': 1, '5': 9, '10': 'query'},
    {'1': 'after', '3': 4, '4': 1, '5': 9, '10': 'after'},
    {'1': 'before', '3': 2, '4': 1, '5': 9, '10': 'before'},
    {'1': 'limit', '3': 5, '4': 1, '5': 4, '10': 'limit'},
  ],
};

/// Descriptor for `ListRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listRequestDescriptor = $convert.base64Decode(
    'CgtMaXN0UmVxdWVzdBIUCgVxdWVyeRgDIAEoCVIFcXVlcnkSFAoFYWZ0ZXIYBCABKAlSBWFmdG'
    'VyEhYKBmJlZm9yZRgCIAEoCVIGYmVmb3JlEhQKBWxpbWl0GAUgASgEUgVsaW1pdA==');

@$core.Deprecated('Use listResponseDescriptor instead')
const ListResponse$json = {
  '1': 'ListResponse',
  '2': [
    {
      '1': 'value1',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.downloader.v1.Result_Download',
      '10': 'value1'
    },
  ],
};

/// Descriptor for `ListResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listResponseDescriptor = $convert.base64Decode(
    'CgxMaXN0UmVzcG9uc2USNgoGdmFsdWUxGAEgASgLMh4uZG93bmxvYWRlci52MS5SZXN1bHRfRG'
    '93bmxvYWRSBnZhbHVlMQ==');

@$core.Deprecated('Use base_stringDescriptor instead')
const Base_string$json = {
  '1': 'Base_string',
  '2': [
    {'1': 'params', '3': 1, '4': 1, '5': 9, '10': 'params'},
    {'1': 'after', '3': 2, '4': 1, '5': 13, '10': 'after'},
    {'1': 'before', '3': 3, '4': 1, '5': 13, '10': 'before'},
    {'1': 'limit', '3': 4, '4': 1, '5': 13, '10': 'limit'},
  ],
};

/// Descriptor for `Base_string`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List base_stringDescriptor = $convert.base64Decode(
    'CgtCYXNlX3N0cmluZxIWCgZwYXJhbXMYASABKAlSBnBhcmFtcxIUCgVhZnRlchgCIAEoDVIFYW'
    'Z0ZXISFgoGYmVmb3JlGAMgASgNUgZiZWZvcmUSFAoFbGltaXQYBCABKA1SBWxpbWl0');

@$core.Deprecated('Use downloadDescriptor instead')
const Download$json = {
  '1': 'Download',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 4, '10': 'id'},
    {'1': 'createdAtSec', '3': 7, '4': 1, '5': 4, '10': 'createdAtSec'},
    {'1': 'updatedAtSec', '3': 8, '4': 1, '5': 4, '10': 'updatedAtSec'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'download_link', '3': 3, '4': 1, '5': 9, '10': 'downloadLink'},
    {
      '1': 'status',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.downloader.v1.DownloadState',
      '10': 'status'
    },
    {'1': 'error', '3': 5, '4': 1, '5': 9, '10': 'error'},
    {'1': 'download_path', '3': 6, '4': 1, '5': 9, '10': 'downloadPath'},
  ],
};

/// Descriptor for `Download`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List downloadDescriptor = $convert.base64Decode(
    'CghEb3dubG9hZBIOCgJpZBgBIAEoBFICaWQSIgoMY3JlYXRlZEF0U2VjGAcgASgEUgxjcmVhdG'
    'VkQXRTZWMSIgoMdXBkYXRlZEF0U2VjGAggASgEUgx1cGRhdGVkQXRTZWMSEgoEbmFtZRgCIAEo'
    'CVIEbmFtZRIjCg1kb3dubG9hZF9saW5rGAMgASgJUgxkb3dubG9hZExpbmsSNAoGc3RhdHVzGA'
    'QgASgOMhwuZG93bmxvYWRlci52MS5Eb3dubG9hZFN0YXRlUgZzdGF0dXMSFAoFZXJyb3IYBSAB'
    'KAlSBWVycm9yEiMKDWRvd25sb2FkX3BhdGgYBiABKAlSDGRvd25sb2FkUGF0aA==');

@$core.Deprecated('Use result_DownloadDescriptor instead')
const Result_Download$json = {
  '1': 'Result_Download',
  '2': [
    {
      '1': 'results',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.downloader.v1.Download',
      '10': 'results'
    },
    {'1': 'after', '3': 2, '4': 1, '5': 13, '10': 'after'},
    {'1': 'before', '3': 3, '4': 1, '5': 13, '10': 'before'},
    {'1': 'count', '3': 4, '4': 1, '5': 13, '10': 'count'},
  ],
};

/// Descriptor for `Result_Download`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List result_DownloadDescriptor = $convert.base64Decode(
    'Cg9SZXN1bHRfRG93bmxvYWQSMQoHcmVzdWx0cxgBIAMoCzIXLmRvd25sb2FkZXIudjEuRG93bm'
    'xvYWRSB3Jlc3VsdHMSFAoFYWZ0ZXIYAiABKA1SBWFmdGVyEhYKBmJlZm9yZRgDIAEoDVIGYmVm'
    'b3JlEhQKBWNvdW50GAQgASgNUgVjb3VudA==');

const $core.Map<$core.String, $core.dynamic> DownloaderServiceBase$json = {
  '1': 'DownloaderService',
  '2': [
    {
      '1': 'Retry',
      '2': '.downloader.v1.RetryRequest',
      '3': '.downloader.v1.RetryResponse',
      '4': {}
    },
    {
      '1': 'Download',
      '2': '.downloader.v1.DownloadRequest',
      '3': '.downloader.v1.DownloadResponse'
    },
    {
      '1': 'List',
      '2': '.downloader.v1.ListRequest',
      '3': '.downloader.v1.ListResponse'
    },
  ],
};

@$core.Deprecated('Use downloaderServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    DownloaderServiceBase$messageJson = {
  '.downloader.v1.RetryRequest': RetryRequest$json,
  '.downloader.v1.RetryResponse': RetryResponse$json,
  '.downloader.v1.DownloadRequest': DownloadRequest$json,
  '.downloader.v1.DownloadResponse': DownloadResponse$json,
  '.downloader.v1.ListRequest': ListRequest$json,
  '.downloader.v1.ListResponse': ListResponse$json,
  '.downloader.v1.Result_Download': Result_Download$json,
  '.downloader.v1.Download': Download$json,
};

/// Descriptor for `DownloaderService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List downloaderServiceDescriptor = $convert.base64Decode(
    'ChFEb3dubG9hZGVyU2VydmljZRJECgVSZXRyeRIbLmRvd25sb2FkZXIudjEuUmV0cnlSZXF1ZX'
    'N0GhwuZG93bmxvYWRlci52MS5SZXRyeVJlc3BvbnNlIgASSwoIRG93bmxvYWQSHi5kb3dubG9h'
    'ZGVyLnYxLkRvd25sb2FkUmVxdWVzdBofLmRvd25sb2FkZXIudjEuRG93bmxvYWRSZXNwb25zZR'
    'I/CgRMaXN0EhouZG93bmxvYWRlci52MS5MaXN0UmVxdWVzdBobLmRvd25sb2FkZXIudjEuTGlz'
    'dFJlc3BvbnNl');
