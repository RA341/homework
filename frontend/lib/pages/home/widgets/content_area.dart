import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homework/common/services/asset/asset.provider.dart';
import 'package:homework/components/theme/design_system.dart';
import 'package:homework/generated/sdk/content/v1/content.pb.dart';
import 'package:homework/pages/home/provider.content.gridview.dart';
import 'package:homework/pages/home/provider.content.list.dart';
import 'package:homework/pages/home/widgets/content_grid_card.dart';
import 'package:homework/pages/home/widgets/content_list_card.dart';
import 'package:homework/pages/home/widgets/empty_state.dart';
import 'package:homework/pages/home/widgets/error_state.dart';
import 'package:homework/pages/home/widgets/skeleton_loader.dart';
import 'package:homework/pages/home/widgets/video_player_screen.dart';

class ContentList extends ConsumerWidget {
  const ContentList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final browserList = ref.watch(contentListProvider);
    final isGridView = ref.watch(isGridViewProvider);

    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= 720;

    return browserList.when(
      loading: () =>
          SkeletonLoader(isGridView: isGridView, isDesktop: isDesktop),
      error: (err, stack) => ErrorState(
        message: err.toString().replaceFirst('Exception: ', ''),
        onRetry: () =>
            ref.read(contentListProvider.notifier).loadNextPage(reset: true),
      ),
      data: (browserState) {
        final items = browserState.filteredItems;

        if (items.isEmpty) {
          return EmptyState(
            showClearButton:
                browserState.query.isNotEmpty ||
                browserState.filterType != ContentFilterType.all,
            onClearSearch: () {
              ref.read(contentListProvider.notifier).setQuery('');
              ref
                  .read(contentListProvider.notifier)
                  .setFilterType(ContentFilterType.all);
            },
          );
        }

        return Column(
          children: [
            Expanded(
              child: isGridView
                  ? GridView.builder(
                      padding: const EdgeInsets.only(bottom: AppSpacing.gutter),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isDesktop
                            ? 3
                            : (MediaQuery.of(context).size.width >= 480
                                  ? 2
                                  : 1),
                        crossAxisSpacing: AppSpacing.gutter,
                        mainAxisSpacing: AppSpacing.gutter,
                        childAspectRatio: 1.5,
                      ),
                      itemCount: items.length,
                      itemBuilder: (context, index) => ContentGridCard(
                        item: items[index],
                        onTap: () => _onItemTap(context, ref, items[index]),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: AppSpacing.gutter),
                      itemCount: items.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.only(
                          bottom: AppSpacing.base * 2,
                        ),
                        child: ContentListTile(
                          item: items[index],
                          onTap: () => _onItemTap(context, ref, items[index]),
                        ),
                      ),
                    ),
            ),
            if (browserState.hasMore) ...[
              const SizedBox(height: AppSpacing.base * 2),
              Center(
                child: browserList.isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary,
                        ),
                      )
                    : TextButton.icon(
                        onPressed: () => ref
                            .read(contentListProvider.notifier)
                            .loadNextPage(),
                        icon: const Icon(
                          Icons.arrow_downward_rounded,
                          size: 16,
                        ),
                        label: const Text('Load More'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          textStyle: AppTypography.labelMd.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
              ),
            ],
          ],
        );
      },
    );
  }

  void _onItemTap(BuildContext context, WidgetRef ref, Content item) {
    final type = item.type.toLowerCase();
    if (type.contains('video')) {
      final videoUrl = ref
          .read(assetServiceProvider)
          .load(contentId: item.id.toInt(), assetRole: 'Main');
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              VideoLayout(initialItem: item, initialVideoUrl: videoUrl),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.info_outline_rounded, color: AppColors.primary),
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
            side: const BorderSide(color: AppColors.outlineVariant, width: 1.0),
          ),
        ),
      );
    }
  }
}
