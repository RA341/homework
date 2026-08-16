// This is a generated file - do not edit.
//
// Generated from browser/v1/browser.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'browser.pb.dart' as $0;
import 'browser.pbjson.dart';

export 'browser.pb.dart';

abstract class BrowserServiceBase extends $pb.GeneratedService {
  $async.Future<$0.StartResponse> start(
      $pb.ServerContext ctx, $0.StartRequest request);
  $async.Future<$0.StopResponse> stop(
      $pb.ServerContext ctx, $0.StopRequest request);
  $async.Future<$0.StatusResponse> status(
      $pb.ServerContext ctx, $0.StatusRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'Start':
        return $0.StartRequest();
      case 'Stop':
        return $0.StopRequest();
      case 'Status':
        return $0.StatusRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'Start':
        return start(ctx, request as $0.StartRequest);
      case 'Stop':
        return stop(ctx, request as $0.StopRequest);
      case 'Status':
        return status(ctx, request as $0.StatusRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => BrowserServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => BrowserServiceBase$messageJson;
}
