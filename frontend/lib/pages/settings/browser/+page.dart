import 'package:flutter/material.dart';
import 'package:homework/components/theme/design_system.dart';

class SettingsBrowserPage extends StatelessWidget {
  const SettingsBrowserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.gutter),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Configure internal browser settings and preferences.',
            style: AppTypography.bodyMd.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.base * 4),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.gutter),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Browser History',
                    style: AppTypography.bodyMd.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.base * 2),
                  Text(
                    'Manage your saved data and history.',
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.base * 3),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Clear Browser History'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
