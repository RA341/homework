import 'package:flutter/material.dart';
import 'package:homework/components/theme/design_system.dart';

class SettingsDownloadsPage extends StatelessWidget {
  const SettingsDownloadsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.gutter),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Configure downloads settings and options.',
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
                    'Download Location',
                    style: AppTypography.bodyMd.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.base * 2),
                  Text(
                    'Choose where downloaded media files are stored.',
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.base * 3),
                  const TextField(
                    decoration: InputDecoration(
                      labelText: 'Download Path',
                      hintText: 'e.g., /Downloads',
                    ),
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
