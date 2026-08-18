// This is a generated file - do not edit.
//
// Generated from user/v1/user.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use selfRequestDescriptor instead')
const SelfRequest$json = {
  '1': 'SelfRequest',
};

/// Descriptor for `SelfRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List selfRequestDescriptor =
    $convert.base64Decode('CgtTZWxmUmVxdWVzdA==');

@$core.Deprecated('Use selfResponseDescriptor instead')
const SelfResponse$json = {
  '1': 'SelfResponse',
  '2': [
    {'1': 'user', '3': 1, '4': 1, '5': 11, '6': '.user.v1.User', '10': 'user'},
  ],
};

/// Descriptor for `SelfResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List selfResponseDescriptor = $convert.base64Decode(
    'CgxTZWxmUmVzcG9uc2USIQoEdXNlchgBIAEoCzINLnVzZXIudjEuVXNlclIEdXNlcg==');

@$core.Deprecated('Use userDescriptor instead')
const User$json = {
  '1': 'User',
  '2': [
    {'1': 'userId', '3': 1, '4': 1, '5': 4, '10': 'userId'},
    {'1': 'username', '3': 2, '4': 1, '5': 9, '10': 'username'},
  ],
};

/// Descriptor for `User`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userDescriptor = $convert.base64Decode(
    'CgRVc2VyEhYKBnVzZXJJZBgBIAEoBFIGdXNlcklkEhoKCHVzZXJuYW1lGAIgASgJUgh1c2Vybm'
    'FtZQ==');

const $core.Map<$core.String, $core.dynamic> UserServiceBase$json = {
  '1': 'UserService',
  '2': [
    {
      '1': 'Self',
      '2': '.user.v1.SelfRequest',
      '3': '.user.v1.SelfResponse',
      '4': {}
    },
  ],
};

@$core.Deprecated('Use userServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    UserServiceBase$messageJson = {
  '.user.v1.SelfRequest': SelfRequest$json,
  '.user.v1.SelfResponse': SelfResponse$json,
  '.user.v1.User': User$json,
};

/// Descriptor for `UserService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List userServiceDescriptor = $convert.base64Decode(
    'CgtVc2VyU2VydmljZRI1CgRTZWxmEhQudXNlci52MS5TZWxmUmVxdWVzdBoVLnVzZXIudjEuU2'
    'VsZlJlc3BvbnNlIgA=');
