// This is a generated file - do not edit.
//
// Generated from media/v1/media.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use contentTypeDescriptor instead')
const ContentType$json = {
  '1': 'ContentType',
  '2': [
    {'1': 'CONTENT_TYPE_UNKNOWN', '2': 0},
    {'1': 'CONTENT_TYPE_MOVIE', '2': 1},
    {'1': 'CONTENT_TYPE_SERIES', '2': 2},
    {'1': 'CONTENT_TYPE_EPISODE', '2': 3},
    {'1': 'CONTENT_TYPE_VIDEO', '2': 4},
    {'1': 'CONTENT_TYPE_IMAGE', '2': 5},
    {'1': 'CONTENT_TYPE_GALLERY', '2': 6},
    {'1': 'CONTENT_TYPE_SEASON', '2': 7},
  ],
};

/// Descriptor for `ContentType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List contentTypeDescriptor = $convert.base64Decode(
    'CgtDb250ZW50VHlwZRIYChRDT05URU5UX1RZUEVfVU5LTk9XThAAEhYKEkNPTlRFTlRfVFlQRV'
    '9NT1ZJRRABEhcKE0NPTlRFTlRfVFlQRV9TRVJJRVMQAhIYChRDT05URU5UX1RZUEVfRVBJU09E'
    'RRADEhYKEkNPTlRFTlRfVFlQRV9WSURFTxAEEhYKEkNPTlRFTlRfVFlQRV9JTUFHRRAFEhgKFE'
    'NPTlRFTlRfVFlQRV9HQUxMRVJZEAYSFwoTQ09OVEVOVF9UWVBFX1NFQVNPThAH');

@$core.Deprecated('Use assetTypeDescriptor instead')
const AssetType$json = {
  '1': 'AssetType',
  '2': [
    {'1': 'ASSET_TYPE_UNKNOWN', '2': 0},
    {'1': 'ASSET_TYPE_VIDEO', '2': 1},
    {'1': 'ASSET_TYPE_IMAGE', '2': 2},
    {'1': 'ASSET_TYPE_SUBTITLE', '2': 3},
    {'1': 'ASSET_TYPE_AUDIO', '2': 4},
  ],
};

/// Descriptor for `AssetType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List assetTypeDescriptor = $convert.base64Decode(
    'CglBc3NldFR5cGUSFgoSQVNTRVRfVFlQRV9VTktOT1dOEAASFAoQQVNTRVRfVFlQRV9WSURFTx'
    'ABEhQKEEFTU0VUX1RZUEVfSU1BR0UQAhIXChNBU1NFVF9UWVBFX1NVQlRJVExFEAMSFAoQQVNT'
    'RVRfVFlQRV9BVURJTxAE');

@$core.Deprecated('Use assetRoleDescriptor instead')
const AssetRole$json = {
  '1': 'AssetRole',
  '2': [
    {'1': 'ASSET_ROLE_MAIN', '2': 0},
    {'1': 'ASSET_ROLE_THUMBNAIL', '2': 1},
    {'1': 'ASSET_ROLE_BACKDROP', '2': 2},
    {'1': 'ASSET_ROLE_TRAILER', '2': 3},
    {'1': 'ASSET_ROLE_POSTER', '2': 4},
  ],
};

/// Descriptor for `AssetRole`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List assetRoleDescriptor = $convert.base64Decode(
    'CglBc3NldFJvbGUSEwoPQVNTRVRfUk9MRV9NQUlOEAASGAoUQVNTRVRfUk9MRV9USFVNQk5BSU'
    'wQARIXChNBU1NFVF9ST0xFX0JBQ0tEUk9QEAISFgoSQVNTRVRfUk9MRV9UUkFJTEVSEAMSFQoR'
    'QVNTRVRfUk9MRV9QT1NURVIQBA==');

@$core.Deprecated('Use addAndDownloadRequestDescriptor instead')
const AddAndDownloadRequest$json = {
  '1': 'AddAndDownloadRequest',
  '2': [
    {
      '1': 'media',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.media.v1.CreateMedia',
      '10': 'media'
    },
    {'1': 'downloadLink', '3': 2, '4': 1, '5': 9, '10': 'downloadLink'},
  ],
};

/// Descriptor for `AddAndDownloadRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addAndDownloadRequestDescriptor = $convert.base64Decode(
    'ChVBZGRBbmREb3dubG9hZFJlcXVlc3QSKwoFbWVkaWEYASABKAsyFS5tZWRpYS52MS5DcmVhdG'
    'VNZWRpYVIFbWVkaWESIgoMZG93bmxvYWRMaW5rGAIgASgJUgxkb3dubG9hZExpbms=');

@$core.Deprecated('Use addAndDownloadResponseDescriptor instead')
const AddAndDownloadResponse$json = {
  '1': 'AddAndDownloadResponse',
};

/// Descriptor for `AddAndDownloadResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addAndDownloadResponseDescriptor =
    $convert.base64Decode('ChZBZGRBbmREb3dubG9hZFJlc3BvbnNl');

@$core.Deprecated('Use createContentDescriptor instead')
const CreateContent$json = {
  '1': 'CreateContent',
  '2': [
    {'1': 'title', '3': 1, '4': 1, '5': 9, '10': 'title'},
    {'1': 'desc', '3': 2, '4': 1, '5': 9, '10': 'desc'},
    {
      '1': 'content_type',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.media.v1.ContentType',
      '10': 'contentType'
    },
  ],
};

/// Descriptor for `CreateContent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createContentDescriptor = $convert.base64Decode(
    'Cg1DcmVhdGVDb250ZW50EhQKBXRpdGxlGAEgASgJUgV0aXRsZRISCgRkZXNjGAIgASgJUgRkZX'
    'NjEjgKDGNvbnRlbnRfdHlwZRgDIAEoDjIVLm1lZGlhLnYxLkNvbnRlbnRUeXBlUgtjb250ZW50'
    'VHlwZQ==');

@$core.Deprecated('Use createMediaDescriptor instead')
const CreateMedia$json = {
  '1': 'CreateMedia',
  '2': [
    {
      '1': 'content',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.media.v1.CreateContent',
      '10': 'content'
    },
    {
      '1': 'asset',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.media.v1.CreateAsset',
      '10': 'asset'
    },
  ],
};

/// Descriptor for `CreateMedia`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createMediaDescriptor = $convert.base64Decode(
    'CgtDcmVhdGVNZWRpYRIxCgdjb250ZW50GAEgASgLMhcubWVkaWEudjEuQ3JlYXRlQ29udGVudF'
    'IHY29udGVudBIrCgVhc3NldBgCIAEoCzIVLm1lZGlhLnYxLkNyZWF0ZUFzc2V0UgVhc3NldA==');

@$core.Deprecated('Use createAssetDescriptor instead')
const CreateAsset$json = {
  '1': 'CreateAsset',
  '2': [
    {
      '1': 'asset_type',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.media.v1.AssetType',
      '10': 'assetType'
    },
    {
      '1': 'asset_role',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.media.v1.AssetRole',
      '10': 'assetRole'
    },
    {'1': 'filepath', '3': 3, '4': 1, '5': 9, '10': 'filepath'},
  ],
};

/// Descriptor for `CreateAsset`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createAssetDescriptor = $convert.base64Decode(
    'CgtDcmVhdGVBc3NldBIyCgphc3NldF90eXBlGAEgASgOMhMubWVkaWEudjEuQXNzZXRUeXBlUg'
    'lhc3NldFR5cGUSMgoKYXNzZXRfcm9sZRgCIAEoDjITLm1lZGlhLnYxLkFzc2V0Um9sZVIJYXNz'
    'ZXRSb2xlEhoKCGZpbGVwYXRoGAMgASgJUghmaWxlcGF0aA==');

const $core.Map<$core.String, $core.dynamic> MediaServiceBase$json = {
  '1': 'MediaService',
  '2': [
    {
      '1': 'AddAndDownload',
      '2': '.media.v1.AddAndDownloadRequest',
      '3': '.media.v1.AddAndDownloadResponse',
      '4': {}
    },
  ],
};

@$core.Deprecated('Use mediaServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    MediaServiceBase$messageJson = {
  '.media.v1.AddAndDownloadRequest': AddAndDownloadRequest$json,
  '.media.v1.CreateMedia': CreateMedia$json,
  '.media.v1.CreateContent': CreateContent$json,
  '.media.v1.CreateAsset': CreateAsset$json,
  '.media.v1.AddAndDownloadResponse': AddAndDownloadResponse$json,
};

/// Descriptor for `MediaService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List mediaServiceDescriptor = $convert.base64Decode(
    'CgxNZWRpYVNlcnZpY2USVQoOQWRkQW5kRG93bmxvYWQSHy5tZWRpYS52MS5BZGRBbmREb3dubG'
    '9hZFJlcXVlc3QaIC5tZWRpYS52MS5BZGRBbmREb3dubG9hZFJlc3BvbnNlIgA=');
