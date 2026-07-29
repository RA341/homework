import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:homework/common/result/result.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final basePathProvider = NotifierProvider<BasePathNotifier, String>(BasePathNotifier.new);

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider was not overridden');
});

final isUrlVerifiedProvider = StateProvider<bool>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return prefs.getBool('url_verified') ?? false;
});

class BasePathNotifier extends Notifier<String> {
  @override
  String build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final storedPath = prefs.getString('basepath') ?? 'http://localhost:9911';
    if (!storedPath.startsWith('http://') && !storedPath.startsWith('https://')) {
      return 'http://$storedPath/api';
    }
    return "$storedPath/api";
  }

  List<String> generateCandidates(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) return [];

    // Check protocol prefix (case-insensitive)
    final lowerInput = trimmed.toLowerCase();
    final bool hasHttp = lowerInput.startsWith('http://');
    final bool hasHttps = lowerInput.startsWith('https://');
    final bool hasProtocol = hasHttp || hasHttps;

    // Determine the protocol scheme if provided
    final String? providedScheme = hasHttp ? 'http' : (hasHttps ? 'https' : null);

    // Strip protocol if present to parse host & port
    final String rest = hasProtocol 
        ? trimmed.substring(hasHttp ? 7 : 8) 
        : trimmed;

    // Parse rest to find host, port, path, query, fragment
    // Prepend a dummy protocol to rest so Uri.parse works correctly
    final dummyUri = Uri.parse('http://$rest');
    final String host = dummyUri.host;
    final bool hasPort = dummyUri.hasPort;
    final int? port = hasPort ? dummyUri.port : null;
    final String path = dummyUri.path;
    final String query = dummyUri.query;
    final String fragment = dummyUri.fragment;
    final List<String> candidates = [];
    const defaultPort = 9911;

    String buildUrl(String scheme, int? p) {
      return Uri(
        scheme: scheme,
        host: host,
        port: p,
        pathSegments: path.isNotEmpty ? dummyUri.pathSegments : null,
        query: query.isNotEmpty ? query : null,
        fragment: fragment.isNotEmpty ? fragment : null,
      ).toString();
    }

    if (hasProtocol) {
      if (hasPort) {
        // Protocol provided, Port provided -> 1 candidate
        candidates.add(buildUrl(providedScheme!, port));
      } else {
        // Protocol provided, Port not provided -> 2 candidates
        candidates.add(buildUrl(providedScheme!, defaultPort));
        candidates.add(buildUrl(providedScheme, null));
      }
    } else {
      if (hasPort) {
        // Protocol not provided, Port provided -> 2 candidates (http and https)
        candidates.add(buildUrl('http', port));
        candidates.add(buildUrl('https', port));
      } else {
        // Protocol not provided, Port not provided -> 4 candidates
        candidates.add(buildUrl('http', defaultPort));
        candidates.add(buildUrl('http', null));
        candidates.add(buildUrl('https', defaultPort));
        candidates.add(buildUrl('https', null));
      }
    }

    // Deduplicate just in case
    return candidates.toSet().toList();
  }

  Future<bool> _pingUrl(String url) async {
    try {
      final pingUrl = url.endsWith('/')
          ? '${url}api/ping'
          : '$url/api/ping';

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
      _pingUrl(candidate).then((succeeded) {
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
      }).catchError((_) {
        if (completer.isCompleted) return;
        completedCount++;
        if (completedCount == candidates.length && !hasSucceeded) {
          completer.complete(null);
        }
      });
    }

    return completer.future;
  }

  Future<Result<String>> setBasePath(String newPath) async {
    final prefs = ref.read(sharedPreferencesProvider);

    var normalizedPath = newPath.trim();
    if (normalizedPath.isEmpty) {
      return Result.error(Exception('Path cannot be empty'));
    }

    final candidates = generateCandidates(normalizedPath);
    final successfulPath = await _findFirstSuccessfulCandidate(candidates);

    if (successfulPath == null) {
      return Result.error(Exception('No responsive candidate server found. Tried: ${candidates.join(", ")}'));
    }

    await prefs.setString('basepath', successfulPath);
    await prefs.setBool('url_verified', true);
    state = successfulPath;
    ref.read(isUrlVerifiedProvider.notifier).state = true;
    return Result.ok(successfulPath);
  }
}



