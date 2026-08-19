import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:homework/+route.dart';
import 'package:homework/components/navigation/layout.desktop.dart';
import 'package:homework/components/navigation/nav.items.dart';
import 'package:homework/components/navigation/layout.mobile.dart';
import 'package:homework/components/theme/design_system.dart';

class RootLayout extends ConsumerWidget {
  final Widget child;

  const RootLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).uri.path;
    final activeIndex = navItems.indexWhere(
      (item) =>
          location == item.route.path ||
          (item.route.path != '/' && location.startsWith(item.route.path)),
    );

    final activeItem = activeIndex != -1 ? navItems[activeIndex] : navItems[0];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 720;

        return Scaffold(
          body: Row(
            children: [
              if (isDesktop) const SidebarNavigation(),
              Expanded(
                child: Column(
                  children: [
                    // Top App Bar for context header
                    AppBar(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      title: Text(
                        activeItem.label,
                        style: AppTypography.headlineLg.copyWith(
                          fontSize: 22,
                          letterSpacing: -0.5,
                        ),
                      ),
                      centerTitle: !isDesktop,
                    ),
                    Expanded(child: child),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: isDesktop ? null : const BottomNavigation(),
        );
      },
    );
  }
}
