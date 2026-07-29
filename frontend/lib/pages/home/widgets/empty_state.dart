import 'package:flutter/material.dart';
import 'package:homework/common/theme/design_system.dart';

class EmptyState extends StatelessWidget {
  final bool showClearButton;
  final VoidCallback onClearSearch;

  const EmptyState({
    super.key,
    required this.showClearButton,
    required this.onClearSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.base * 3),
              decoration: BoxDecoration(
                color: AppColors.level1,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.outlineVariant.withValues(alpha: 0.5),
                  width: 1.5,
                ),
              ),
              child: const Icon(
                Icons.folder_open_rounded,
                color: AppColors.onSurfaceVariant,
                size: 64,
              ),
            ),
            const SizedBox(height: AppSpacing.base * 3),
            Text(
              'No assets found',
              style: AppTypography.headlineLgMobile.copyWith(
                color: AppColors.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.base * 1.5),
            Text(
              'We couldn\'t find any items matching your criteria.\nTry uploading new assets or clearing your query.',
              textAlign: TextAlign.center,
              style: AppTypography.bodySm.copyWith(
                color: AppColors.onSurfaceVariant,
                height: 1.4,
              ),
            ),
            if (showClearButton) ...[
              const SizedBox(height: AppSpacing.base * 3),
              OutlinedButton.icon(
                onPressed: onClearSearch,
                icon: const Icon(Icons.clear_all_rounded, size: 16),
                label: const Text('Clear Search Filter'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
