
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homework/common/api/basepath.provider.notifier.dart';

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
