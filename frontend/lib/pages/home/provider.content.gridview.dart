import 'package:flutter_riverpod/flutter_riverpod.dart';

final isGridViewProvider = NotifierProvider<IsGridViewNotifier, bool>(
  IsGridViewNotifier.new,
);

class IsGridViewNotifier extends Notifier<bool> {
  @override
  bool build() => true;

  void toggle() => state = !state;

  void setGridView(bool isGrid) => state = isGrid;
}
