import 'package:flutter/material.dart';
import 'package:homework/common/theme/design_system.dart';

class SearchFilterBar extends StatelessWidget {
  final TextEditingController searchController;
  final bool isGridView;
  final ValueChanged<bool> onLayoutChanged;
  final String selectedFilterType;
  final ValueChanged<String> onFilterTypeChanged;

  const SearchFilterBar({
    super.key,
    required this.searchController,
    required this.isGridView,
    required this.onLayoutChanged,
    required this.selectedFilterType,
    required this.onFilterTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            // Search Input Field
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ListenableBuilder(
                  listenable: searchController,
                  builder: (context, child) {
                    return TextField(
                      controller: searchController,
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.onSurface,
                      ),
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
                                  FocusScope.of(context).unfocus();
                                },
                              )
                            : null,
                        labelText: 'Search items',
                        hintText: 'Type query parameters...',
                      ),
                    );
                  },
                ),
              ),
            ),
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
                  _buildLayoutToggle(
                    icon: Icons.grid_view_rounded,
                    isGrid: true,
                  ),
                  _buildLayoutToggle(icon: Icons.list_rounded, isGrid: false),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.base * 2.5),
        // Filter chips row
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: ['All', 'Video', 'Image', 'Subtitle', 'Audio'].map((
              type,
            ) {
              final isSelected = selectedFilterType == type;
              return Padding(
                padding: const EdgeInsets.only(right: AppSpacing.base),
                child: ChoiceChip(
                  label: Text(type),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      onFilterTypeChanged(type);
                    }
                  },
                  backgroundColor: AppColors.level1,
                  selectedColor: AppColors.primary.withValues(alpha: 0.15),
                  labelStyle: AppTypography.labelMd.copyWith(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.onSurfaceVariant,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
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
        ),
      ],
    );
  }

  Widget _buildLayoutToggle({required IconData icon, required bool isGrid}) {
    final isSelected = isGridView == isGrid;
    return IconButton(
      icon: Icon(icon),
      onPressed: () => onLayoutChanged(isGrid),
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
