import 'package:flutter/material.dart';
import 'package:homework/components/theme/design_system.dart';
import 'package:homework/pages/settings/general/components/card.clear_local_data.dart';
import 'package:homework/pages/settings/general/components/card.service_url.dart';

class SettingsGeneralPage extends StatelessWidget {
  const SettingsGeneralPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.gutter),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Configure app settings and connection preferences.',
            style: AppTypography.bodyMd.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.base * 4),
          const CardServiceUrl(),
          const SizedBox(height: AppSpacing.base * 4),
          const CardClearLocalData(),
        ],
      ),
    );
  }
}
