// This is a generated file - do not edit.
//
// Generated from content/v1/content.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use listRequestDescriptor instead')
const ListRequest$json = {
  '1': 'ListRequest',
  '2': [
    {'1': 'query', '3': 1, '4': 1, '5': 9, '10': 'query'},
    {'1': 'after', '3': 2, '4': 1, '5': 4, '10': 'after'},
    {'1': 'before', '3': 3, '4': 1, '5': 4, '10': 'before'},
    {'1': 'limit', '3': 4, '4': 1, '5': 4, '10': 'limit'},
  ],
};

/// Descriptor for `ListRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listRequestDescriptor = $convert.base64Decode(
    'CgtMaXN0UmVxdWVzdBIUCgVxdWVyeRgBIAEoCVIFcXVlcnkSFAoFYWZ0ZXIYAiABKARSBWFmdG'
    'VyEhYKBmJlZm9yZRgDIAEoBFIGYmVmb3JlEhQKBWxpbWl0GAQgASgEUgVsaW1pdA==');

@$core.Deprecated('Use listResponseDescriptor instead')
const ListResponse$json = {
  '1': 'ListResponse',
  '2': [
    {
      '1': 'results',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.content.v1.Content',
      '10': 'results'
    },
    {'1': 'after', '3': 2, '4': 1, '5': 4, '10': 'after'},
    {'1': 'before', '3': 3, '4': 1, '5': 4, '10': 'before'},
    {'1': 'count', '3': 4, '4': 1, '5': 4, '10': 'count'},
  ],
};

/// Descriptor for `ListResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listResponseDescriptor = $convert.base64Decode(
    'CgxMaXN0UmVzcG9uc2USLQoHcmVzdWx0cxgBIAMoCzITLmNvbnRlbnQudjEuQ29udGVudFIHcm'
    'VzdWx0cxIUCgVhZnRlchgCIAEoBFIFYWZ0ZXISFgoGYmVmb3JlGAMgASgEUgZiZWZvcmUSFAoF'
    'Y291bnQYBCABKARSBWNvdW50');

@$core.Deprecated('Use contentDescriptor instead')
const Content$json = {
  '1': 'Content',
  '2': [
    {'1': 'Id', '3': 4, '4': 1, '5': 4, '10': 'Id'},
    {'1': 'CreatedAt', '3': 5, '4': 1, '5': 3, '10': 'CreatedAt'},
    {'1': 'UpdatedAt', '3': 6, '4': 1, '5': 3, '10': 'UpdatedAt'},
    {'1': 'Type', '3': 1, '4': 1, '5': 9, '10': 'Type'},
    {'1': 'Title', '3': 2, '4': 1, '5': 9, '10': 'Title'},
    {'1': 'Description', '3': 3, '4': 1, '5': 9, '10': 'Description'},
  ],
};

/// Descriptor for `Content`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List contentDescriptor = $convert.base64Decode(
    'CgdDb250ZW50Eg4KAklkGAQgASgEUgJJZBIcCglDcmVhdGVkQXQYBSABKANSCUNyZWF0ZWRBdB'
    'IcCglVcGRhdGVkQXQYBiABKANSCVVwZGF0ZWRBdBISCgRUeXBlGAEgASgJUgRUeXBlEhQKBVRp'
    'dGxlGAIgASgJUgVUaXRsZRIgCgtEZXNjcmlwdGlvbhgDIAEoCVILRGVzY3JpcHRpb24=');

const $core.Map<$core.String, $core.dynamic> ContentServiceBase$json = {
  '1': 'ContentService',
  '2': [
    {
      '1': 'List',
      '2': '.content.v1.ListRequest',
      '3': '.content.v1.ListResponse',
      '4': {}
    },
  ],
};

@$core.Deprecated('Use contentServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    ContentServiceBase$messageJson = {
  '.content.v1.ListRequest': ListRequest$json,
  '.content.v1.ListResponse': ListResponse$json,
  '.content.v1.Content': Content$json,
};

/// Descriptor for `ContentService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List contentServiceDescriptor = $convert.base64Decode(
    'Cg5Db250ZW50U2VydmljZRI7CgRMaXN0EhcuY29udGVudC52MS5MaXN0UmVxdWVzdBoYLmNvbn'
    'RlbnQudjEuTGlzdFJlc3BvbnNlIgA=');
