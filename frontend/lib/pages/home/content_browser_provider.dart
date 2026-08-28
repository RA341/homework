import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homework/common/services/content/content.provider.dart';
import 'package:homework/generated/sdk/content/v1/content.pb.dart';

enum ContentFilterType {
  all('All'),
  video('Video'),
  image('Image'),
  subtitle('Subtitle'),
  audio('Audio');

  final String label;

  const ContentFilterType(this.label);
}

final isGridViewProvider = NotifierProvider<IsGridViewNotifier, bool>(
  IsGridViewNotifier.new,
);

class IsGridViewNotifier extends Notifier<bool> {
  @override
  bool build() => true;

  void toggle() => state = !state;
  void setGridView(bool isGrid) => state = isGrid;
}

final contentListProvider =
    AsyncNotifierProvider<ContentListNotifier, ContentListState>(
      ContentListNotifier.new,
    );

// Notifier that handles querying, filtering, and pagination for ContentServiceClient
class ContentListNotifier extends AsyncNotifier<ContentListState> {
  @override
  Future<ContentListState> build() async {
    final client = ref.read(contentApiProvider);
    const limit = 20;

    final request = ListRequest(query: '', limit: Int64(limit), after: null);

    final response = await client.list(request);
    final hasMore =
        response.after != Int64.ZERO && response.results.length >= limit;

    return ContentListState(
      items: response.results,
      query: '',
      filterType: ContentFilterType.all,
      limit: limit,
      after: response.after,
      hasMore: hasMore,
    );
  }

  Future<void> loadNextPage({bool reset = false}) async {
    final currentState = state.value;
    if (state.isLoading && !reset) return;

    if (reset) {
      state = const AsyncLoading();
    }

    state = await AsyncValue.guard(() async {
      final client = ref.read(contentApiProvider);
      final query = reset
          ? (currentState?.query ?? '')
          : (currentState?.query ?? '');
      final limit = currentState?.limit ?? 20;
      final nextAfter = reset ? null : currentState?.after;

      final request = ListRequest(
        query: query,
        limit: Int64(limit),
        after: nextAfter,
      );

      final response = await client.list(request);

      final newItems = response.results;
      final updatedItems = reset || currentState == null
          ? newItems
          : [...currentState.items, ...newItems];

      final hasMore =
          response.after != Int64.ZERO && response.results.length >= limit;

      return ContentListState(
        items: updatedItems,
        query: query,
        filterType: currentState?.filterType ?? ContentFilterType.all,
        limit: limit,
        after: response.after,
        hasMore: hasMore,
      );
    });
  }

  Future<void> setQuery(String newQuery) async {
    final trimmed = newQuery.trim();
    final currentState = state.value;
    if (currentState != null && currentState.query == trimmed) return;

    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final client = ref.read(contentApiProvider);
      const limit = 20;

      final request = ListRequest(
        query: trimmed,
        limit: Int64(limit),
        after: null,
      );

      final response = await client.list(request);
      final hasMore =
          response.after != Int64.ZERO && response.results.length >= limit;

      return ContentListState(
        items: response.results,
        query: trimmed,
        filterType: currentState?.filterType ?? ContentFilterType.all,
        limit: limit,
        after: response.after,
        hasMore: hasMore,
      );
    });
  }

  void setFilterType(ContentFilterType filterType) {
    final currentState = state.value;
    if (currentState == null || currentState.filterType == filterType) return;
    state = AsyncData(currentState.copyWith(filterType: filterType));
  }
}

// State model for the content browser page
class ContentListState {
  final List<Content> items;
  final String query;
  final ContentFilterType filterType;
  final int limit;
  final Int64? after;
  final bool hasMore;

  ContentListState({
    required this.items,
    required this.query,
    required this.filterType,
    required this.limit,
    this.after,
    required this.hasMore,
  });

  List<Content> get filteredItems {
    if (filterType == ContentFilterType.all) return items;
    return items.where((item) {
      final type = item.type.toLowerCase();
      switch (filterType) {
        case ContentFilterType.all:
          return true;
        case ContentFilterType.video:
          return type.contains('video');
        case ContentFilterType.image:
          return type.contains('image');
        case ContentFilterType.subtitle:
          return type.contains('subtitle') || type.contains('sub');
        case ContentFilterType.audio:
          return type.contains('audio');
      }
    }).toList();
  }

  ContentListState copyWith({
    List<Content>? items,
    String? query,
    ContentFilterType? filterType,
    int? limit,
    Int64? after,
    bool? hasMore,
  }) {
    return ContentListState(
      items: items ?? this.items,
      query: query ?? this.query,
      filterType: filterType ?? this.filterType,
      limit: limit ?? this.limit,
      after: after ?? this.after,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}
