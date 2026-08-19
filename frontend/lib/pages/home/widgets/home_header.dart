import 'package:flutter/material.dart';
import 'package:homework/+route.dart';
import 'package:homework/components/theme/design_system.dart';

class HomeHeader extends StatelessWidget {
  final int filteredCount;
  final int totalCount;

  const HomeHeader({
    super.key,
    required this.filteredCount,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Content Hub',
              style: AppTypography.headlineLg.copyWith(
                color: AppColors.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.greenAccent,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Showing $filteredCount of $totalCount total assets',
                  style: AppTypography.labelMd.copyWith(
                    color: AppColors.onSurfaceVariant.withValues(alpha: 0.8),
                    letterSpacing: 0.1,
                  ),
                ),
              ],
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () {
            AppRoutes.browse.go(context);
          },
          icon: const Icon(Icons.cloud_upload_outlined, size: 18),
          label: const Text('Add Asset'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.base * 2.5,
              vertical: AppSpacing.base * 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
