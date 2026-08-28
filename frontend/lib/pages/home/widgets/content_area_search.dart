import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:homework/components/theme/design_system.dart';
import 'package:homework/pages/home/provider.content.gridview.dart';
import 'package:homework/pages/home/provider.content.list.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SearchFilterBar extends HookConsumerWidget {
  const SearchFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            // Search Input Field
            Expanded(child: _SearchBar()),
            const SizedBox(width: AppSpacing.base * 2),
            // Layout toggles
            Container(
              decoration: BoxDecoration(
                color: AppColors.level1,
                borderRadius: AppShapes.radiusDefault,
                border: Border.all(color: AppColors.outlineVariant, width: 1.0),
              ),
              padding: const EdgeInsets.all(4),
              child: Row(
                children: [
                  _LayoutToggle(icon: Icons.grid_view_rounded, isGrid: true),
                  _LayoutToggle(icon: Icons.list_rounded, isGrid: false),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.base * 2.5),
        // Filter chips row
        _VideoTypeSelector(),
      ],
    );
  }
}

class _VideoTypeSelector extends ConsumerWidget {
  const _VideoTypeSelector();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final browserState = ref.watch(contentListProvider).value;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: ContentFilterType.values.map((filterType) {
          final isSelected =
              (browserState?.filterType ?? ContentFilterType.all) == filterType;

          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.base),
            child: ChoiceChip(
              label: Text(filterType.label),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  ref
                      .read(contentListProvider.notifier)
                      .setFilterType(filterType);
                }
              },
              backgroundColor: AppColors.level1,
              selectedColor: AppColors.primary.withValues(alpha: 0.15),
              labelStyle: AppTypography.labelMd.copyWith(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: AppShapes.radiusDefault,
                side: BorderSide(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.outlineVariant,
                  width: 1.0,
                ),
              ),
              showCheckmark: false,
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _SearchBar extends HookConsumerWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final browserState = ref.watch(contentListProvider).value;

    final searchController = useTextEditingController(
      text: browserState?.query ?? '',
    );
    useListenable(searchController);

    // Sync controller text if query was reset externally (e.g. clear search button)
    useEffect(() {
      if (browserState != null &&
          searchController.text != browserState.query &&
          browserState.query.isEmpty &&
          searchController.text.isNotEmpty) {
        searchController.text = '';
      }
      return null;
    }, [browserState?.query]);

    // Handle debounced search query update
    useEffect(() {
      Timer? debounceTimer;
      void listener() {
        debounceTimer?.cancel();
        debounceTimer = Timer(const Duration(milliseconds: 500), () {
          ref
              .read(contentListProvider.notifier)
              .setQuery(searchController.text);
        });
      }

      searchController.addListener(listener);
      return () {
        searchController.removeListener(listener);
        debounceTimer?.cancel();
      };
    }, [searchController]);

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: searchController,
        style: AppTypography.bodySm.copyWith(color: AppColors.onSurface),
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.onSurfaceVariant,
          ),
          suffixIcon: searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.clear_rounded,
                    color: AppColors.onSurfaceVariant,
                  ),
                  onPressed: () {
                    searchController.clear();
                    ref.read(contentListProvider.notifier).setQuery('');
                    FocusScope.of(context).unfocus();
                  },
                )
              : null,
          labelText: 'Search items',
          hintText: 'Type query parameters...',
        ),
      ),
    );
  }
}

class _LayoutToggle extends ConsumerWidget {
  const _LayoutToggle({required this.icon, required this.isGrid});

  final IconData icon;
  final bool isGrid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isGridView = ref.watch(isGridViewProvider);
    final isSelected = isGridView == isGrid;
    return IconButton(
      icon: Icon(icon),
      onPressed: () =>
          ref.read(isGridViewProvider.notifier).setGridView(isGrid),
      color: isSelected
          ? AppColors.primary
          : AppColors.onSurfaceVariant.withValues(alpha: 0.6),
      iconSize: 20,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
      style: IconButton.styleFrom(
        backgroundColor: isSelected ? AppColors.level0 : Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: AppShapes.radiusDefault),
      ),
    );
  }
}
