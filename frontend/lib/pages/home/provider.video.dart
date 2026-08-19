import 'package:homework/common/api/token.provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:media_kit/media_kit.dart';

final videoPlayerProvider = Provider.autoDispose<Player>((ref) {
  final player = Player();

  ref.listen<AsyncValue<AuthTokens>>(authTokenProvider, (previous, next) {
    final tokens = next.value;
    if (tokens != null) {
      final platform = player.platform;
      try {
        (platform as dynamic).setProperty(
          "http-header-fields",
          "session: ${tokens.session ?? ""}",
        );
      } catch (_) {}
    }
  }, fireImmediately: true);

  ref.onDispose(() {
    // logger.d("disposing player");
    player.dispose();
  });

  return player;
});
