import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:homework/common/api/asset/asset.provider.dart';
import 'package:homework/common/theme/design_system.dart';
import 'package:homework/pages/home/content_browser_provider.dart';
import 'package:homework/pages/home/widgets/content_area.dart';
import 'package:homework/pages/home/widgets/home_header.dart';
import 'package:homework/pages/home/widgets/search_filter_bar.dart';
import 'package:homework/pages/home/widgets/video_player_screen.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    final selectedFilterType = useState('All');
    final isGridView = useState(true);

    final browserState = ref.watch(contentBrowserProvider);
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= 720;

    // Use effect to handle debounced search query updates
    useEffect(() {
      Timer? debounceTimer;
      void listener() {
        if (debounceTimer?.isActive ?? false) debounceTimer!.cancel();
        debounceTimer = Timer(const Duration(milliseconds: 500), () {
          ref
              .read(contentBrowserProvider.notifier)
              .setQuery(searchController.text.trim());
        });
      }
      searchController.addListener(listener);
      return () {
        searchController.removeListener(listener);
        debounceTimer?.cancel();
      };
    }, [searchController]);

    // Filter list locally based on content type filter chip
    final filteredItems = browserState.items.where((item) {
      final filter = selectedFilterType.value;
      if (filter == 'All') return true;
      final type = item.type.toLowerCase();
      if (filter == 'Video' && type.contains('video')) return true;
      if (filter == 'Image' && type.contains('image')) return true;
      if (filter == 'Subtitle' &&
          (type.contains('subtitle') || type.contains('sub'))) {
        return true;
      }
      if (filter == 'Audio' && type.contains('audio')) return true;
      return false;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.level0,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.gutter,
            vertical: AppSpacing.base * 2,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Row
              HomeHeader(
                filteredCount: filteredItems.length,
                totalCount: browserState.items.length,
              ),
              const SizedBox(height: AppSpacing.base * 3),

              // Search & Filter Panel
              SearchFilterBar(
                searchController: searchController,
                isGridView: isGridView.value,
                onLayoutChanged: (isGrid) {
                  isGridView.value = isGrid;
                },
                selectedFilterType: selectedFilterType.value,
                onFilterTypeChanged: (type) {
                  selectedFilterType.value = type;
                },
              ),
              const SizedBox(height: AppSpacing.base * 3),

              // Content Area
              Expanded(
                child: RefreshIndicator(
                  color: AppColors.primary,
                  backgroundColor: AppColors.level2,
                  onRefresh: () => ref
                      .read(contentBrowserProvider.notifier)
                      .loadNextPage(reset: true),
                  child: ContentArea(
                    browserState: browserState,
                    items: filteredItems,
                    isDesktop: isDesktop,
                    isGridView: isGridView.value,
                    searchController: searchController,
                    onRetry: () => ref
                        .read(contentBrowserProvider.notifier)
                        .loadNextPage(reset: true),
                    onLoadMore: () => ref
                        .read(contentBrowserProvider.notifier)
                        .loadNextPage(),
                    onItemTap: (item) {
                      final type = item.type.toLowerCase();
                      if (type.contains('video')) {
                        final videoUrl = ref.read(assetServiceProvider).load(
                          contentId: item.id.toInt(),
                          assetRole: 'Main',
                        );
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => VideoPlayerScreen(
                              initialItem: item,
                              initialVideoUrl: videoUrl,
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                const Icon(
                                  Icons.info_outline_rounded,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: AppSpacing.base),
                                Expanded(
                                  child: Text(
                                    'Unimplemented media format: ${item.type}',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            backgroundColor: AppColors.level2,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: AppShapes.radiusDefault,
                              side: const BorderSide(
                                color: AppColors.outlineVariant,
                                width: 1.0,
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
