import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:homework/+route.dart';
import 'package:homework/components/theme/design_system.dart';

class BrowseLayout extends StatelessWidget {
  final int activeTab;
  final Widget child;

  const BrowseLayout({
    super.key,
    required this.activeTab,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border(
              bottom: BorderSide(
                color: AppColors.outlineVariant.withAlpha(80),
                width: 1.0,
              ),
            ),
          ),
          child: Row(
            children: [
              _buildTab(
                context,
                title: 'Download',
                icon: Icons.search_rounded,
                index: 0,
                route: AppRoutes.download,
              ),
              const SizedBox(width: AppSpacing.base * 4),
              _buildTab(
                context,
                title: 'Upload',
                icon: Icons.cloud_upload_outlined,
                index: 1,
                route: AppRoutes.upload,
              ),
            ],
          ),
        ),
        Expanded(
          child: child,
        ),
      ],
    );
  }

  Widget _buildTab(BuildContext context, {
    required String title,
    required IconData icon,
    required int index,
    required GoRouteData route,
  }) {
    final isActive = activeTab == index;

    return InkWell(
      onTap: () {
        if (!isActive) {
          route.go(context);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 8.0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? AppColors.primary : Colors.transparent,
              width: 2.0,
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isActive ? AppColors.primary : AppColors.onSurfaceVariant.withAlpha(160),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: AppTypography.bodySm.copyWith(
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                color: isActive ? AppColors.onSurface : AppColors.onSurfaceVariant.withAlpha(200),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
