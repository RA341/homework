import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:homework/+route.dart';
import 'package:homework/components/navigation/nav.items.dart';

class BottomNavigation extends ConsumerWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).uri.path;
    final activeIndex = navItems.indexWhere(
      (item) =>
          location == item.route.path ||
          (item.route.path != '/' && location.startsWith(item.route.path)),
    );
    final selectedIndex = activeIndex != -1 ? activeIndex : 0;

    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) {
        navItems[index].route.go(context);
      },
      destinations: navItems.map((item) {
        return NavigationDestination(
          icon: Icon(item.icon),
          selectedIcon: Icon(item.activeIcon),
          label: item.label,
        );
      }).toList(),
    );
  }
}
