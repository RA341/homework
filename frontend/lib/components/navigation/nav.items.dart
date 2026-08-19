
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:homework/+route.dart';

class NavItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final GoRouteData route;

  const NavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.route,
  });
}

final navItems = <NavItem>[
  const NavItem(
    label: 'Home',
    icon: Icons.dashboard_outlined,
    activeIcon: Icons.dashboard_rounded,
    route: AppRoutes.home,
  ),
  const NavItem(
    label: 'Browse',
    icon: Icons.add_circle_outline_rounded,
    activeIcon: Icons.add_circle_rounded,
    route: AppRoutes.browse,
  ),
  const NavItem(
    label: 'Settings',
    icon: Icons.settings_outlined,
    activeIcon: Icons.settings_rounded,
    route: AppRoutes.settingsGeneral,
  ),
];
