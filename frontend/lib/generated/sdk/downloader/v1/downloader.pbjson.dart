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

@$core.Deprecated('Use cancelRequestDescriptor instead')
const CancelRequest$json = {
  '1': 'CancelRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 4, '10': 'id'},
  ],
};

/// Descriptor for `CancelRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelRequestDescriptor =
    $convert.base64Decode('Cg1DYW5jZWxSZXF1ZXN0Eg4KAmlkGAEgASgEUgJpZA==');

@$core.Deprecated('Use cancelResponseDescriptor instead')
const CancelResponse$json = {
  '1': 'CancelResponse',
};

/// Descriptor for `CancelResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelResponseDescriptor =
    $convert.base64Decode('Cg5DYW5jZWxSZXNwb25zZQ==');

@$core.Deprecated('Use statsRequestDescriptor instead')
const StatsRequest$json = {
  '1': 'StatsRequest',
};

/// Descriptor for `StatsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List statsRequestDescriptor =
    $convert.base64Decode('CgxTdGF0c1JlcXVlc3Q=');

@$core.Deprecated('Use statsResponseDescriptor instead')
const StatsResponse$json = {
  '1': 'StatsResponse',
  '2': [
    {'1': 'Count', '3': 1, '4': 1, '5': 3, '10': 'Count'},
    {'1': 'AvgTimeLeft', '3': 2, '4': 1, '5': 1, '10': 'AvgTimeLeft'},
    {'1': 'AvgSpeed', '3': 3, '4': 1, '5': 1, '10': 'AvgSpeed'},
    {'1': 'SumSpeed', '3': 4, '4': 1, '5': 1, '10': 'SumSpeed'},
    {'1': 'TotalBytes', '3': 5, '4': 1, '5': 4, '10': 'TotalBytes'},
  ],
};

/// Descriptor for `StatsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List statsResponseDescriptor = $convert.base64Decode(
    'Cg1TdGF0c1Jlc3BvbnNlEhQKBUNvdW50GAEgASgDUgVDb3VudBIgCgtBdmdUaW1lTGVmdBgCIA'
    'EoAVILQXZnVGltZUxlZnQSGgoIQXZnU3BlZWQYAyABKAFSCEF2Z1NwZWVkEhoKCFN1bVNwZWVk'
    'GAQgASgBUghTdW1TcGVlZBIeCgpUb3RhbEJ5dGVzGAUgASgEUgpUb3RhbEJ5dGVz');

@$core.Deprecated('Use editRequestDescriptor instead')
const EditRequest$json = {
  '1': 'EditRequest',
  '2': [
    {'1': 'downloadId', '3': 1, '4': 1, '5': 3, '10': 'downloadId'},
    {'1': 'downloadLink', '3': 2, '4': 1, '5': 9, '10': 'downloadLink'},
  ],
};

/// Descriptor for `EditRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List editRequestDescriptor = $convert.base64Decode(
    'CgtFZGl0UmVxdWVzdBIeCgpkb3dubG9hZElkGAEgASgDUgpkb3dubG9hZElkEiIKDGRvd25sb2'
    'FkTGluaxgCIAEoCVIMZG93bmxvYWRMaW5r');

@$core.Deprecated('Use editResponseDescriptor instead')
const EditResponse$json = {
  '1': 'EditResponse',
};

/// Descriptor for `EditResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List editResponseDescriptor =
    $convert.base64Decode('CgxFZGl0UmVzcG9uc2U=');

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
      '1': 'stats',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.downloader.v1.StatsResponse',
      '10': 'stats'
    },
    {
      '1': 'result',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.downloader.v1.DownloadResult',
      '10': 'result'
    },
  ],
};

/// Descriptor for `ListResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listResponseDescriptor = $convert.base64Decode(
    'CgxMaXN0UmVzcG9uc2USMgoFc3RhdHMYASABKAsyHC5kb3dubG9hZGVyLnYxLlN0YXRzUmVzcG'
    '9uc2VSBXN0YXRzEjUKBnJlc3VsdBgCIAEoCzIdLmRvd25sb2FkZXIudjEuRG93bmxvYWRSZXN1'
    'bHRSBnJlc3VsdA==');

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
    {
      '1': 'progress',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.downloader.v1.DownloadProgress',
      '10': 'progress'
    },
    {'1': 'download_path', '3': 6, '4': 1, '5': 9, '10': 'downloadPath'},
  ],
};

/// Descriptor for `Download`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List downloadDescriptor = $convert.base64Decode(
    'CghEb3dubG9hZBIOCgJpZBgBIAEoBFICaWQSIgoMY3JlYXRlZEF0U2VjGAcgASgEUgxjcmVhdG'
    'VkQXRTZWMSIgoMdXBkYXRlZEF0U2VjGAggASgEUgx1cGRhdGVkQXRTZWMSEgoEbmFtZRgCIAEo'
    'CVIEbmFtZRIjCg1kb3dubG9hZF9saW5rGAMgASgJUgxkb3dubG9hZExpbmsSNAoGc3RhdHVzGA'
    'QgASgOMhwuZG93bmxvYWRlci52MS5Eb3dubG9hZFN0YXRlUgZzdGF0dXMSOwoIcHJvZ3Jlc3MY'
    'BSABKAsyHy5kb3dubG9hZGVyLnYxLkRvd25sb2FkUHJvZ3Jlc3NSCHByb2dyZXNzEiMKDWRvd2'
    '5sb2FkX3BhdGgYBiABKAlSDGRvd25sb2FkUGF0aA==');

@$core.Deprecated('Use downloadProgressDescriptor instead')
const DownloadProgress$json = {
  '1': 'DownloadProgress',
  '2': [
    {'1': 'TimeLeftSecs', '3': 1, '4': 1, '5': 4, '10': 'TimeLeftSecs'},
    {
      '1': 'DownloadBytesPerSecond',
      '3': 2,
      '4': 1,
      '5': 4,
      '10': 'DownloadBytesPerSecond'
    },
    {'1': 'Total', '3': 3, '4': 1, '5': 4, '10': 'Total'},
    {'1': 'Complete', '3': 4, '4': 1, '5': 4, '10': 'Complete'},
    {'1': 'Error', '3': 5, '4': 1, '5': 9, '10': 'Error'},
  ],
};

/// Descriptor for `DownloadProgress`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List downloadProgressDescriptor = $convert.base64Decode(
    'ChBEb3dubG9hZFByb2dyZXNzEiIKDFRpbWVMZWZ0U2VjcxgBIAEoBFIMVGltZUxlZnRTZWNzEj'
    'YKFkRvd25sb2FkQnl0ZXNQZXJTZWNvbmQYAiABKARSFkRvd25sb2FkQnl0ZXNQZXJTZWNvbmQS'
    'FAoFVG90YWwYAyABKARSBVRvdGFsEhoKCENvbXBsZXRlGAQgASgEUghDb21wbGV0ZRIUCgVFcn'
    'JvchgFIAEoCVIFRXJyb3I=');

@$core.Deprecated('Use downloadResultDescriptor instead')
const DownloadResult$json = {
  '1': 'DownloadResult',
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

/// Descriptor for `DownloadResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List downloadResultDescriptor = $convert.base64Decode(
    'Cg5Eb3dubG9hZFJlc3VsdBIxCgdyZXN1bHRzGAEgAygLMhcuZG93bmxvYWRlci52MS5Eb3dubG'
    '9hZFIHcmVzdWx0cxIUCgVhZnRlchgCIAEoDVIFYWZ0ZXISFgoGYmVmb3JlGAMgASgNUgZiZWZv'
    'cmUSFAoFY291bnQYBCABKA1SBWNvdW50');

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
      '1': 'Cancel',
      '2': '.downloader.v1.CancelRequest',
      '3': '.downloader.v1.CancelResponse',
      '4': {}
    },
    {
      '1': 'List',
      '2': '.downloader.v1.ListRequest',
      '3': '.downloader.v1.ListResponse'
    },
    {
      '1': 'Edit',
      '2': '.downloader.v1.EditRequest',
      '3': '.downloader.v1.EditResponse',
      '4': {}
    },
    {
      '1': 'Stats',
      '2': '.downloader.v1.StatsRequest',
      '3': '.downloader.v1.StatsResponse',
      '4': {}
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
  '.downloader.v1.CancelRequest': CancelRequest$json,
  '.downloader.v1.CancelResponse': CancelResponse$json,
  '.downloader.v1.ListRequest': ListRequest$json,
  '.downloader.v1.ListResponse': ListResponse$json,
  '.downloader.v1.StatsResponse': StatsResponse$json,
  '.downloader.v1.DownloadResult': DownloadResult$json,
  '.downloader.v1.Download': Download$json,
  '.downloader.v1.DownloadProgress': DownloadProgress$json,
  '.downloader.v1.EditRequest': EditRequest$json,
  '.downloader.v1.EditResponse': EditResponse$json,
  '.downloader.v1.StatsRequest': StatsRequest$json,
};

/// Descriptor for `DownloaderService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List downloaderServiceDescriptor = $convert.base64Decode(
    'ChFEb3dubG9hZGVyU2VydmljZRJECgVSZXRyeRIbLmRvd25sb2FkZXIudjEuUmV0cnlSZXF1ZX'
    'N0GhwuZG93bmxvYWRlci52MS5SZXRyeVJlc3BvbnNlIgASSwoIRG93bmxvYWQSHi5kb3dubG9h'
    'ZGVyLnYxLkRvd25sb2FkUmVxdWVzdBofLmRvd25sb2FkZXIudjEuRG93bmxvYWRSZXNwb25zZR'
    'JHCgZDYW5jZWwSHC5kb3dubG9hZGVyLnYxLkNhbmNlbFJlcXVlc3QaHS5kb3dubG9hZGVyLnYx'
    'LkNhbmNlbFJlc3BvbnNlIgASPwoETGlzdBIaLmRvd25sb2FkZXIudjEuTGlzdFJlcXVlc3QaGy'
    '5kb3dubG9hZGVyLnYxLkxpc3RSZXNwb25zZRJBCgRFZGl0EhouZG93bmxvYWRlci52MS5FZGl0'
    'UmVxdWVzdBobLmRvd25sb2FkZXIudjEuRWRpdFJlc3BvbnNlIgASRAoFU3RhdHMSGy5kb3dubG'
    '9hZGVyLnYxLlN0YXRzUmVxdWVzdBocLmRvd25sb2FkZXIudjEuU3RhdHNSZXNwb25zZSIA');
