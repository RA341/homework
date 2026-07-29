import 'package:flutter/material.dart';
import 'package:homework/common/theme/design_system.dart';
import 'package:homework/pages/browse/+layout.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BrowseLayout(
      activeTab: 0,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.gutter),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Placeholder Search Bar to show how it will look
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.level1,
                borderRadius: AppShapes.radiusDefault,
                border: Border.all(
                  color: AppColors.outlineVariant,
                  width: 1.0,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search_rounded,
                    color: AppColors.onSurfaceVariant.withAlpha(120),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Search assets...',
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.onSurfaceVariant.withAlpha(120),
                    ),
                  ),
                ],
              ),
            ),
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off_rounded,
                      color: AppColors.outline,
                      size: 64,
                    ),
                    SizedBox(height: AppSpacing.base * 2.5),
                    Text(
                      'Asset Search Stub',
                      style: TextStyle(
                        fontFamily: 'Sora',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                      ),
                    ),
                    SizedBox(height: AppSpacing.base * 1.5),
                    Text(
                      'Search functionality is currently a placeholder.\nUse the Upload tab to add files to the queue.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: AppColors.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
