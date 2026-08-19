import 'package:flutter/material.dart';
import 'package:homework/components/theme/design_system.dart';

class AuthLayout extends StatelessWidget {
  final Widget child;

  const AuthLayout({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.level0,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 420),
            padding: const EdgeInsets.all(AppSpacing.margin),
            decoration: BoxDecoration(
              color: AppColors.level1,
              borderRadius: AppShapes.radiusLg,
              border: Border.all(color: const Color(0xFF2C2928), width: 1.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Modern Obsidian Logo Placeholder / Icon
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.base * 2.5),
                    decoration: BoxDecoration(
                      color: AppColors.level0,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primary.withAlpha(40),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.hub_outlined,
                      color: AppColors.primary,
                      size: 48,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.base * 4),
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
