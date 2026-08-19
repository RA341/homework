import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homework/common/api/basepath.provider.verfied.dart';
import 'package:homework/common/prefs/prefs.dart';
import 'package:homework/common/utils/result.dart';
import 'package:http/http.dart' as http;

final basePathNotifierProvider = NotifierProvider<BasePathNotifier, String>(
  BasePathNotifier.new,
);

class BasePathNotifier extends Notifier<String> {
  static const prefKey = 'basepath';

  @override
  String build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final storedPath = prefs.getString(prefKey) ?? '';
    return storedPath;
  }

  Future<ErrorResult<String>> setBasePath(String newPath) async {
    final prefs = ref.read(sharedPreferencesProvider);

    var normalizedPath = newPath.trim();
    if (normalizedPath.isEmpty) {
      return Error('Path cannot be empty');
    }

    final candidates = _generateCandidates(normalizedPath);
    final successfulPath = await _findFirstSuccessfulCandidate(candidates);

    if (successfulPath == null) {
      return Error(
        'No responsive candidate server found. Tried: ${candidates.join(", ")}',
      );
    }

    await prefs.setString(prefKey, successfulPath);
    state = successfulPath;
    await ref.read(isUrlVerifiedProvider.notifier).set(true);
    return Ok(successfulPath);
  }

  Future<void> clear() async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.remove(prefKey);
    await ref.read(isUrlVerifiedProvider.notifier).set(false);
    state = '';
  }

  static const defaultPort = 9911;

  List<String> _generateCandidates(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) return [];

    final lower = trimmed.toLowerCase();
    final hasProtocol =
        lower.startsWith('http://') || lower.startsWith('https://');
    final providedScheme = lower.startsWith('https://') ? 'https' : 'http';

    final rest = hasProtocol
        ? trimmed.substring(trimmed.indexOf('://') + 3)
        : trimmed;
    final dummyUri = Uri.parse('http://$rest');

    final schemes = hasProtocol ? [providedScheme] : ['http', 'https'];
    final ports = dummyUri.hasPort ? [dummyUri.port] : [defaultPort, null];

    final candidates = [
      for (final s in schemes)
        for (final p in ports) buildUrl(dummyUri, s, p),
    ];

    return candidates.toSet().toList();
  }

  String buildUrl(Uri dummyUri, String scheme, int? p) => Uri(
    scheme: scheme,
    host: dummyUri.host,
    port: p,
    pathSegments: dummyUri.path.isNotEmpty ? dummyUri.pathSegments : null,
    query: dummyUri.query.isNotEmpty ? dummyUri.query : null,
    fragment: dummyUri.fragment.isNotEmpty ? dummyUri.fragment : null,
  ).toString();

  Future<bool> _pingUrl(String url) async {
    const pingEndpoint = "api/public/ping";

    try {
      final pingUrl = url.endsWith('/')
          ? '$url$pingEndpoint'
          : '$url/$pingEndpoint';

      final uri = Uri.parse(pingUrl);
      final response = await http.get(uri).timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<String?> _findFirstSuccessfulCandidate(List<String> candidates) async {
    if (candidates.isEmpty) return null;

    final completer = Completer<String?>();
    int completedCount = 0;
    bool hasSucceeded = false;

    for (final candidate in candidates) {
      _pingUrl(candidate)
          .then((succeeded) {
            if (completer.isCompleted) return;
            if (succeeded) {
              hasSucceeded = true;
              completer.complete(candidate);
            } else {
              completedCount++;
              if (completedCount == candidates.length && !hasSucceeded) {
                completer.complete(null);
              }
            }
          })
          .catchError((_) {
            if (completer.isCompleted) return;
            completedCount++;
            if (completedCount == candidates.length && !hasSucceeded) {
              completer.complete(null);
            }
          });
    }

    return completer.future;
  }
}
