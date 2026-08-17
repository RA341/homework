// This is a generated file - do not edit.
//
// Generated from auth/v1/auth.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use loginRequestDescriptor instead')
const LoginRequest$json = {
  '1': 'LoginRequest',
  '2': [
    {'1': 'username', '3': 1, '4': 1, '5': 9, '10': 'username'},
    {'1': 'password', '3': 2, '4': 1, '5': 9, '10': 'password'},
  ],
};

/// Descriptor for `LoginRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginRequestDescriptor = $convert.base64Decode(
    'CgxMb2dpblJlcXVlc3QSGgoIdXNlcm5hbWUYASABKAlSCHVzZXJuYW1lEhoKCHBhc3N3b3JkGA'
    'IgASgJUghwYXNzd29yZA==');

@$core.Deprecated('Use tokenDescriptor instead')
const Token$json = {
  '1': 'Token',
  '2': [
    {'1': 'value', '3': 1, '4': 1, '5': 9, '10': 'value'},
    {'1': 'expiry', '3': 2, '4': 1, '5': 3, '10': 'expiry'},
  ],
};

/// Descriptor for `Token`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tokenDescriptor = $convert.base64Decode(
    'CgVUb2tlbhIUCgV2YWx1ZRgBIAEoCVIFdmFsdWUSFgoGZXhwaXJ5GAIgASgDUgZleHBpcnk=');

@$core.Deprecated('Use loginResponseDescriptor instead')
const LoginResponse$json = {
  '1': 'LoginResponse',
  '2': [
    {
      '1': 'session',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.auth.v1.Token',
      '10': 'session'
    },
    {
      '1': 'refresh',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.auth.v1.Token',
      '10': 'refresh'
    },
  ],
};

/// Descriptor for `LoginResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginResponseDescriptor = $convert.base64Decode(
    'Cg1Mb2dpblJlc3BvbnNlEigKB3Nlc3Npb24YASABKAsyDi5hdXRoLnYxLlRva2VuUgdzZXNzaW'
    '9uEigKB3JlZnJlc2gYAiABKAsyDi5hdXRoLnYxLlRva2VuUgdyZWZyZXNo');

@$core.Deprecated('Use logoutRequestDescriptor instead')
const LogoutRequest$json = {
  '1': 'LogoutRequest',
  '2': [
    {'1': 'refresh_token', '3': 1, '4': 1, '5': 9, '10': 'refreshToken'},
  ],
};

/// Descriptor for `LogoutRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List logoutRequestDescriptor = $convert.base64Decode(
    'Cg1Mb2dvdXRSZXF1ZXN0EiMKDXJlZnJlc2hfdG9rZW4YASABKAlSDHJlZnJlc2hUb2tlbg==');

@$core.Deprecated('Use logoutResponseDescriptor instead')
const LogoutResponse$json = {
  '1': 'LogoutResponse',
};

/// Descriptor for `LogoutResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List logoutResponseDescriptor =
    $convert.base64Decode('Cg5Mb2dvdXRSZXNwb25zZQ==');

@$core.Deprecated('Use refreshRequestDescriptor instead')
const RefreshRequest$json = {
  '1': 'RefreshRequest',
  '2': [
    {'1': 'refresh_token', '3': 1, '4': 1, '5': 9, '10': 'refreshToken'},
  ],
};

/// Descriptor for `RefreshRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List refreshRequestDescriptor = $convert.base64Decode(
    'Cg5SZWZyZXNoUmVxdWVzdBIjCg1yZWZyZXNoX3Rva2VuGAEgASgJUgxyZWZyZXNoVG9rZW4=');

@$core.Deprecated('Use refreshResponseDescriptor instead')
const RefreshResponse$json = {
  '1': 'RefreshResponse',
  '2': [
    {
      '1': 'session',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.auth.v1.Token',
      '10': 'session'
    },
    {
      '1': 'refresh',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.auth.v1.Token',
      '10': 'refresh'
    },
  ],
};

/// Descriptor for `RefreshResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List refreshResponseDescriptor = $convert.base64Decode(
    'Cg9SZWZyZXNoUmVzcG9uc2USKAoHc2Vzc2lvbhgBIAEoCzIOLmF1dGgudjEuVG9rZW5SB3Nlc3'
    'Npb24SKAoHcmVmcmVzaBgCIAEoCzIOLmF1dGgudjEuVG9rZW5SB3JlZnJlc2g=');

const $core.Map<$core.String, $core.dynamic> AuthServiceBase$json = {
  '1': 'AuthService',
  '2': [
    {'1': 'Login', '2': '.auth.v1.LoginRequest', '3': '.auth.v1.LoginResponse'},
    {
      '1': 'Logout',
      '2': '.auth.v1.LogoutRequest',
      '3': '.auth.v1.LogoutResponse'
    },
    {
      '1': 'Refresh',
      '2': '.auth.v1.RefreshRequest',
      '3': '.auth.v1.RefreshResponse'
    },
  ],
};

@$core.Deprecated('Use authServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    AuthServiceBase$messageJson = {
  '.auth.v1.LoginRequest': LoginRequest$json,
  '.auth.v1.LoginResponse': LoginResponse$json,
  '.auth.v1.Token': Token$json,
  '.auth.v1.LogoutRequest': LogoutRequest$json,
  '.auth.v1.LogoutResponse': LogoutResponse$json,
  '.auth.v1.RefreshRequest': RefreshRequest$json,
  '.auth.v1.RefreshResponse': RefreshResponse$json,
};

/// Descriptor for `AuthService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List authServiceDescriptor = $convert.base64Decode(
    'CgtBdXRoU2VydmljZRI2CgVMb2dpbhIVLmF1dGgudjEuTG9naW5SZXF1ZXN0GhYuYXV0aC52MS'
    '5Mb2dpblJlc3BvbnNlEjkKBkxvZ291dBIWLmF1dGgudjEuTG9nb3V0UmVxdWVzdBoXLmF1dGgu'
    'djEuTG9nb3V0UmVzcG9uc2USPAoHUmVmcmVzaBIXLmF1dGgudjEuUmVmcmVzaFJlcXVlc3QaGC'
    '5hdXRoLnYxLlJlZnJlc2hSZXNwb25zZQ==');
