// This is a generated file - do not edit.
//
// Generated from downloader/v1/downloader.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'downloader.pb.dart' as $0;
import 'downloader.pbjson.dart';

export 'downloader.pb.dart';

abstract class DownloaderServiceBase extends $pb.GeneratedService {
  $async.Future<$0.RetryResponse> retry(
      $pb.ServerContext ctx, $0.RetryRequest request);
  $async.Future<$0.DownloadResponse> download(
      $pb.ServerContext ctx, $0.DownloadRequest request);
  $async.Future<$0.CancelResponse> cancel(
      $pb.ServerContext ctx, $0.CancelRequest request);
  $async.Future<$0.ListResponse> list(
      $pb.ServerContext ctx, $0.ListRequest request);
  $async.Future<$0.EditResponse> edit(
      $pb.ServerContext ctx, $0.EditRequest request);
  $async.Future<$0.StatsResponse> stats(
      $pb.ServerContext ctx, $0.StatsRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'Retry':
        return $0.RetryRequest();
      case 'Download':
        return $0.DownloadRequest();
      case 'Cancel':
        return $0.CancelRequest();
      case 'List':
        return $0.ListRequest();
      case 'Edit':
        return $0.EditRequest();
      case 'Stats':
        return $0.StatsRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'Retry':
        return retry(ctx, request as $0.RetryRequest);
      case 'Download':
        return download(ctx, request as $0.DownloadRequest);
      case 'Cancel':
        return cancel(ctx, request as $0.CancelRequest);
      case 'List':
        return list(ctx, request as $0.ListRequest);
      case 'Edit':
        return edit(ctx, request as $0.EditRequest);
      case 'Stats':
        return stats(ctx, request as $0.StatsRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json =>
      DownloaderServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => DownloaderServiceBase$messageJson;
}
