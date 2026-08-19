import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homework/common/prefs/prefs.dart';

final isUrlVerifiedProvider = NotifierProvider<IsUrlVerifiedNotifier, bool>(
  IsUrlVerifiedNotifier.new,
);

class IsUrlVerifiedNotifier extends Notifier<bool> {
  static const prefKey = 'url_verified';

  @override
  bool build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return prefs.getBool(prefKey) ?? false;
  }

  bool get value => state;

  set value(bool newValue) {
    final prefs = ref.read(sharedPreferencesProvider);
    prefs.setBool(prefKey, newValue);
    state = newValue;
  }

  Future<void> set(bool newValue) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(prefKey, newValue);
    state = newValue;
  }
}
