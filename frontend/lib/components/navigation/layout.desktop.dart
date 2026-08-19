import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:homework/+route.dart';
import 'package:homework/components/navigation/nav.items.dart';
import 'package:homework/components/theme/design_system.dart';

class SidebarNavigation extends ConsumerWidget {
  const SidebarNavigation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).uri.path;
    final activeIndex = navItems.indexWhere((item) =>
        location == item.route.path ||
        (item.route.path != '/' && location.startsWith(item.route.path)));
    final theme = Theme.of(context);

    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: AppColors.level1, // Level 1 for Navigation container
        border: Border(
          right: BorderSide(
            color: theme.colorScheme.outlineVariant.withAlpha(50),
            width: 1.0,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo / Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 28.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha(30),
                    borderRadius: AppShapes.radiusDefault,
                  ),
                  child: const Icon(
                    Icons.school_rounded,
                    color: AppColors.primary,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Homework',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontFamily: AppTypography.headlineLg.fontFamily,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                    color: AppColors.onSurface,
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(color: Colors.white10),
          ),
          const SizedBox(height: 16),
          // Nav items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: navItems.length,
              itemBuilder: (context, index) {
                final item = navItems[index];
                final isSelected = index == activeIndex;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: InkWell(
                    onTap: () {
                      item.route.go(context);
                    },
                    borderRadius: AppShapes.radiusDefault,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary.withAlpha(30)
                            : Colors.transparent,
                        borderRadius: AppShapes.radiusDefault,
                        border: isSelected
                            ? Border.all(color: AppColors.primary.withAlpha(80), width: 1.0)
                            : Border.all(color: Colors.transparent, width: 1.0),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isSelected ? item.activeIcon : item.icon,
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.onSurfaceVariant,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            item.label,
                            style: AppTypography.bodySm.copyWith(
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected
                                  ? AppColors.onSurface
                                  : AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Footer User Profile
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(color: Colors.white10),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.secondary,
                  child: const Text('JD', style: TextStyle(color: AppColors.onSecondary)),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'John Doe',
                      style: AppTypography.bodySm.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                      ),
                    ),
                    Text(
                      'Student account',
                      style: AppTypography.labelMd.copyWith(
                        color: AppColors.onSurfaceVariant.withAlpha(150),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
