import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homework/common/api/endpoints/content_provider.dart';
import 'package:homework/generated/sdk/content/v1/content.pb.dart';

final contentBrowserProvider =
    NotifierProvider<ContentBrowserNotifier, ContentBrowserState>(
      ContentBrowserNotifier.new,
      isAutoDispose: true,
    );

// State model for the content browser page
class ContentBrowserState {
  final List<Content> items;
  final bool isLoading;
  final String? errorMessage;
  final String query;
  final int limit;
  final Int64? after;
  final bool hasMore;

  ContentBrowserState({
    required this.items,
    required this.isLoading,
    this.errorMessage,
    required this.query,
    required this.limit,
    this.after,
    required this.hasMore,
  });

  ContentBrowserState copyWith({
    List<Content>? items,
    bool? isLoading,
    String? errorMessage,
    String? query,
    int? limit,
    Int64? after,
    bool? hasMore,
  }) {
    return ContentBrowserState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      query: query ?? this.query,
      limit: limit ?? this.limit,
      after: after ?? this.after,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

// Notifier that handles querying and pagination for ContentServiceClient
class ContentBrowserNotifier extends Notifier<ContentBrowserState> {
  @override
  ContentBrowserState build() {
    Future.microtask(() => loadNextPage(reset: true));
    return ContentBrowserState(
      items: [],
      isLoading: true,
      query: '',
      limit: 20,
      hasMore: true,
    );
  }

  Future<void> loadNextPage({bool reset = false}) async {
    if (state.isLoading && !reset && state.items.isNotEmpty) return;

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final client = ref.read(contentApiProvider);

      final nextAfter = reset ? null : state.after;
      final request = ListRequest(
        query: state.query,
        limit: Int64(state.limit),
        after: nextAfter,
      );

      final response = await client.list(request);

      final newItems = response.results;
      final updatedItems = reset ? newItems : [...state.items, ...newItems];

      // If server returned after > 0 and results matching the limit, we assume more exist
      final hasMore =
          response.after != Int64.ZERO &&
          response.results.length >= state.limit;

      state = state.copyWith(
        items: updatedItems,
        isLoading: false,
        after: response.after,
        hasMore: hasMore,
      );
    } catch (e) {
      final err = e.toString().replaceFirst('Exception: ', '');
      state = state.copyWith(isLoading: false, errorMessage: err);
    }
  }

  void setQuery(String newQuery) {
    if (state.query == newQuery) return;
    state = state.copyWith(
      query: newQuery,
      items: [],
      after: null,
      hasMore: true,
    );
    loadNextPage(reset: true);
  }
}
