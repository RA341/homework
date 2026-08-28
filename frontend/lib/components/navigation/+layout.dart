import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:homework/+route.dart';
import 'package:homework/components/navigation/layout.desktop.dart';
import 'package:homework/components/navigation/layout.mobile.dart';
import 'package:homework/components/navigation/nav.items.dart';

class RootLayout extends ConsumerWidget {
  final Widget child;

  const RootLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 720;

        return Scaffold(
          body: Row(
            children: [
              if (isDesktop) const SidebarNavigation(),
              Expanded(child: child),
            ],
          ),
          bottomNavigationBar: isDesktop ? null : const BottomNavigation(),
        );
      },
    );
  }
}
