import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:homework/components/theme/design_system.dart';
import 'package:homework/pages/settings/nav.items.dart';

class SettingsLayout extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const SettingsLayout({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.level0,
      body: Column(
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
                for (int i = 0; i < settingsTabs.length; i++) ...[
                  if (i > 0) const SizedBox(width: AppSpacing.base * 4),
                  _SettingsTab(
                    tab: settingsTabs[i],
                    index: i,
                    navigationShell: navigationShell,
                  ),
                ],
              ],
            ),
          ),
          Expanded(child: navigationShell),
        ],
      ),
    );
  }
}

class _SettingsTab extends StatelessWidget {
  final SettingsTabItem tab;
  final int index;
  final StatefulNavigationShell navigationShell;

  const _SettingsTab({
    required this.tab,
    required this.index,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = navigationShell.currentIndex == index;

    return InkWell(
      onTap: () {
        if (!isActive) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
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
              tab.icon,
              size: 18,
              color: isActive
                  ? AppColors.primary
                  : AppColors.onSurfaceVariant.withAlpha(160),
            ),
            const SizedBox(width: 8),
            Text(
              tab.title,
              style: AppTypography.bodySm.copyWith(
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                color: isActive
                    ? AppColors.onSurface
                    : AppColors.onSurfaceVariant.withAlpha(200),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
