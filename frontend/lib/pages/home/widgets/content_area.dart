import 'package:flutter/material.dart';
import 'package:homework/components/theme/design_system.dart';
import 'package:homework/generated/sdk/content/v1/content.pb.dart';
import 'package:homework/pages/home/content_browser_provider.dart';
import 'package:homework/pages/home/widgets/content_card.dart';
import 'package:homework/pages/home/widgets/content_list_tile.dart';
import 'package:homework/pages/home/widgets/empty_state.dart';
import 'package:homework/pages/home/widgets/error_state.dart';
import 'package:homework/pages/home/widgets/skeleton_loader.dart';

class ContentArea extends StatelessWidget {
  final ContentBrowserState browserState;
  final List<Content> items;
  final bool isDesktop;
  final bool isGridView;
  final TextEditingController searchController;
  final VoidCallback onRetry;
  final VoidCallback onLoadMore;
  final ValueChanged<Content> onItemTap;

  const ContentArea({
    super.key,
    required this.browserState,
    required this.items,
    required this.isDesktop,
    required this.isGridView,
    required this.searchController,
    required this.onRetry,
    required this.onLoadMore,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    if (browserState.isLoading && items.isEmpty) {
      return SkeletonLoader(
        isGridView: isGridView,
        isDesktop: isDesktop,
      );
    }

    if (browserState.errorMessage != null && items.isEmpty) {
      return ErrorState(
        message: browserState.errorMessage!,
        onRetry: onRetry,
      );
    }

    if (items.isEmpty) {
      return EmptyState(
        showClearButton: searchController.text.isNotEmpty,
        onClearSearch: () => searchController.clear(),
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
                        : (MediaQuery.of(context).size.width >= 480 ? 2 : 1),
                    crossAxisSpacing: AppSpacing.gutter,
                    mainAxisSpacing: AppSpacing.gutter,
                    childAspectRatio: 1.5,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) => ContentCard(
                    item: items[index],
                    onTap: () => onItemTap(items[index]),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: AppSpacing.gutter),
                  itemCount: items.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.base * 2),
                    child: ContentListTile(
                      item: items[index],
                      onTap: () => onItemTap(items[index]),
                    ),
                  ),
                ),
        ),
        if (browserState.hasMore) ...[
          const SizedBox(height: AppSpacing.base * 2),
          Center(
            child: browserState.isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primary,
                    ),
                  )
                : TextButton.icon(
                    onPressed: onLoadMore,
                    icon: const Icon(Icons.arrow_downward_rounded, size: 16),
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
  }
}
