import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:homework/common/api/basepath.provider.notifier.dart';
import 'package:homework/common/prefs/prefs.dart';
import 'package:homework/common/utils/result.dart';
import 'package:http/http.dart' as http;

final basePathProvider = Provider<String>((ref) {
  final base = ref.watch(basePathNotifierProvider);
  return "$base/api";
});

final protectedPathProvider = Provider<String>((ref) {
  var base = ref.watch(basePathProvider);
  return "$base/protected";
});

final publicPathProvider = Provider<String>((ref) {
  var base = ref.watch(basePathProvider);
  return "$base/public";
});
