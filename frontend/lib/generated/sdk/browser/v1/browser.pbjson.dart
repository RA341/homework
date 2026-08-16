// This is a generated file - do not edit.
//
// Generated from browser/v1/browser.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use startRequestDescriptor instead')
const StartRequest$json = {
  '1': 'StartRequest',
};

/// Descriptor for `StartRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startRequestDescriptor =
    $convert.base64Decode('CgxTdGFydFJlcXVlc3Q=');

@$core.Deprecated('Use startResponseDescriptor instead')
const StartResponse$json = {
  '1': 'StartResponse',
};

/// Descriptor for `StartResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startResponseDescriptor =
    $convert.base64Decode('Cg1TdGFydFJlc3BvbnNl');

@$core.Deprecated('Use stopRequestDescriptor instead')
const StopRequest$json = {
  '1': 'StopRequest',
};

/// Descriptor for `StopRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stopRequestDescriptor =
    $convert.base64Decode('CgtTdG9wUmVxdWVzdA==');

@$core.Deprecated('Use stopResponseDescriptor instead')
const StopResponse$json = {
  '1': 'StopResponse',
};

/// Descriptor for `StopResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stopResponseDescriptor =
    $convert.base64Decode('CgxTdG9wUmVzcG9uc2U=');

@$core.Deprecated('Use statusRequestDescriptor instead')
const StatusRequest$json = {
  '1': 'StatusRequest',
};

/// Descriptor for `StatusRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List statusRequestDescriptor =
    $convert.base64Decode('Cg1TdGF0dXNSZXF1ZXN0');

@$core.Deprecated('Use statusResponseDescriptor instead')
const StatusResponse$json = {
  '1': 'StatusResponse',
};

/// Descriptor for `StatusResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List statusResponseDescriptor =
    $convert.base64Decode('Cg5TdGF0dXNSZXNwb25zZQ==');

const $core.Map<$core.String, $core.dynamic> BrowserServiceBase$json = {
  '1': 'BrowserService',
  '2': [
    {
      '1': 'Start',
      '2': '.browser.v1.StartRequest',
      '3': '.browser.v1.StartResponse',
      '4': {}
    },
    {
      '1': 'Stop',
      '2': '.browser.v1.StopRequest',
      '3': '.browser.v1.StopResponse',
      '4': {}
    },
    {
      '1': 'Status',
      '2': '.browser.v1.StatusRequest',
      '3': '.browser.v1.StatusResponse',
      '4': {}
    },
  ],
};

@$core.Deprecated('Use browserServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    BrowserServiceBase$messageJson = {
  '.browser.v1.StartRequest': StartRequest$json,
  '.browser.v1.StartResponse': StartResponse$json,
  '.browser.v1.StopRequest': StopRequest$json,
  '.browser.v1.StopResponse': StopResponse$json,
  '.browser.v1.StatusRequest': StatusRequest$json,
  '.browser.v1.StatusResponse': StatusResponse$json,
};

/// Descriptor for `BrowserService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List browserServiceDescriptor = $convert.base64Decode(
    'Cg5Ccm93c2VyU2VydmljZRI+CgVTdGFydBIYLmJyb3dzZXIudjEuU3RhcnRSZXF1ZXN0GhkuYn'
    'Jvd3Nlci52MS5TdGFydFJlc3BvbnNlIgASOwoEU3RvcBIXLmJyb3dzZXIudjEuU3RvcFJlcXVl'
    'c3QaGC5icm93c2VyLnYxLlN0b3BSZXNwb25zZSIAEkEKBlN0YXR1cxIZLmJyb3dzZXIudjEuU3'
    'RhdHVzUmVxdWVzdBoaLmJyb3dzZXIudjEuU3RhdHVzUmVzcG9uc2UiAA==');
