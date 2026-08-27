import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:homework/pages/browse/download/provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SearchBar extends HookConsumerWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(downloadSearchProvider);
    final searchController = useTextEditingController(text: searchQuery ?? '');
    useListenable(searchController);

    useEffect(() {
      if (searchController.text != (searchQuery ?? '')) {
        searchController.text = searchQuery ?? '';
      }
      return null;
    }, [searchQuery]);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: 'Search downloads...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
                    ref.read(downloadSearchProvider.notifier).clear();
                  },
                )
              : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        onSubmitted: (val) =>
            ref.read(downloadSearchProvider.notifier).search(val),
      ),
    );
  }
}
